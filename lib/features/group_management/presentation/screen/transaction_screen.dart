import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:uuid/uuid.dart';

import '../../data/model/groups.dart';
import '../../data/model/transaction.dart';
import '../bloc/group_bloc.dart';
import '../bloc/group_state.dart';
import '../bloc/group_event.dart';

class TransactionScreen extends StatefulWidget {
  final Group group;
  final Transaction? initialTransaction;

  const TransactionScreen({required this.group, this.initialTransaction});

  @override
  _TransactionScreenState createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  String selectedPayer = '';
  Map<String, double> sharedCoefficients = {};
  TextEditingController descriptionController = TextEditingController();
  String? imagePath;
  final ImagePicker _imagePicker = ImagePicker();
  TextEditingController amountController = TextEditingController();
  double _amount = 0.0;
  late GroupBloc _groupBloc;

  @override
  void initState() {
    super.initState();
    // Set initial values from the provided initialTransaction
    if (widget.initialTransaction != null) {
      final initialTransaction = widget.initialTransaction!;
      selectedPayer = initialTransaction.payer;
      sharedCoefficients = Map.from(initialTransaction.sharedCoefficients);
      descriptionController.text = initialTransaction.description;
      imagePath = initialTransaction.receiptImagePath;
      _amount = initialTransaction.amountSpent;
      amountController.text = _amount.toString();
      print(_amount);
    }
    _groupBloc = BlocProvider.of<GroupBloc>(context);
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedImage = await _imagePicker.pickImage(source: source);
    if (pickedImage != null) {
      setState(() {
        imagePath = pickedImage.path;
      });
    }
  }
  void _saveTransaction() {
    // Validate that required fields are filled
    if (selectedPayer.isEmpty ||
        sharedCoefficients.isEmpty ||
        amountController.text.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('خطا'),
          content: Text('لطفاً تمامی فیلدهای اجباری را پر نمایید.'),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text('باشه'),
            ),
          ],
        ),
      );
      return;
    }

    final amountText = amountController.text;
    final amountSpent = double.tryParse(amountText.replaceAll(',', '.')) ?? 0.0;

    if (amountSpent <= 0) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('خطا'),
          content: Text('مبلغ پرداختی را به زبان انگلیسی وارد نمایید.'),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text('باشه'),
            ),
          ],
        ),
      );
      return;
    }


    final payer = selectedPayer;
    final sharedMembers = sharedCoefficients;
    final description = descriptionController.text;
    final receiptImage = imagePath;

    if (widget.initialTransaction != null) {
      // Edit existing transaction
      final transaction = widget.initialTransaction!;
      transaction.amountSpent = amountSpent;
      transaction.payer = payer;
      transaction.sharedCoefficients = sharedMembers;
      transaction.description = description;
      transaction.receiptImagePath = receiptImage;
    } else {
      var uuid = Uuid();
      // Add new transaction
      print("here");
      print(uuid.v4().toString());
      final transaction = Transaction(
        amountSpent: amountSpent,
        payer: payer,
        sharedCoefficients: sharedMembers,
        description: description,
        receiptImagePath: receiptImage,
      );
      widget.group.transactions!.add(transaction);
    }

    // Update the group in Bloc and Hive
    _groupBloc.add(UpdateGroups(widget.group));
    final groupBox = Hive.box<Group>('groups');
    final groupIndex = groupBox.values.toList().indexWhere((g) => g.id == widget.group.id);
    if (groupIndex != -1) {
      groupBox.putAt(groupIndex, widget.group);
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('اضافه کردن تراکنش'),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('مبلغ پرداختی (تومان)'),
              TextFormField(
                keyboardType: TextInputType.number,
                controller: amountController,
                decoration: const InputDecoration(
                  hintText: 'مقدار را وارد کنید...',
                ),
              ),

              const SizedBox(height: 16.0),
              const Text('پرداخت کننده'),
              DropdownButton<String>(
                value: selectedPayer,
                onChanged: (value) {
                  setState(() {
                    selectedPayer = value!;
                  });
                },
                items: [
                  const DropdownMenuItem<String>(
                    value: '', // مقدار خالی را برای عدم انتخاب پرداخت کننده قرار دهید
                    child: Text('انتخاب پرداخت کننده'),
                  ),
                  ...widget.group.users!.map((member) {
                    return DropdownMenuItem<String>(
                      value: member.name,
                      child: Text(member.name),
                    );
                  }).toList(),
                ],
              ),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('اعضای سهیم'),
                  const Text('ضریب سهم'),
                ],
              ),
              Column(
                children: widget.group.users!.map((member) {
                  return Row(
                    children: [
                      Checkbox(
                        value: sharedCoefficients.containsKey(member.name),
                        onChanged: (value) {
                          setState(() {
                            if (value!) {
                              sharedCoefficients[member.name] =
                              1.0; // ضریب پیش فرض را ۱.۰ قرار دهید
                            } else {
                              sharedCoefficients.remove(member.name);
                            }
                          });
                        },
                      ),
                      Expanded(child: Text(member.name)),
                      if (sharedCoefficients.containsKey(member.name))
                        Container(
                          width: 60,
                          child: TextFormField(
                            initialValue:
                            sharedCoefficients[member.name].toString(),
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              sharedCoefficients[member.name] =
                                  double.tryParse(value.replaceAll(',', '.')) ??
                                      1.0;
                            },
                          ),
                        ),
                    ],
                  );
                }).toList(),
              ),
              const SizedBox(height: 16.0),
              const Text('توضیحات'),
              TextFormField(
                controller: descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'توضیحات تراکنش را وارد کنید...',
                ),
              ),
              const SizedBox(height: 16.0),
              const Text('عکس رسید'),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                leading: const Icon(Icons.camera),
                                title: const Text('عکس گرفتن'),
                                onTap: () {
                                  _pickImage(ImageSource.camera);
                                  Navigator.pop(context);
                                },
                              ),
                              ListTile(
                                leading: const Icon(Icons.image),
                                title: const Text('انتخاب از گالری'),
                                onTap: () {
                                  _pickImage(ImageSource.gallery);
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Row(
                      children: [
                        Icon(Icons.camera_alt_rounded),
                        const Text(' انتخاب تصویر رسید'),
                      ],
                    ),
                  ),
                ],
              ),
              if (imagePath != null)
                Image.file(
                  imagePath! as File,
                  height: 200,
                  width: 200,
                  fit: BoxFit.cover,
                ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _saveTransaction,
        child: const Icon(Icons.check),
      ),
    );
  }
}
