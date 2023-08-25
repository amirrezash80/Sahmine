import 'package:hive/hive.dart';
import 'package:sahmine/features/home/data/model/user.dart';

import 'transaction.dart';

part 'groups.g.dart';

@HiveType(typeId: 1)
class Group extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String groupname;

  @HiveField(2)
  final String description;

  @HiveField(3)
  List<Users>? user;

  @HiveField(4)
  List<Transaction>? transactions; // Initialize here

  Group(this.id, this.groupname, this.description,
      this.transactions, // Initialize transactions here
      [List<Users>? selectedUsers]);
}
