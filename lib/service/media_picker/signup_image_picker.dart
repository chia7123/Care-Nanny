import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class SignUpImagePicker extends StatefulWidget {
  SignUpImagePicker(this.imagePickFn, {Key key}) : super(key: key);
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
    return Stack(
      children: [
        CircleAvatar(
          radius: 60,
          backgroundImage: _pickedImage != null
              ? FileImage(_pickedImage) 
              : const AssetImage('assets/images/profile-icon.png'),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).primaryColor,
            ),
            child: IconButton(
              onPressed: () {
                _showdialog(context);
              },
              icon: const Icon(
                Icons.add_a_photo,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
