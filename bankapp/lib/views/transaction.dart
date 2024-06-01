import 'package:bankapp/views/timeline.dart';
import 'package:flutter/material.dart';

class TransactionPage extends StatelessWidget {
  const TransactionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Expenses"),
      ),
      body: Column(
        children: [TimeLineMonth()],
      ),
    );
  }
}
