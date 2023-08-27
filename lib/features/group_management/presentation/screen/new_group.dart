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
    final newGroup = Group(currentGroupId, groupName, description, selectedUsers, [], {});

    newGroup.users = selectedUsers;

    groupBox.add(newGroup);
    context.read<GroupBloc>().add(AddGroup(newGroup));
    Navigator.pop(context);
  }

  void _showUserSelectionDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            title: Text('اضافه کردن عضو جدید'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'نکته: برای نمایش بهتر، اسامی را به صورت فارسی وارد کنید.',
                  style: TextStyle(
                    color: Colors.grey,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: newMemberController,
                  decoration: InputDecoration(labelText: 'نام کاربر'),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  final newUser = Users(selectedUsers.length + 1, newMemberController.text);
                  setState(() {
                    selectedUsers.add(newUser);
                  });
                  newMemberController.clear();
                  Navigator.pop(context);
                },
                child: Text('اضافه کردن'),
              ),
              TextButton(
                onPressed: () {
                  newMemberController.clear();
                  Navigator.pop(context);
                },
                child: Text('انصراف'),
              ),
            ],
          ),
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
                  child: Text('افزودن عضو'),
                ),
                SizedBox(height: 16),
                Divider(thickness: 2),
                SizedBox(height: 16),
                Text(
                  'اعضای انتخاب شده:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: selectedUsers.map((user) {
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.teal,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      margin: EdgeInsets.only(bottom: 10),
                      child: ListTile(
                        title: Text(
                          user.name,
                          style: TextStyle(color: Colors.white),
                        ),
                        leading: IconButton(
                          onPressed: () {
                            setState(() {
                              selectedUsers.remove(user);
                            });
                          },
                          icon: Icon(Icons.delete),
                          color: Colors.white,
                        ),
                      ),
                    );
                  }).toList(),
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
