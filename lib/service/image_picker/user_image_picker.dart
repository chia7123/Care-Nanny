import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  UserImagePicker(this.imageUrl);
  final String imageUrl;

  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File _pickedImage;
  CollectionReference userInfo = FirebaseFirestore.instance.collection('users');
  final user = FirebaseAuth.instance.currentUser;
  String imageUrl;

  @override
  void initState() {
    imageUrl = widget.imageUrl;

    super.initState();
  }

  void _showdialog(BuildContext ctx) {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: ctx,
      builder: (ctx) {
        return SizedBox(
          height: 120,
          child: ListView(
            children: [
              TextButton.icon(
                    onPressed: () {
                      _pickImage(ImageSource.camera);
                    },
                    icon: const Icon(Icons.camera),
                    label: const Text('Camera')),
                const Divider(),
                TextButton.icon(
                    onPressed: () {
                      _pickImage(ImageSource.gallery);
                    },
                    icon: const Icon(Icons.album),
                    label: const Text('Gallery')),
              ],
          ),
        );
      },
    );
  }

  Future _pickImage(ImageSource source) async {
    try {
      final picker = ImagePicker();
      final pickedImage =
          await picker.pickImage(source: source, imageQuality: 50);

      if (pickedImage == null) return;

      setState(() {
        _pickedImage = File(pickedImage.path);
      });
      uploadPhoto();
    } on PlatformException catch (e) {
      Fluttertoast.showToast(msg: 'Failed to pick image :$e');
    }
  }

  Future uploadPhoto() async {
    final imageStorage = FirebaseStorage.instance
        .ref()
        .child('user_profile_image')
        .child(FirebaseAuth.instance.currentUser.uid + '.jpg');

    await imageStorage.putFile(_pickedImage);
    final url = await imageStorage.getDownloadURL();

    return FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .update({'imageUrl': url});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundImage: _pickedImage != null
              ? FileImage(_pickedImage)
              : imageUrl != null
                  ? NetworkImage(imageUrl)
                  : const AssetImage('assets/images/profile-icon.png'),
        ),
        TextButton.icon(
          onPressed: () {
            _showdialog(context);
          },
          icon: Icon(
            Icons.image,
            color: Theme.of(context).primaryColor,
          ),
          label: Text(
            "Upload Image",
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
        ),
      ],
    );
  }
}
