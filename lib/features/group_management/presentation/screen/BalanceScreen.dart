import 'package:flutter/material.dart';
import '../../../home/data/model/user.dart';
import '../../data/model/groups.dart';

class BalanceScreen extends StatelessWidget {
  final List<Users> users;

  BalanceScreen({required this.users});

  @override
  Widget build(BuildContext context) {
    // Implement your UI for displaying balanced expenses and who owes money to whom
    return Scaffold(

      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          return Card(
            elevation: 2.0,
            margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: ListTile(
              title: Text(
                user.name.toString(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(user.balance.toString()),
              trailing: Icon(Icons.arrow_forward_ios),
            ),
          );
        },
      ),
    );
  }
}
