import 'package:fintech_app/services/payment_services.dart';
import 'package:flutter/material.dart';

class SendMoneyScreen extends StatefulWidget {
  final String senderId;

  const SendMoneyScreen({super.key, required this.senderId});

  @override
  _SendMoneyScreenState createState() => _SendMoneyScreenState();
}

class _SendMoneyScreenState extends State<SendMoneyScreen> {
  final TextEditingController _receiverIdController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final PaymentService _paymentService = PaymentService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Send Money')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _receiverIdController,
              decoration: InputDecoration(labelText: 'Receiver ID'),
            ),
            TextField(
              controller: _amountController,
              decoration: InputDecoration(labelText: 'Amount'),
              keyboardType: TextInputType.number,
            ),
            ElevatedButton(
              onPressed: () async {
                double amount = double.tryParse(_amountController.text) ?? 0.0;
                if (amount > 0) {
                  await _paymentService.sendMoney(
                    widget.senderId,
                    _receiverIdController.text,
                    amount,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Money sent successfully!')),
                  );
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please enter a valid amount.')),
                  );
                }
              },
              child: Text('Send Money'),
            ),
          ],
        ),
      ),
    );
  }
}
