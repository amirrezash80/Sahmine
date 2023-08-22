import '../../data/model/groups.dart';
import 'group_status.dart';

class GroupState {
  final List<Group> groups;
  final groupStatus status;

  GroupState(this.groups, this.status);

  GroupState copyWith({List<Group>? groups, groupStatus? status}) {
    return GroupState(
      groups ?? this.groups,
      status ?? this.status,
    );
  }
}
