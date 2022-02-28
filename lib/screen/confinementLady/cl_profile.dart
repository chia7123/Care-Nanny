import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fyp2/service/database.dart';
import 'package:fyp2/service/media_picker/files_picker.dart';
import 'package:fyp2/service/location.dart';
import 'package:fyp2/service/google_api.dart';
import 'package:fyp2/service/media_picker/user_image_picker.dart';
import 'package:fyp2/widgets/full_screen_image.dart';
import 'package:geolocator/geolocator.dart';

import '../wrapper.dart';

class CLProfile extends StatefulWidget {
  static const routeName = '/clCLProfile';

  @override
  _CLProfileState createState() => _CLProfileState();
}

class _CLProfileState extends State<CLProfile> {
  final user = FirebaseAuth.instance.currentUser;
  final _formKey = GlobalKey<FormState>();
  String usertype;
  String imageUrl;
  List<PlatformFile> _userFiles;
  List<String> certUrl = [];

  TextEditingController name = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController add1 = TextEditingController();
  TextEditingController add2 = TextEditingController();
  TextEditingController add3 = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController desc = TextEditingController();

  @override
  void initState() {
    super.initState();
    Database().getUserData(user.uid).then((DocumentSnapshot snapshot) {
      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data();
        name.value = TextEditingValue(text: data['name']);
        phone.value = TextEditingValue(text: data['phone']);
        add1.value = TextEditingValue(text: data['address1']);
        add2.value = TextEditingValue(text: data['address2']);
        add3.value = TextEditingValue(text: data['address3']);
        email.value = TextEditingValue(text: data['email']);
        desc.value = TextEditingValue(text: data['description']);
        imageUrl = data['imageUrl'];
        usertype = data['userType'];
      }
    });
  }

  void _selectFile(List<PlatformFile> files) {
    _userFiles = files;
  }

  void _updateProfile() async {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();

    for (var file in _userFiles) {
      final fileStorage = FirebaseStorage.instance
          .ref()
          .child('CLCertificate')
          .child(user.uid)
          .child(file.name);

      await fileStorage.putFile(File(file.path));
      var url = await fileStorage.getDownloadURL();
      certUrl.add(url);
    }

    if (isValid) {
      Database().updateUserData(user.uid, {
        'name': name.text,
        'phone': phone.text,
        'address1': add1.text,
        'address2': add2.text,
        'address3': add3.text,
        'description': desc.text,
        'certUrl': FieldValue.arrayUnion(certUrl),
      }).whenComplete(() => {Fluttertoast.showToast(msg: 'Update sucessful')});
    }
  }

  void _deleteFile(String url) {
    FirebaseStorage.instance.refFromURL(url).delete().whenComplete(() {
      Database().deleteUserData(user.uid, 'certUrl', url);
      Fluttertoast.showToast(msg: 'Delete Completed!');
    });
  }

  Future getAddress() async {
    try {
      Position position = await LocationService().getCurrentLocation();

      Map<String, dynamic> map = await GoogleAPI().getAddress(position);
      List<dynamic> address = map["address_components"];
      setState(() {
        add1.text =
            address[0]['long_name'] + ' ' + address[1]['long_name'] + ',';
        add2.text =
            address[5]['long_name'] + ' ' + address[2]['long_name'] + ',';
        add3.text =
            address[3]['long_name'] + ', ' + address[4]['long_name'] + '.';
      });
      Database().updateUserData(user.uid, {
        'latitude': position.latitude,
        'longitude': position.longitude,
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Profile',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => _updateProfile(),
              child: const Text(
                'Save',
                style: TextStyle(color: Colors.white),
              ))
        ],
      ),
      backgroundColor: Theme.of(context).canvasColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              margin: const EdgeInsets.only(
                  left: 20, top: 20, right: 20, bottom: 25),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection('users')
                                .doc(user.uid)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.data == null) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              return UserImagePicker(snapshot.data['imageUrl']);
                            }),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          'User ID: ' + user.uid,
                          style:
                              const TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                        TextFormField(
                          key: const ValueKey('name'),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter your name';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            labelText: '1. Name',
                          ),
                          controller: name,
                        ),
                        TextFormField(
                          key: const ValueKey('phone'),
                          validator: (value) {
                            if (value.isEmpty ||
                                value.length > 11 ||
                                value.length < 10) {
                              return 'Please enter a valid phone number';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                              labelText: '2. Phone number',
                              hintText: 'Example: 01234567890'),
                          controller: phone,
                          keyboardType: const TextInputType.numberWithOptions(),
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 5,
                              child: TextFormField(
                                key: const ValueKey('add1'),
                                decoration: const InputDecoration(
                                  labelText: '3. Address 1',
                                ),
                                controller: add1,
                              ),
                            ),
                            Expanded(
                              child: IconButton(
                                onPressed: () => getAddress(),
                                iconSize: 20,
                                icon: const Icon(Icons.gps_fixed),
                              ),
                            ),
                          ],
                        ),
                        TextFormField(
                          key: const ValueKey('add2'),
                          decoration: const InputDecoration(
                            labelText: '4. Address 2',
                          ),
                          controller: add2,
                        ),
                        TextFormField(
                          key: const ValueKey('add3'),
                          decoration: const InputDecoration(
                            labelText: '5. Address 3',
                          ),
                          controller: add3,
                        ),
                        TextFormField(
                          readOnly: true,
                          key: const ValueKey('Email'),
                          decoration: const InputDecoration(
                            labelText: '6. Email',
                          ),
                          controller: email,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          key: const ValueKey('desc'),
                          minLines: 5,
                          maxLines: null,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: '7. Description',
                          ),
                          controller: desc,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '8. Certification',
                            style: TextStyle(
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                        StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection('users')
                                .doc(user.uid)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.data == null) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              return SizedBox(
                                height: 100,
                                child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: snapshot.data['certUrl'].length,
                                    itemBuilder: (context, index) {
                                      return GestureDetector(
                                        onTap: () => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  FullScreenImage(
                                                imageUrl: snapshot
                                                    .data['certUrl'][index],
                                              ),
                                            )),
                                        onLongPress: () => _deleteFile(
                                            snapshot.data['certUrl'][index]),
                                        child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: CachedNetworkImage(
                                              fit: BoxFit.fill,
                                              imageUrl: snapshot.data['certUrl']
                                                  [index],
                                              placeholder: (context, url) =>
                                                  const CircularProgressIndicator(),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      const Icon(Icons.error),
                                            )),
                                      );
                                    }),
                              );
                            }),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: FilesPicker(
                            fileSelectFn: _selectFile,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            TextButton.icon(
              icon: Icon(
                Icons.logout,
                color: Colors.red[600],
              ),
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.pushReplacementNamed(context, Wrapper.routeName);
              },
              label: Text(
                'Logout',
                style: TextStyle(color: Colors.red[600]),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
