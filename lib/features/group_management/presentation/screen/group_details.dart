import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/model/groups.dart';
import 'ExpensesScreen.dart';
import 'BalanceScreen.dart';

class GroupDetailsScreen extends StatelessWidget {
  final Group group;

  GroupDetailsScreen({required this.group});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.teal,
          title: Text(group.groupName),
          bottom: TabBar(
            unselectedLabelColor: Colors.black,
            indicatorColor: Colors.black,
            labelColor: Colors.white,
            tabs: [
              Tab(text: 'مخارج'),
              Tab(text: 'تراز مالی'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ExpensesScreen(group: group),
            BalanceScreen(users: group.users ?? [], transactions: group.transactions!,),
          ],
        ),
      ),
    );
  }
}
