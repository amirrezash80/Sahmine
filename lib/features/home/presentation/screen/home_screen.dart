import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:hive/hive.dart';
import 'package:sahmine/features/group_management/presentation/bloc/group_bloc.dart';
import 'package:sahmine/features/group_management/presentation/screen/group_details.dart';
import '../../widgets/fab.dart';
import '../../../group_management/presentation/bloc/group_state.dart';
import '../../../group_management/presentation/bloc/group_event.dart';
import '../../../group_management/data/model/groups.dart';
import '../../../group_management/presentation/bloc/group_status.dart';
import '../../../group_management/presentation/screen/new_group.dart';
import '../../widgets/drawer/main_drawer.dart';

class HomeScreen extends StatelessWidget {
  static const String routeName = 'home';

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        drawer: MainDrawer(),
        appBar: AppBar(
          backgroundColor: Colors.teal,
          title: Text("سهمینه"),
        ),
        body: BlocBuilder<GroupBloc, GroupState>(
          builder: (context, state) {
            final groups = state.groups;

            if (groups.isEmpty) {
              return Center(
                child: Text(
                  "شما هنوز گروهی ایجاد نکرده اید",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey,
                  ),
                ),
              );
            }

            return ListView.builder(
              itemCount: groups.length,
              itemBuilder: (context, index) {
                final group = groups[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            GroupDetailsScreen(group: group),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 2.0,
                    margin:
                    EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    child: ListTile(
                      title: Text(
                        group.groupName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      subtitle: Text(
                        group.description,
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          _showDeleteConfirmationDialog(context, group, index);
                        },
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
        floatingActionButtonLocation: ExpandableFab.location,
        floatingActionButton: myFloatingActionButton(key),
      ),
    );
  }

  void _showDeleteConfirmationDialog(
      BuildContext context, Group group, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('تأیید حذف'),
        content: Text('آیا از حذف این گروه اطمینان دارید؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('خیر'),
          ),
          TextButton(
            onPressed: () {
              _deleteGroup(context, group, index);
              Navigator.pop(context);
            },
            child: Text('بله'),
          ),
        ],
      ),
    );
  }

  void _deleteGroup(BuildContext context, Group group, int index) {
    context.read<GroupBloc>().add(RemoveGroup(group));
    final groupBox = Hive.box<Group>('groups');
    groupBox.deleteAt(index);
  }
}
