import 'package:flutter/material.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

import '../../../home/data/model/user.dart';
import '../../data/model/transaction.dart';

class BalanceScreen extends StatelessWidget {
  final List<Users> users;
  final List<Transaction> transactions;

  BalanceScreen({required this.users, required this.transactions});

  @override
  Widget build(BuildContext context) {
    final balances = calculateBalances(transactions, users);
    final List<Widget> owedWidgets = [];

    balances.forEach((payer, amount) {
      if (amount < 0) {
        final owedUsers = balances.entries
            .where((entry) => entry.value > 0)
            .map((entry) =>
                '${entry.key} ${entry.value.abs().toStringAsFixed(1).seRagham()} تومان')
            .toList();
        if (owedUsers.isNotEmpty) {
          owedUsers.forEach((owedUser) {
            owedWidgets.add(
              Card(
                child: ListTile(
                  title: Text(
                    '$payer از $owedUser طلبکار است',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  trailing: Icon(Icons.arrow_forward_ios),
                ),
              ),
            );
          });
        }
      }
    });
    if (owedWidgets.isEmpty) {
      owedWidgets.add(
        Center(
          child: Text("بدهکاری وجود ندارد"),
        )
      );
    }

    return Scaffold(
      body: ListView(
        children: owedWidgets
      ),
    );
  }

  Map<String, double> calculateBalances(
      List<Transaction> transactions, List<Users> users) {
    Map<String, double> balances = {};

    for (var user in users) {
      balances[user.name] = 0.0;
    }

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
    return balances;
  }
}
