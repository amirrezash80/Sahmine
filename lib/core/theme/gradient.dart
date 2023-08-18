import 'package:flutter/material.dart';

class MyGradient extends StatelessWidget {
  const MyGradient({super.key});

  @override
  Widget build(BuildContext context) {
    return  Container(
      // Add box decoration
      decoration:  BoxDecoration(
        // Box decoration takes a gradient
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.teal.shade700,
            Colors.teal.shade600,
            Colors.teal.shade500,
            Colors.teal.shade400,
            Colors.teal.shade300,
            Colors.teal.shade300,
            Colors.teal.shade200,
            Colors.teal.shade100,
          ],
        ),
      ),

    );

  }
}
