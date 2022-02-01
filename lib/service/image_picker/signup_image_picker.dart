import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class SignUpImagePicker extends StatefulWidget {
  SignUpImagePicker(this.imagePickFn);
  final Function(File pickedImage) imagePickFn;
  @override
  _SignUpImagePickerState createState() => _SignUpImagePickerState();
}

class _SignUpImagePickerState extends State<SignUpImagePicker> {
  File _pickedImage;

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
        });
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
      widget.imagePickFn(_pickedImage);
    } on PlatformException catch (e) {
      Fluttertoast.showToast(msg: 'Failed to pick image :$e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          // ignore: unnecessary_null_comparison
          backgroundImage: _pickedImage != null
              ? FileImage(_pickedImage) 
              : const AssetImage('assets/images/profile-icon.png'),
        ),
        TextButton.icon(
          onPressed: () => _showdialog(context),
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
