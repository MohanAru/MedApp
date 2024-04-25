import 'package:flutter/material.dart';

class DashBoard2 extends StatefulWidget {
  const DashBoard2({super.key});

  @override
  State<DashBoard2> createState() => _DashBoard2State();
}

class _DashBoard2State extends State<DashBoard2> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          'Welcome !!',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
