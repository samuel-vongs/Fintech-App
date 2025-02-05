import 'package:flutter/material.dart';

class AirtimeDataScreen extends StatelessWidget {
  const AirtimeDataScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Deposit Money')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Amount'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Handle deposit logic
              },
              child: Text('Deposit'),
            ),
          ],
        ),
      ),
    );
  }
}
