import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../service/database.dart';
import '../../service/media_picker/files_picker_rating.dart';
import '../info_page.dart';

class RatingOrder extends StatefulWidget {
  RatingOrder({Key key, this.doc}) : super(key: key);
  final dynamic doc;

  @override
  State<RatingOrder> createState() => _RatingOrderState();
}

class _RatingOrderState extends State<RatingOrder> {
  double ratings = 5;

  List<PlatformFile> _userFiles;

  List<PlatformFile> _videoFiles;

  List<String> fileUrls = [];

  List<String> videoUrls = [];

  TextEditingController desc = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: const Text('Rate The Service'),
          ),
          body: Column(
            children: [
              Expanded(
                child: SizedBox(
                  child: content(context),
                ),
              ),
              Container(
                height: 8,
                width: MediaQuery.of(context).size.width,
                color: Colors.grey[300],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.06,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => submit(context),
                  style: ElevatedButton.styleFrom(
                    primary: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0),
                    ),
                  ),
                  child: const Text('Submit'),
                ),
              )
            ],
          )),
    );
  }

  Widget content(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(8, 16, 0, 16),
            child: Text(
              'Order Detail',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          Container(
            height: 8,
            width: MediaQuery.of(context).size.width,
            color: Colors.grey[300],
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(8, 8, 0, 0),
            child: Text(
              ' Confinement Package',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
          ),
          const Divider(
            thickness: 1,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.doc['typeOfService'],
                  style: const TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 15,
                  ),
                ),
                Text(
                  'RM ${widget.doc['price'].toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 8,
            width: MediaQuery.of(context).size.width,
            color: Colors.grey[300],
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(8, 8, 0, 0),
            child: Text(
              'Confinement Lady',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
          ),
          const Divider(
            thickness: 1,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
            child: Text(widget.doc['clName']),
          ),
          Container(
            height: 8,
            width: MediaQuery.of(context).size.width,
            color: Colors.grey[300],
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(8, 8, 0, 0),
            child: Text(
              'Rate the Service',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
          ),
          const Divider(
            thickness: 1,
          ),
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
            child: Column(
              children: [
                RatingBar.builder(
                  initialRating: 5,
                  minRating: 1,
                  direction: Axis.horizontal,
                  itemCount: 5,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {
                    ratings = rating;
                  },
                ),
                const SizedBox(
                  height: 8,
                ),
                const Text(
                  '0 = Very Poor Service, 5 = Very Good Service',
                  style: TextStyle(
                      fontWeight: FontWeight.w200,
                      fontSize: 14,
                      color: Colors.grey),
                )
              ],
            ),
          ),
          Container(
            height: 8,
            width: MediaQuery.of(context).size.width,
            color: Colors.grey[300],
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(8, 8, 0, 0),
            child: Text(
              'Photos/Videos (Optional)',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
          ),
          const Divider(
            thickness: 1,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
            child: FilesPickerRating(
                fileSelectFn: _selectedFile, videoSelectFn: _selectedVideoFile),
          ),
          Container(
            height: 8,
            width: MediaQuery.of(context).size.width,
            color: Colors.grey[300],
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(8, 8, 0, 0),
            child: Text(
              'Description',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
          ),
          const Divider(
            thickness: 1,
          ),
          Container(
            margin: const EdgeInsets.all(8),
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              color: Colors.grey[300],
            ),
            child: TextField(
              keyboardType: TextInputType.multiline,
              maxLines: 8,
              decoration: const InputDecoration(
                hintText:
                    'Share your experience and help others make better choices!',
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
              ),
              controller: desc,
            ),
          ),
        ],
      ),
    );
  }

  void _selectedFile(List<PlatformFile> files) {
    _userFiles = files;
  }

  void _selectedVideoFile(List<PlatformFile> files) {
    _videoFiles = files;
  }

  void submit(BuildContext context) async {
    if (desc.text.isEmpty) {
      String msg = 'Please give some comments about the services';
      Fluttertoast.showToast(msg: msg);
      return;
    }
    await calculateRating();
    completeOrder(context);
  }

  Future calculateRating() async {
    double oriRating;
    int noOfOrder;
    double latestRating;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.doc['clID'])
        .get()
        .then((DocumentSnapshot snapshot) {
      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data();
        oriRating = data['rating'].toDouble();
        noOfOrder = data['orderSuccess'];
      } else {
        return null;
      }
    });

    latestRating = (oriRating * noOfOrder + ratings) / ++noOfOrder;
    Database().updateUserData(widget.doc['clID'], {
      'orderSuccess': noOfOrder,
      'rating': latestRating,
    });
  }

  void completeOrder(BuildContext context) async {
    if (_userFiles != null) {
      int index = 1;
      for (var file in _userFiles) {
        final fileStorage = FirebaseStorage.instance
            .ref()
            .child('rating')
            .child(widget.doc['clID'])
            .child(widget.doc['orderID'])
            .child('photo')
            .child('file_' + index.toString());
        index++;

        await fileStorage.putFile(File(file.path));
        var url = await fileStorage.getDownloadURL();
        fileUrls.add(url);
      }
    }

    if(_videoFiles!=null){
       int index = 1;
      for (var file in _videoFiles) {
        final fileStorage = FirebaseStorage.instance
            .ref()
            .child('rating')
            .child(widget.doc['clID'])
            .child(widget.doc['orderID'])
            .child('video')
            .child('file_' + index.toString());
        index++;

        await fileStorage.putFile(File(file.path));
        var url = await fileStorage.getDownloadURL();
        videoUrls.add(url);
      }
    }

    await Database().updateProgressOrder(
      widget.doc['orderID'],
      {
        'rating': ratings,
        'comment': desc.text,
        'photoFiles': fileUrls,
        'videoFiles': videoUrls,
      },
    );

    await Database().getProgressOrder(widget.doc['orderID']).then((data) async {
      await Database().addOrderHistory(
        'customerOrderHistory',
        widget.doc['orderID'],
        data.data(),
      );

      await Database().addOrderHistory(
        'CLOrderHistory',
        widget.doc['orderID'],
        data.data(),
      );

      await FirebaseFirestore.instance
          .collection('rating')
          .doc(widget.doc['clID'])
          .collection('rating')
          .doc(widget.doc['orderID'])
          .set(data.data());
    });

    Future.delayed(const Duration(seconds: 1), () {
      deleteOrder(widget.doc['orderID']).then((value) {
        String msg = 'Your order had been completed.\nThank you.';
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => InfoPage(
              msg: msg,
              color: Colors.green,
              imgUrl: 'assets/images/tick.png',
            ),
          ),
        );
      });
    });
  }

  Future<void> deleteOrder(String id) {
    return Database().deleteProgressOrder(id).catchError((error) =>
        Fluttertoast.showToast(msg: "Failed to cancel order: $error"));
  }
}
