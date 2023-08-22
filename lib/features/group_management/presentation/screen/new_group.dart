import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import '../../../home/data/model/user.dart';
import '../../data/model/groups.dart';
import '../bloc/group_bloc.dart';
import '../bloc/group_event.dart';


class CreateGroup extends StatefulWidget {
  static const String routeName = "create_group";

  @override
  _CreateGroupState createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {
  final TextEditingController groupNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController newMemberController = TextEditingController();
  List<Users> selectedUsers = [];
  final Box<Group> groupBox = Hive.box<Group>('groups');

  void _createGroup() async {
    final groupName = groupNameController.text;
    final description = descriptionController.text;

    int currentGroupId = groupBox.length;
    final newGroup = Group(currentGroupId, groupName, description, selectedUsers);

    // You should add the selectedUsers list to the new group here
    newGroup.user = selectedUsers;

    groupBox.add(newGroup); // Add the new group to Hive
    context.read<GroupBloc>().add(AddGroup(newGroup));
    Navigator.pop(context);
  }



  Future<void> _showUserSelectionDialog() async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add New User'),
          content: TextField(
            controller: newMemberController,
            decoration: InputDecoration(labelText: 'User Name'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                final newUser =
                Users(selectedUsers.length + 1, newMemberController.text);
                setState(() {
                  selectedUsers.add(newUser);
                });
                newMemberController.clear();
                Navigator.pop(context);
              },
              child: Text('Add'),
            ),
            TextButton(
              onPressed: () {
                newMemberController.clear();
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('ایجاد گروه جدید'),
      ),
      body: SingleChildScrollView(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: groupNameController,
                  decoration: InputDecoration(labelText: 'نام گروه'),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(labelText: 'توضیحات گروه'),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _showUserSelectionDialog,
                  child: Text('انتخاب اعضا'),
                ),
                SizedBox(height: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text('کاربران انتخاب شده:'),
                    SizedBox(height: 8),
                    ListView.separated(
                      itemCount: selectedUsers.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final user = selectedUsers[index];
                        return Container(
                          decoration: BoxDecoration(
                              color: Colors.teal,
                              borderRadius: BorderRadius.circular(10)),
                          child: ListTile(
                            title: Text(user.name),
                            leading: IconButton(
                              onPressed: () {
                                setState(() {
                                  selectedUsers.removeAt(index);
                                });
                              },
                              icon: Icon(Icons.delete),
                              color: Colors.white,
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return SizedBox(height: 10);
                      },
                    ),
                  ],
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _createGroup,
                  child: Text('ایجاد گروه'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
