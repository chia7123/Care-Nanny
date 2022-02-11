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

  deleteOrder(String orderID) {
    return FirebaseFirestore.instance
        .collection('orderInfo')
        .doc(orderID)
        .delete();
  }

  addPendingOrder(String orderID, Map<String, dynamic> data) {
    return FirebaseFirestore.instance
        .collection('onPendingOrder')
        .doc(orderID)
        .set(data);
  }

  getProgressOrder(String id) {
    return FirebaseFirestore.instance
        .collection('onProgressOrder')
        .doc(id)
        .get();
  }

  deleteProgressOrder(String id) {
    return FirebaseFirestore.instance
        .collection('onProgressOrder')
        .doc(id)
        .delete();
  }

  addRating(String name, String id, Map<String, dynamic> data) {
    return FirebaseFirestore.instance.collection(name).doc(id).update(data);
  }

  addOrderHistory(String name, String id, Map<String, dynamic> data) {
    return FirebaseFirestore.instance.collection(name).doc(id).set(data);
  }

  deleteOrderHistory(String name, String id) {
    return FirebaseFirestore.instance.collection(name).doc(id).delete();
  }

  addTempData(String id, Map<String, dynamic> data) {
    FirebaseFirestore.instance.collection('tempData').doc(id).set(data);
  }

  deleteTempData() async {
    var datas = await FirebaseFirestore.instance.collection('tempData').get();

    for (var data in datas.docs) {
      await data.reference.delete();
    }
  }
}
