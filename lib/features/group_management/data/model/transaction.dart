import 'package:hive/hive.dart';

part 'transaction.g.dart';

@HiveType(typeId: 2)
class Transaction extends HiveObject {
  @HiveField(0)
  late double amountSpent;

  @HiveField(1)
  late String payer;

  @HiveField(2)
  late Map<String, double> sharedCoefficients;

  @HiveField(3)
  late String description;

  @HiveField(4)
  late String? receiptImagePath;
  Transaction({
    required this.amountSpent,
    required this.payer,
    required this.sharedCoefficients,
    required this.description,
    this.receiptImagePath,
  });

}
