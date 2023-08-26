import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahmine/features/group_management/presentation/screen/transaction_screen.dart';
import 'package:uuid/uuid.dart';

import '../../data/model/groups.dart';
import '../bloc/group_bloc.dart'; // Import the GroupBloc
import '../bloc/group_event.dart';
import '../bloc/group_state.dart';

class ExpensesScreen extends StatefulWidget {
  final Group group;

  ExpensesScreen({required this.group});

  @override
  _ExpensesScreenState createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen> {
  late GroupBloc _groupBloc; // Declare the GroupBloc

  @override
  void initState() {
    super.initState();
    _groupBloc =
        BlocProvider.of<GroupBloc>(context); // Initialize the GroupBloc
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<GroupBloc, GroupState>(
          bloc: _groupBloc, // Provide the GroupBloc instance
          builder: (context, groupState) {
            return ListView.builder(
              itemCount: widget.group.transactions!.length,
              itemBuilder: (context, index) {
                final transaction = widget.group.transactions![index];
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
                      final transaction = widget.group.transactions![index];
                      _groupBloc.add(RemoveTransaction(
                        widget.group,
                        transaction.amountSpent,
                        transaction.description,
                      ));
                    }
                  },
                  child: Card(
                    elevation: 2.0,
                    margin: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    child: ListTile(
                      title: Text('Amount: ${transaction.amountSpent}'),
                      subtitle: Text('Payer: ${transaction.payer}'),
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TransactionScreen(
                              group: widget.group, // Pass the updated group
                              initialTransaction: transaction,
                            ),
                          ),
                        );
                        _groupBloc.add(UpdateGroups(
                            widget.group)); // Update the group in GroupBloc
                      },
                    ),
                  ),
                );
              },
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TransactionScreen(group: widget.group),
            ),
          );
          _groupBloc
              .add(UpdateGroups(widget.group)); // Update the group in GroupBloc
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
