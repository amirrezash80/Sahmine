import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sahmine/features/group_management/presentation/cubit/transaction_cubit.dart';
import '../../data/model/groups.dart';
import '../../data/model/transaction.dart';

class TransactionScreen extends StatefulWidget {
  final Group group;
  final Transaction? initialTransaction;

  TransactionScreen({required this.group, this.initialTransaction});

  @override
  _TransactionScreenState createState() => _TransactionScreenState();
}



class _TransactionScreenState extends State<TransactionScreen> {
  String selectedPayer = ''; // Store the selected payer
  Map<String, double> sharedCoefficients = {}; // Store shared coefficients for selected members
  TextEditingController descriptionController = TextEditingController();
  String? imagePath; // Store the path of the selected image
  final ImagePicker _imagePicker = ImagePicker();
   TextEditingController amountController = TextEditingController();

  Future<void> _pickImage(ImageSource source) async {
    final pickedImage = await _imagePicker.pickImage(source: source);
    if (pickedImage != null) {
      setState(() {
        imagePath = pickedImage.path;
      });
    }
  }

  void _saveTransaction() {
    final amountSpent = double.tryParse(amountController.text) ?? 0.0;
    final payer = selectedPayer;
    final sharedMembers = sharedCoefficients;
    final description = descriptionController.text;
    final receiptImage = imagePath;

    // Create a new Transaction instance
    final transaction = Transaction(
      amountSpent: amountSpent,
      payer: payer,
      sharedCoefficients: sharedMembers,
      description: description,
      receiptImagePath: receiptImage,
    );


    // Determine whether to add a new transaction or update an existing one
    if (widget.initialTransaction == null) {
      // Add the transaction to the group's transactions list
      widget.group.transactions.add(transaction);
    } else {
      // Update the existing transaction
      final index =
      widget.group.transactions.indexOf(widget.initialTransaction!);
      widget.group.transactions[index] = transaction;
    }

    // Save the updated group to Hive
    final box = Hive.box<Group>('groups');
    final groupIndex = box.values
        .toList()
        .indexWhere((g) => g.id == widget.group.id);
    if (groupIndex >= 0) {
      box.putAt(groupIndex, widget.group);
    }
    builder :(context , child){
      context.read<TransactionCubit>().AddTransaction(transaction);
    };
    // Navigate back
    Navigator.pop(context);
  }
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Transaction'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Amount Spent (Toman)'),
            TextFormField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: 'Enter amount...',
              ),
            ),
            const SizedBox(height: 16.0),
            const Text('Payer'),
            DropdownButton<String>(
              value: selectedPayer,
              onChanged: (value) {
                setState(() {
                  selectedPayer = value!;
                });
              },
              items: [
                const DropdownMenuItem<String>(
                  value: '', // Set an empty value for no payer selected
                  child: Text('Select Payer'),
                ),
                ...widget.group.user!.map((member) {
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
              children: widget.group.user!.map((member) {
                return Row(
                  children: [
                    Checkbox(
                      value: sharedCoefficients.containsKey(member.name),
                      onChanged: (value) {
                        setState(() {
                          if (value!) {
                            sharedCoefficients[member.name] = 1.0; // Set default coefficient to 1.0
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
                          initialValue: '1.0',
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            sharedCoefficients[member.name] =
                                double.parse(value);
                          },
                        ),
                      ),
                  ],
                );
              }).toList(),
            ),
            const SizedBox(height: 16.0),
            const Text('Description'),
            TextFormField(
              controller: descriptionController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Enter transaction description...',
              ),
            ),
            const SizedBox(height: 16.0),
            const Text('Receipt Image'),
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
                              title: const Text('Take a Photo'),
                              onTap: () {
                                _pickImage(ImageSource.camera);
                                Navigator.pop(context);
                              },
                            ),
                            ListTile(
                              leading: const Icon(Icons.image),
                              title: const Text('Pick from Gallery'),
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
                      const Text(' Choose Receipt Image'),
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
      floatingActionButton: FloatingActionButton(
        onPressed: _saveTransaction, // Call the save function when the button is pressed
        child: const Icon(Icons.check),
      ),
    );
  }
}
