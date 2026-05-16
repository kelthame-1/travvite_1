import 'package:flutter/material.dart';

class Reservation extends StatelessWidget {
  final String langue;
  final Map<String, dynamic> ouvrier;
  const Reservation({super.key, required this.langue, required this.ouvrier});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('Reservation')),
    );
  }
}
