import 'package:equatable/equatable.dart';
import 'package:sahmine/features/group_management/data/model/groups.dart';

import '../../data/model/transaction.dart';

abstract class GroupEvent extends Equatable {
  const GroupEvent();

  @override
  List<Object?> get props => [];
}

class AddGroup extends GroupEvent {
  final Group group;

  const AddGroup(this.group);

  @override
  List<Object?> get props => [group];
}

class RemoveGroup extends GroupEvent {
  final Group group;

  RemoveGroup(this.group);

  @override
  List<Object?> get props => [group];
}

class LoadGroups extends GroupEvent {}

class UpdateGroups extends GroupEvent {
  final Group group;

  UpdateGroups(this.group);

  @override
  List<Object?> get props => [group];
}

class RemoveTransaction extends GroupEvent {
  final Group group;
  final double amountSpent;
  final String description;

  RemoveTransaction(this.group, this.amountSpent, this.description);

  @override
  List<Object?> get props => [group, amountSpent, description];
}

