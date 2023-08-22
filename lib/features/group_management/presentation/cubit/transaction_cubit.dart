import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:equatable/equatable.dart';
import 'package:sahmine/features/group_management/data/model/transaction.dart';
import '../../data/model/groups.dart';

part 'transaction_state.dart';

class TransactionCubit extends Cubit<TransactionState> {
  final Group? group;

  TransactionCubit(this.group) : super(TransactionInitial()) {
    fetchTransactions();
  }

  void fetchTransactions() {
    final box = Hive.box<Group>('groups');
    final groupIndex = box.values.toList().indexWhere((g) => g.id == group!.id);
    final transactions = (box.getAt(groupIndex)?.transactions ?? <Transaction>[]) as List<Transaction>;
    emit(TransactionLoaded(transactions));
  }

  void saveTransaction(Transaction transaction) {
    final box = Hive.box<Group>('groups');
    final groupIndex = box.values.toList().indexWhere((g) => g.id == group!.id);
    final groupValue = box.getAt(groupIndex);
    if (groupValue != null) {
      groupValue.transactions.add(transaction);
      box.putAt(groupIndex, groupValue);
      fetchTransactions(); // Update the state with the new transactions
    }
  }

  void AddTransaction(Transaction transaction) {
    group?.transactions.add(transaction);
    emit(state);
  }


// ... Other methods
}

