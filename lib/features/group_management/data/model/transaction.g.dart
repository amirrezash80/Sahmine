// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TransactionAdapter extends TypeAdapter<Transaction> {
  @override
  final int typeId = 2;

  @override
  Transaction read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Transaction(
      amountSpent: fields[0] as double,
      payer: fields[1] as String,
      sharedCoefficients: (fields[2] as Map).cast<String, double>(),
      description: fields[3] as String,
      receiptImagePath: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Transaction obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.amountSpent)
      ..writeByte(1)
      ..write(obj.payer)
      ..writeByte(2)
      ..write(obj.sharedCoefficients)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.receiptImagePath);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransactionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
