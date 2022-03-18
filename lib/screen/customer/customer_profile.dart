import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fyp2/service/database.dart';
import 'package:fyp2/service/location.dart';
import 'package:fyp2/service/google_api.dart';
import 'package:fyp2/service/media_picker/user_image_picker.dart';
import 'package:fyp2/widgets/menu_widget.dart';
import 'package:geolocator/geolocator.dart';

class CustomerProfile extends StatefulWidget {
  static const routeName = '/Profile';

  @override
  _CustomerProfileState createState() => _CustomerProfileState();
}

class _CustomerProfileState extends State<CustomerProfile> {
  final user = FirebaseAuth.instance.currentUser;
  final _formKey = GlobalKey<FormState>();
  String usertype;
  String imageUrl;

  TextEditingController name = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController add1 = TextEditingController();
  TextEditingController add2 = TextEditingController();
  TextEditingController add3 = TextEditingController();
  TextEditingController email = TextEditingController();

  FToast fToast;

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
        imageUrl = data['imageUrl'];
        usertype = data['userType'];
      }
    });
  }

  void _updateProfile() async {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      Database().updateUserData(user.uid, {
        'name': name.text,
        'phone': phone.text,
        'address1': add1.text,
        'address2': add2.text,
        'address3': add3.text,
      }).whenComplete(() => {Fluttertoast.showToast(msg: 'Update sucessful')});
    }
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
          'Profile',
        ),
        leading: const MenuWidget(),
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
      body: Center(
        child: Card(
          margin:
              const EdgeInsets.only(left: 20, top: 20, right: 20, bottom: 15),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
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
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
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
                      key: const ValueKey('Email'),
                      readOnly: true,
                      decoration: const InputDecoration(
                        labelText: '6. Email',
                      ),
                      controller: email,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
