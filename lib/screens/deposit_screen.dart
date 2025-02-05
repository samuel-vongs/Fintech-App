import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DepositScreen extends StatefulWidget {
  const DepositScreen({super.key});

  @override
  _DepositScreenState createState() => _DepositScreenState();
}

class _DepositScreenState extends State<DepositScreen> {
  final TextEditingController _amountController = TextEditingController();
  String _selectedPaymentMethod = 'Bank Transfer';
  final String _accountDetails = 'Account Number: 1234567890\nBank: XYZ Bank';

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Deposit'),
          content: Text(
              'Are you sure you want to deposit \$${_amountController.text}?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                // Handle deposit logic
                Navigator.of(context).pop();
              },
              child: Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  void _copyAccountDetails() {
    Clipboard.setData(ClipboardData(text: _accountDetails));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Account details copied to clipboard')),
    );
  }

  void _makePaymentWithPaystack() {
    // Implement Paystack payment logic here
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Paystack payment initiated')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Deposit Money')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _amountController,
              decoration: InputDecoration(
                labelText: 'Amount',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: _selectedPaymentMethod,
              decoration: InputDecoration(
                labelText: 'Payment Method',
                border: OutlineInputBorder(),
              ),
              items: ['Bank Transfer', 'Credit Card', 'PayPal', 'Paystack']
                  .map((method) => DropdownMenuItem(
                        value: method,
                        child: Text(method),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedPaymentMethod = value!;
                });
              },
            ),
            SizedBox(height: 20),
            if (_selectedPaymentMethod == 'Bank Transfer') ...[
              Text(_accountDetails),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: _copyAccountDetails,
                child: Text('Copy Account Details'),
              ),
            ],
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _selectedPaymentMethod == 'Paystack'
                    ? _makePaymentWithPaystack
                    : _showConfirmationDialog,
                child: Text('Deposit'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
