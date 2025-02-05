import 'package:cloud_firestore/cloud_firestore.dart';

class PaymentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Send money
  Future<void> sendMoney(
      String senderId, String receiverId, double amount) async {
    await _firestore.collection('transactions').add({
      'senderId': senderId,
      'receiverId': receiverId,
      'amount': amount,
      'timestamp': DateTime.now(),
    });
  }

  // Get transaction history
  Stream<QuerySnapshot> getTransactionHistory(String userId) {
    return _firestore
        .collection('transactions')
        .where('senderId', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .snapshots();
  }
}
