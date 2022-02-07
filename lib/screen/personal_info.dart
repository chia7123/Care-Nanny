import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fyp2/service/database.dart';
import 'package:fyp2/service/get_location.dart';
import 'package:fyp2/service/google_api.dart';
import 'package:fyp2/service/image_picker/signup_image_picker.dart';
import 'package:geolocator/geolocator.dart';

class PersonalInfo extends StatefulWidget {
  static const routeName = '/initialProfile';
  final String email;

  PersonalInfo(this.email);

  @override
  _PersonalInfoState createState() => _PersonalInfoState();
}

class _PersonalInfoState extends State<PersonalInfo> {
  final user = FirebaseAuth.instance.currentUser;
  final _formKey = GlobalKey<FormState>();
  final List<String> _users = ['Customer', 'Confinement Lady'];
  String _selectedUser;
  File _userImageFile;

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
    email.value = TextEditingValue(text: widget.email);
    desc.value = const TextEditingValue(text: 'Briefly introduce yourself');
  }

  void _pickedImage(File image) {
    _userImageFile = image;
  }

  void _updateProfile() async {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();

    final imageStorage = FirebaseStorage.instance
        .ref()
        .child('user_profile_image')
        .child(user.uid + '.jpg');

    await imageStorage.putFile(_userImageFile);
    final url = await imageStorage.getDownloadURL();

    if (_selectedUser == null) {
      Fluttertoast.showToast(msg: 'Please select a user type');
      return;
    }

    if (isValid) {
      Database().updateUserData(user.uid, {
        'name': name.text,
        'phone': phone.text,
        'address1': add1.text,
        'address2': add2.text,
        'address3': add3.text,
        'userType': _selectedUser,
        'imageUrl': url,
        'email': email.text,
        'description': desc.text,
        'id': user.uid,
        'rating': 0,
        'orderSuccess': 0,
      }).whenComplete(() => {
            Fluttertoast.showToast(msg: 'Sign up successful'),
            Navigator.of(context).pop()
          });
    }
  }

  Future getAddress() async {
    try {
      Position position = await GetLocation().getCurrentLocation();

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
      backgroundColor: Theme.of(context).canvasColor,
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 1,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 22, top: 40),
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Profile Detail',
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    )),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 22),
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Please fill in the following information.')),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.8,
                child: Card(
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
                            SignUpImagePicker(_pickedImage),
                            const SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              key: ValueKey('name'),
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
                              keyboardType:
                                  const TextInputType.numberWithOptions(),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  flex: 5,
                                  child: TextFormField(
                                    key: const ValueKey('add1'),
                                    decoration: const InputDecoration(
                                      labelText: '3. Address 1',
                                      hintText: 'Select the GPS to get your address.'
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
                            TextFormField(
                              readOnly: true,
                              decoration: InputDecoration(
                                hintMaxLines: 2,
                                hintText: '7. User ID: ' + user.uid,
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                '8. Please Select a User Type',
                                style: TextStyle(color: Colors.grey.shade700),
                                softWrap: true,
                              ),
                            ),
                            Align(
                              key: const ValueKey('user'),
                              alignment: Alignment.centerLeft,
                              child: DropdownButton(
                                value: _selectedUser,
                                onChanged: (newValue) {
                                  setState(() {
                                    _selectedUser = newValue as String;
                                  });
                                },
                                items: _users.map((user) {
                                  return DropdownMenuItem(
                                    child: Text(user),
                                    value: user,
                                  );
                                }).toList(),
                              ),
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
                                labelText: '9. Description',
                              ),
                              controller: desc,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _updateProfile,
                    child: const Text(
                      'Save',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                        primary: Theme.of(context).primaryColor),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
