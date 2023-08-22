import 'package:hive/hive.dart';

part 'user.g.dart';


@HiveType(typeId: 0) // Assign a unique typeId

class Users {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  double? balance;
  @HiveField(3)
  double? expense;
  @HiveField(4)
  double? debt;

  Users(this.id, this.name);

}
