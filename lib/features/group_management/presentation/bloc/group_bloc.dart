import 'package:bloc/bloc.dart';
import 'package:hive/hive.dart';
import '../../data/model/groups.dart';

import 'group_event.dart';
import 'group_status.dart';
import 'group_state.dart';

class GroupBloc extends Bloc<GroupEvent, GroupState> {
  final Box<Group> groupBox; // Box to store groups
  GroupBloc(this.groupBox) : super(GroupState([], groupStatus.GroupLoading)) {
    // Dispatch the LoadGroups event when the bloc is created

    on<AddGroup>((event, emit) {
      // Update the group list with the new group
      final updatedGroups = List<Group>.from(state.groups)
        ..add(event.group);

      // Emit the new state with the updated group list
      emit(state.copyWith(groups: updatedGroups));
    });

    on<LoadGroups>((event, emit) {
      // Retrieve stored groups from the Hive box
      final storedGroups = groupBox.values.toList();

      // Emit the state with the loaded group list
      emit(state.copyWith(
          groups: storedGroups, status: groupStatus.GroupLoaded));
    });

    on<UpdateGroups>((event, emit) {
      // Update the transactions of the specified group
      final updatedGroups = List<Group>.from(state.groups);
      final groupIndex =
      groupBox.values.toList().indexWhere((g) => g.id == event.group.id);

      if (groupIndex >= 0) {
        updatedGroups[groupIndex] = event.group;
      }

      // Emit the new state with the updated group list
      emit(state.copyWith(groups: updatedGroups));
    });

    // Other methods
    on<RemoveGroup>((event, emit) {
      // Remove the specified group from the group list
      final updatedGroups = List<Group>.from(state.groups)
        ..remove(event.group);
      // Emit the new state with the updated group list
      emit(state.copyWith(groups: updatedGroups));
    });
    on<RemoveTransaction>((event, emit) {
      final updatedGroups = List<Group>.from(state.groups);

      for (final group in updatedGroups) {
        final transactionIndex = group.transactions!.indexWhere((transaction) =>
        transaction.amountSpent == event.amountSpent &&
            transaction.description == event.description);

        if (transactionIndex >= 0) {
          group.transactions!.removeAt(transactionIndex);

          // Update the Hive box to reflect the changes
          final groupIndex = groupBox.values.toList().indexWhere((g) => g.id == group.id);
          if (groupIndex != -1) {
            groupBox.putAt(groupIndex, group);
          }

          break; // No need to search in other groups
        }
      }

      // Update the state with the new group list
      emit(state.copyWith(groups: updatedGroups));
    });

    // Dispatch the LoadGroups event when the bloc is created
    add(LoadGroups());
  }
}
