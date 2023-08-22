import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';

import '../../group_management/presentation/screen/new_group.dart';


class myFloatingActionButton extends StatelessWidget {
  var _key;

  myFloatingActionButton(this._key);

  void showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = TextButton(
      child:
          Directionality(textDirection: TextDirection.rtl, child: Text("باشه")),
      onPressed: () {
        Navigator.of(context).pop(); // Close the dialog
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Directionality(
          textDirection: TextDirection.rtl, child: Text("در دست ساخت :)")),
      content: Directionality(
          textDirection: TextDirection.rtl,
          child: Text(
              "متاسفانه این قابلیت هنوز پیاده سازی نشده!\nاگر علاقه مند به این قابلیت هستید بهم پیام بدید حتما در بروزرسانی بعدی اضافه خواهد شد.")),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ExpandableFab(
      key: _key,
      pos: ExpandableFabPos.left,
      // duration: const Duration(milliseconds: 500),
      // distance: 200.0,
      // type: ExpandableFabType.up,
      // pos: ExpandableFabPos.left,
      // childrenOffset: const Offset(0, 20),
      // fanAngle: 40,
      openButtonBuilder: RotateFloatingActionButtonBuilder(
        child: const Icon(Icons.menu_open),
        // foregroundColor: Colors.amber,
        // backgroundColor: Colors.green,
        // shape: const CircleBorder(),
        // angle: 3.14 * 2,
      ),
      // closeButtonBuilder: FloatingActionButtonBuilder(
      //   size: 56,
      //   builder: (BuildContext context, void Function()? onPressed,
      //       Animation<double> progress) {
      //     return IconButton(
      //       onPressed: onPressed,
      //       icon: const Icon(
      //         Icons.check_circle_outline,
      //         size: 40,
      //       ),
      //     );
      //   },
      // ),
      overlayStyle: ExpandableFabOverlayStyle(
        // color: Colors.black.withOpacity(0.5),
        blur: 5,
      ),
      onOpen: () {},
      afterOpen: () {},
      onClose: () {},
      afterClose: () {},
      children: [
        ElevatedButton(
          // shape: const CircleBorder(),
          // heroTag: null,
          child: Column(
            children: [
              const Icon(Icons.group_add),
              Text("عضویت در گروهی دیگر"),
            ],
          ),
          onPressed: () {
            showAlertDialog(context);
          },
        ),
        ElevatedButton(
          // shape: const CircleBorder(),
          // heroTag: null,
          child: Column(
            children: [
              const Icon(Icons.add),
              Text("ساخت گروه جدید"),
            ],
          ),
          onPressed: () {
            Navigator.pushNamed(context, CreateGroup.routeName);
          },
        ),
        // ElevatedButton(
        //   // shape: const CircleBorder(),
        //   // heroTag: null,
        //   child: Column(
        //     children: [
        //       const Icon(Icons.share),
        //       Text("data")
        //     ],
        //   ),
        //   onPressed: () {
        //     final state = _key.currentState;
        //     if (state != null) {
        //       debugPrint('isOpen:${state.isOpen}');
        //       state.toggle();
        //     }
        //   },
        // ),
      ],
    );
  }
}
