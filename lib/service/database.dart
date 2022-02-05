import 'package:cloud_firestore/cloud_firestore.dart';

class Database {
  getUserData(String id) {
    return FirebaseFirestore.instance.collection('users').doc(id).get();
  }

  updateUserData(String id, Map<String, Object> data) {
    return FirebaseFirestore.instance.collection('users').doc(id).update(data);
  }

  addOrder(String orderID, Map<String, dynamic> data) {
    return FirebaseFirestore.instance
        .collection('orderInfo')
        .doc(orderID)
        .set(data);
  }

  getOrderData(String orderID) {
    return FirebaseFirestore.instance
        .collection('orderInfo')
        .doc(orderID)
        .get();
  }

  updateOrderData(String orderID, Map<String, dynamic> data) {
    return FirebaseFirestore.instance
        .collection('orderInfo')
        .doc(orderID)
        .update(data);
  }

  deleteOrder(String orderID){
    return FirebaseFirestore.instance.collection('orderInfo').doc(orderID).delete();
  }
}
