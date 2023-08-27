import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:screenshot/screenshot.dart';

import '../../data/model/groups.dart';
import 'ExpensesScreen.dart';
import 'BalanceScreen.dart';

class GroupDetailsScreen extends StatefulWidget {
  final Group group;

  GroupDetailsScreen({required this.group});

  @override
  _GroupDetailsScreenState createState() => _GroupDetailsScreenState();
}

class _GroupDetailsScreenState extends State<GroupDetailsScreen>
    with TickerProviderStateMixin {
  late final TabController _tabController;
  late final AnimationController _animationController;
  final ScreenshotController _expensesScreenshotController = ScreenshotController();
  final ScreenshotController _balanceScreenshotController = ScreenshotController();
  final ScreenshotController _screenshotController = ScreenshotController();

  @override
  void initState() {
    super.initState();
    print(_expensesScreenshotController.toString());
    print(_balanceScreenshotController.toString());
    print(_screenshotController.toString());
    _tabController = TabController(
      length: 2,
      vsync: this,
    );

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
      value: 1,
    );

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        Future.delayed(Duration(milliseconds: 10), () {
          _animationController.forward(from: 0.5);
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  shareImage(ScreenshotController controller) async {
    Uint8List? imageInUint8List = await controller.capture();
    String tempPath = (await getTemporaryDirectory()).path;
    String fileName = "سهمینه";

    File file = await File('$tempPath/$fileName.png').create();
    file.writeAsBytesSync(imageInUint8List!);
    await Share.shareFiles([file.path]);
  }
    @override
    Widget build(BuildContext context) {
      return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.teal,
            title: Text(widget.group.groupName),
            actions: [
              IconButton(
                icon: Icon(Icons.share),
                onPressed: () {
                  if (_tabController.index == 0) {
                    shareImage(_expensesScreenshotController);
                  } else if (_tabController.index == 1) {
                    shareImage(_balanceScreenshotController);
                  }
                },
              ),

            ],
            bottom: TabBar(
              unselectedLabelColor: Colors.black,
              indicatorColor: Colors.black,
              labelColor: Colors.white,
              controller: _tabController,
              tabs: [
                Tab(text: 'مخارج'),
                Tab(text: 'تراز مالی'),
              ],
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              Screenshot(
                controller: _expensesScreenshotController,
                child: ScaleTransition(
                  scale: _animationController,
                  child: ExpensesScreen(group: widget.group),
                ),
              ),
              Screenshot(
                controller: _balanceScreenshotController,
                child: ScaleTransition(
                  scale: _animationController,
                  child: BalanceScreen(group: widget.group,),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

