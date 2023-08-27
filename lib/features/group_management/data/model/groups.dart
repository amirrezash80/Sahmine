import 'package:hive/hive.dart';
import 'package:sahmine/features/home/data/model/user.dart';

import 'transaction.dart';

part 'groups.g.dart';

@HiveType(typeId: 1)
class Group extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String groupName;

  @HiveField(2)
  final String description;

  @HiveField(3)
  late List<Users>? users;

  @HiveField(4)
  List<Transaction>? transactions;

  @HiveField(5)
  Map<String, bool>? debtStatus;

  Group(
    this.id,
    this.groupName,
    this.description,
    this.users,
    this.transactions,
    this.debtStatus,
  );

  Group copyWith({
    int? id,
    String? groupName,
    String? description,
    List<Users>? users,
    Map<String, bool>? debtStatus,
    List<Transaction>? transactions,
  }) {
    return Group(
      id ?? this.id,
      groupName ?? this.groupName,
      description ?? this.description,
      users ?? this.users,
      transactions ?? this.transactions,
      debtStatus ?? this.debtStatus,
    );
  }
}
