import 'package:flutter/material.dart';

import '../widgets/drawer/main_drawer.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = "HomeScreen";

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        drawer:MainDrawer(),
        appBar: AppBar(
          backgroundColor: Colors.teal,
          centerTitle: true,
          title: Text("سهمینه"),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            print("tapped");
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
