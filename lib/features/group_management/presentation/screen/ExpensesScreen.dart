import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahmine/features/group_management/presentation/screen/transaction_screen.dart';
import 'package:screenshot/screenshot.dart';
import 'package:uuid/uuid.dart';

import '../../data/model/groups.dart';
import '../../data/model/transaction.dart';
import '../bloc/group_bloc.dart';
import '../bloc/group_event.dart';
import '../bloc/group_state.dart';

class ExpensesScreen extends StatefulWidget {
  final Group group;
  ExpensesScreen({required this.group});

  @override
  _ExpensesScreenState createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late GroupBloc _groupBloc;

  @override
  void initState() {
    super.initState();
    _groupBloc = BlocProvider.of<GroupBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        key: _scaffoldKey,
        body: BlocBuilder<GroupBloc, GroupState>(
          bloc: _groupBloc,
          builder: (context, groupState) {
            if(widget.group.transactions!.isEmpty){
              return Center(child: Text("شما هنوز هیچ تراکنشی را ثبت نکرده اید ." ,style: TextStyle(color: Colors.redAccent.shade700),),);
            }
            return ListView.builder(
              itemCount: widget.group.transactions!.length,
              itemBuilder: (context, index) {
                final transaction = widget.group.transactions![index];
                return _buildTransactionItem(context, transaction);
              },
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await _navigateToTransactionScreen(context, null);
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildTransactionItem(BuildContext context, Transaction transaction) {
    return Dismissible(
      key: Key(const Uuid().v4()),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        child: const Icon(Icons.delete),
      ),
      onDismissed: (direction) async {
        final confirmed = await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('تأیید حذف'),
            content: Text('آیا از حذف این تراکنش اطمینان دارید؟'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text('خیر'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text('بله'),
              ),
            ],
          ),
        );

        if (confirmed == true) {
          widget.group.debtStatus = {};
          _groupBloc.add(
            RemoveTransaction(
              widget.group,
              transaction.amountSpent,
              transaction.description,
            ),
          );
        }
      },
      child: Card(
        elevation: 2.0,
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          children: [
            ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        'پرداخت کننده: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text("${transaction.payer}",
                          style: TextStyle(color: Colors.blueGrey.shade600))
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'هزینه: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text("${transaction.amountSpent}",
                          style: TextStyle(color: Colors.blueGrey.shade600))
                    ],
                  ),
                ],
              ),
              onTap: () async {
                await _navigateToTransactionScreen(context, transaction);
              },
            ),
            ListTile(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'توضیحات: ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text("${transaction.description}",
                      style: TextStyle(color: Colors.blueGrey.shade600))
                ],
              ),
              onTap: () async {
                await _navigateToTransactionScreen(context, transaction);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _navigateToTransactionScreen(
      BuildContext context, Transaction? initialTransaction) async {
    final updatedGroup = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TransactionScreen(
          group: widget.group,
          initialTransaction: initialTransaction,
        ),
      ),
    );
    if (updatedGroup != null) {
      _groupBloc.add(UpdateGroups(updatedGroup));
    }
  }
}
