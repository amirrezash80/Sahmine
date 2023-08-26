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
  List<Users>? users;

  @HiveField(4)
  List<Transaction>? transactions;

  Group(
      this.id,
      this.groupName,
      this.description,
      this.transactions,
      [List<Users>? selectedUsers]
      );

  Group copyWith({
    int? id,
    String? groupName,
    String? description,
    List<Users>? users,
    List<Transaction>? transactions,
  }) {
    return Group(
      id ?? this.id,
      groupName ?? this.groupName,
      description ?? this.description,
      transactions ?? this.transactions,
      users ?? this.users,
    );
  }
}