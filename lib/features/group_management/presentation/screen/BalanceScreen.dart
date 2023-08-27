import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:screenshot/screenshot.dart';

import '../../../home/data/model/user.dart';
import '../../data/model/groups.dart';
import '../../data/model/transaction.dart';
import '../bloc/group_bloc.dart';
import '../bloc/group_event.dart';
import '../bloc/group_state.dart';

class BalanceScreen extends StatefulWidget {
  final Group group;

  BalanceScreen({required this.group});

  @override
  _BalanceScreenState createState() => _BalanceScreenState();
}

class _BalanceScreenState extends State<BalanceScreen> {
  late List<Users> users;
  late Map<String, bool> debtStatus;
  late GroupBloc _groupBloc;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    users = widget.group.users ?? [];
    debtStatus = widget.group.debtStatus ?? {};
    _groupBloc = BlocProvider.of<GroupBloc>(context);
    _initializeDebtStatus();
  }

  void _initializeDebtStatus() {
    if (debtStatus.isEmpty) {
      final balances = calculateBalances(widget.group.transactions, users);
      balances.forEach((payer, amount) {
        if (amount < 0) {
          final owedUsers = balances.entries
              .where((entry) => entry.value > 0)
              .map((entry) =>
          '${entry.key} ${entry.value.abs().toStringAsFixed(0).seRagham()} ')
              .toList();

          if (owedUsers.isNotEmpty) {
            owedUsers.forEach((owedUser) {
              final debtKey = '$payer از $owedUserتومان طلبکار است';
              debtStatus[debtKey] = false;
              print(debtKey);
            });
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: BlocBuilder<GroupBloc, GroupState>(
          bloc: _groupBloc,
          builder: (context, groupState) {
            if (debtStatus.isEmpty) {
              return Center(
                child: Text('حسابتون صافه :)  ', style: TextStyle(color: Colors.green.shade700),),
              );
            } else {
              return ListView.builder(
                itemCount: debtStatus.length,
                itemBuilder: (context, index) {
                  final debtKey = debtStatus.keys.elementAt(index);
                  final isPaid = debtStatus[debtKey] ?? false;
                  return _buildDebtItem(context, debtKey, isPaid);
                },
              );
            }
          },
        ),
      ),
    );
  }



  Widget _buildDebtItem(BuildContext context, String debtKey, bool isPaid) {
    return Card(
      color: Colors.white,
      shadowColor: Colors.green,
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16),
        leading: Checkbox(
          value: isPaid,
          onChanged: (_) {
            setState(() {
              debtStatus[debtKey] = !isPaid;

              widget.group.debtStatus![debtKey] = !isPaid;

              final groupIndex = _groupBloc.state.groups
                  .indexWhere((g) => g.id == widget.group.id);
              if (groupIndex != -1) {
                final updatedGroup = widget.group.copyWith(
                  debtStatus: widget.group.debtStatus,
                );
                _groupBloc.add(UpdateGroups(updatedGroup));
              }
            });
          },
        ),
        title: Text(
          debtKey,
          style: TextStyle(
            decoration: isPaid
                ? TextDecoration.lineThrough
                : TextDecoration.none,
            color: isPaid ? Colors.blueGrey : Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
    );
  }

  Map<String, double> calculateBalances(
      List<Transaction>? transactions, List<Users> users) {
    Map<String, double> balances = {};

    for (var user in users) {
      balances[user.name] = 0.0;
    }

    if (transactions != null) {
      for (var transaction in transactions) {
        final payer = transaction.payer;
        final sharedCoefficients = transaction.sharedCoefficients;
        final totalAmount = transaction.amountSpent;
        final totalShares = sharedCoefficients.values
            .reduce((sum, coefficient) => sum + coefficient);

        balances[payer] = (balances[payer] ?? 0) - totalAmount;

        for (var sharedUser in sharedCoefficients.keys) {
          final coefficient = sharedCoefficients[sharedUser]!;
          final sharedAmount = totalAmount * coefficient / totalShares;
          balances[sharedUser] = (balances[sharedUser] ?? 0) + sharedAmount;
        }
      }
    }

    return balances;
  }
}
