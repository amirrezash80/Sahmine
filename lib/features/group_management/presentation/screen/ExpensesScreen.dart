// ExpensesScreen
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:sahmine/features/group_management/presentation/screen/transaction_screen.dart';
import '../../data/model/groups.dart';
import '../cubit/transaction_cubit.dart';

class ExpensesScreen extends StatefulWidget {
  final Group group;

  ExpensesScreen({required this.group});

  @override
  _ExpensesScreenState createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: BlocBuilder<TransactionCubit, TransactionState>(
        builder: (context, state) {
          var transactions = widget.group?.transactions;
          return ListView.builder(
            itemCount: transactions?.length,
            itemBuilder: (context, index) {
              final transaction = transactions?[index];
              return Card(
                elevation: 2.0,
                margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: ListTile(
                  title: Text('Amount: ${transaction?.amountSpent}'),
                  subtitle: Text('Payer: ${transaction?.payer}'),
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TransactionScreen(
                          group: widget.group,
                          initialTransaction: transaction,
                        ),
                      ),
                    );
                    // Refresh transactions after returning from TransactionScreen
                    context.read<TransactionCubit>().fetchTransactions();
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TransactionScreen(group: widget.group),
            ),
          );
          // Refresh transactions after returning from TransactionScreen
          context.read<TransactionCubit>().fetchTransactions();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
