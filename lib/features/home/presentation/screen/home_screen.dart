import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:hive/hive.dart';
import 'package:sahmine/features/group_management/presentation/bloc/group_bloc.dart';
import 'package:sahmine/features/group_management/presentation/screen/new_group.dart';
import 'package:sahmine/features/home/widgets/drawer/main_drawer.dart';
import '../../../group_management/data/model/groups.dart';
import '../../../group_management/presentation/bloc/group_event.dart';
import '../../../group_management/presentation/bloc/group_status.dart';
import '../../../group_management/presentation/bloc/group_state.dart';
import '../../../group_management/presentation/screen/group_details.dart';
import '../../widgets/fab.dart';

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
                child: Text("شما هنوز گروهی ایجاد نکرده اید"),
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
                        group.groupname,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(group.description),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          // Delete the group from Bloc
                          context.read<GroupBloc>().add(RemoveGroup(group));
                          // Delete the group from Hive
                          final groupBox = Hive.box<Group>('groups');
                          groupBox.deleteAt(index);
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
}
