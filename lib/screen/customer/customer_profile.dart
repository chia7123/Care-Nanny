import 'package:age_calculator/age_calculator.dart';
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
import 'package:intl/intl.dart';

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
  DateTime dateOfBirth;

  TextEditingController name = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController detailedAddress = TextEditingController();
  TextEditingController postalCode = TextEditingController();
  TextEditingController stateArea = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController bankBenefit = TextEditingController();
  TextEditingController bankAcc = TextEditingController();
  TextEditingController dob = TextEditingController();

  FToast fToast;

  @override
  void initState() {
    super.initState();

    Database().getUserData(user.uid).then((DocumentSnapshot snapshot) {
      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data();
        name.value = TextEditingValue(text: data['name']);
        phone.value = TextEditingValue(text: data['phone']);
        detailedAddress.value = TextEditingValue(text: data['detailAddress']);
        postalCode.value = TextEditingValue(text: data['postalCode']);
        stateArea.value = TextEditingValue(text: data['stateArea']);
        email.value = TextEditingValue(text: data['email']);
        dob.value = TextEditingValue(
            text: DateFormat('yyyy-MM-dd').format(data['dob'].toDate()));
        bankBenefit.value = TextEditingValue(text: data['beneficiaryBank']);
        bankAcc.value = TextEditingValue(text: data['bankAccNo']);
        imageUrl = data['imageUrl'];
        usertype = data['userType'];
      }
    });
  }

  void _updateProfile() async {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();
    if (dateOfBirth != null) {
      var age = AgeCalculator.age(dateOfBirth).years;
      Database().updateUserData(user.uid, {'dob': dateOfBirth, 'age': age});
    }

    if (isValid) {
      Database().updateUserData(user.uid, {
        'name': name.text,
        'phone': phone.text,
        'detailAddress': detailedAddress.text,
        'postalCode': postalCode.text,
        'stateArea': stateArea.text,
        'beneficiaryBank': bankBenefit.text,
        'bankAccNo': bankAcc.text,
      }).whenComplete(() => {Fluttertoast.showToast(msg: 'Update sucessful')});
    }
  }

  Future getAddress() async {
    try {
      Position position = await LocationService().getCurrentLocation();

      Map<String, dynamic> map = await GoogleAPI().getAddress(position);
      List<dynamic> address = map["address_components"];
      setState(() {
        detailedAddress.text = address[0]['long_name'] +
            ' ' +
            address[1]['long_name'] +
            ', ' +
            address[2]['long_name'] +
            ',';
        postalCode.text = address[6]['long_name'];
        stateArea.text =
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
                child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .doc(user.uid)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return const Text('something went wrong');
                      }
                      if (snapshot.connectionState == ConnectionState.active) {
                        final doc = snapshot.data;
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            UserImagePicker(doc['imageUrl']),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              'User ID: ' + user.uid,
                              style: const TextStyle(
                                  color: Colors.grey, fontSize: 12),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Row(
                                    children: [
                                      const Text(
                                        'Race : ',
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                      Text(
                                        doc['race'],
                                        style:
                                            const TextStyle(color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                ),
                                const Spacer(),
                                Expanded(
                                  flex: 2,
                                  child: Row(
                                    children: [
                                      const Text(
                                        'Religion : ',
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                      Text(
                                        doc['religion'],
                                        style:
                                            const TextStyle(color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  flex: 5,
                                  child: Row(
                                    children: [
                                      const Text(
                                        'Nationality : ',
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                      Text(
                                        doc['nationality'],
                                        style:
                                            const TextStyle(color: Colors.grey),
                                      )
                                    ],
                                  ),
                                ),
                                const Spacer(),
                                Expanded(
                                  flex: 4,
                                  child: Row(
                                    children: [
                                      const Text(
                                        'Vegetarian : ',
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                      doc['vegan']
                                          ? const Text(
                                              'Yes',
                                              style:
                                                  TextStyle(color: Colors.grey),
                                            )
                                          : const Text(
                                              'No',
                                              style:
                                                  TextStyle(color: Colors.grey),
                                            )
                                    ],
                                  ),
                                ),
                              ],
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
                                labelText: 'Name',
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
                                  labelText: 'Phone number',
                                  hintText: 'Example: 01234567890'),
                              controller: phone,
                              keyboardType:
                                  const TextInputType.numberWithOptions(),
                            ),
                            Row(
                              children: [
                                const Text('Date of Birth: '),
                                Expanded(
                                  child: TextFormField(
                                    readOnly: true,
                                    key: const ValueKey('dob'),
                                    controller: dob,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () async {
                                    final date = await showDatePicker(
                                      context: context,
                                      initialDate: doc['dob'].toDate(),
                                      firstDate: DateTime(1950),
                                      lastDate: DateTime.now(),
                                    );
                                    if (date == null) {
                                      return;
                                    } else {
                                      setState(() {
                                        dateOfBirth = date;
                                        dob.text = DateFormat('yyyy-MM-dd')
                                            .format(dateOfBirth);
                                      });
                                    }
                                  },
                                  icon: const Icon(Icons.calendar_month),
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  flex: 5,
                                  child: TextFormField(
                                    key: const ValueKey('add1'),
                                    decoration: const InputDecoration(
                                      labelText: 'Address',
                                    ),
                                    controller: detailedAddress,
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
                                labelText: 'Postal Code',
                              ),
                              controller: postalCode,
                            ),
                            TextFormField(
                              key: const ValueKey('add3'),
                              decoration: const InputDecoration(
                                labelText: 'Area, State',
                              ),
                              controller: stateArea,
                            ),
                            TextFormField(
                              key: const ValueKey('Email'),
                              readOnly: true,
                              decoration: const InputDecoration(
                                labelText: 'Email',
                              ),
                              controller: email,
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Banking Information',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            TextFormField(
                              key: const ValueKey('benefit bank'),
                              decoration: const InputDecoration(
                                labelText: 'Beneficiary Bank',
                                hintText:
                                    'Beneficiary Bank (Maybank, Public Bank, etc.)',
                              ),
                              controller: bankBenefit,
                            ),
                            TextFormField(
                              key: const ValueKey('bankAcc'),
                              decoration: const InputDecoration(
                                labelText: 'Bank Account No.',
                                hintText: 'Bank Account No.',
                              ),
                              controller: bankAcc,
                            ),
                          ],
                        );
                      }
                      return const Center(
                        child: CircularProgressIndicator.adaptive(),
                      );
                    }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
