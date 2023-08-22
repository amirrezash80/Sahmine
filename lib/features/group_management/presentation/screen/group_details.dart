import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/model/groups.dart';
import '../cubit/transaction_cubit.dart';
import 'ExpensesScreen.dart';
import 'BalanceScreen.dart';

class GroupDetailsScreen extends StatelessWidget {
  final Group group;

  GroupDetailsScreen({required this.group});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TransactionCubit(group)..fetchTransactions(),
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.teal,
            title: Text(group.groupname),
            bottom: TabBar(
              unselectedLabelColor: Colors.black,
              indicatorColor: Colors.black,
              labelColor: Colors.white,
              tabs: [
                Tab(text: 'مخارج'),
                Tab(text: 'سهم'),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              ExpensesScreen(group: group),
              BalanceScreen(users: group.user ?? []),
            ],
          ),
        ),
      ),
    );
  }
}
