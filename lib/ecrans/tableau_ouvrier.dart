import 'package:flutter/material.dart';

class TableauOuvrier extends StatelessWidget {
  final String langue;

  const TableauOuvrier({super.key, required this.langue});

  @override
  Widget build(BuildContext context) {
    final isAr = langue == "AR";

    return Scaffold(
      body: Center(
        child: Text(
          isAr ? "لوحة العامل" : "Worker Dashboard",
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
