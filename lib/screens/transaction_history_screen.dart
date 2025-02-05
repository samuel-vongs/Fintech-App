import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // For date formatting

class TransactionHistoryScreen extends StatelessWidget {
  final String userId;

  const TransactionHistoryScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Transaction History')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('transactions')
            .where('senderId', isEqualTo: userId)
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No transactions found.'));
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var transaction = snapshot.data!.docs[index];
              return ListTile(
                title: Text('Amount: \$${transaction['amount']}'),
                subtitle: Text(
                  'To: ${transaction['receiverId']}\n'
                  'Date: ${DateFormat('yyyy-MM-dd – kk:mm').format(transaction['timestamp'].toDate())}',
                ),
              );
            },
          );
        },
      ),
    );
  }
}
