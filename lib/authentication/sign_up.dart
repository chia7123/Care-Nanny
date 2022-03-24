import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  final Function toggleScreen;
  const SignUp({Key key, this.toggleScreen}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController _emailController;
  TextEditingController _passwordController;
  final _formkey = GlobalKey<FormState>();
  bool _isLoading = false;
  String _errorMessage;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future signup(String email, String password) async {
    try {
      UserCredential authResult;
      authResult = await firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      Navigator.pop(context);
      setLoading(false);
      await FirebaseFirestore.instance
          .collection('users')
          .doc(authResult.user.uid)
          .set({
        'email': email,
        'name': null,
      });
      await FirebaseFirestore.instance
          .collection('rating')
          .doc(authResult.user.uid)
          .set({});
      await FirebaseFirestore.instance
          .collection('service')
          .doc(authResult.user.uid)
          .set({
            'basic':[],
            'premium':[],
            'deluxe':[],
          });
    } on SocketException {
      setLoading(false);
      setMessage('No internet, Please connect to internet');
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(errorMessage)));
    } catch (e) {
      setLoading(false);
      setMessage(e);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(errorMessage)));
    }
  }

  void setLoading(val) {
    _isLoading = val;
  }

  void setMessage(message) {
    _errorMessage = message.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Welcome',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Text(
                  'Sign up to continue',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                TextFormField(
                  validator: (val) {
                    if (val.isEmpty) {
                      return 'Please enter a email address';
                    } else {
                      if (!val.contains('@')) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                    hintText: 'Email',
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  controller: _emailController,
                ),
                const SizedBox(
                  height: 30,
                ),
                TextFormField(
                  validator: (val) =>
                      val.length < 8 ? 'Enter more then 8 character' : null,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    prefixIcon: const Icon(Icons.vpn_key),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  obscureText: true,
                  controller: _passwordController,
                ),
                const SizedBox(
                  height: 30,
                ),
                MaterialButton(
                  onPressed: () async {
                    if (_formkey.currentState.validate()) {
                      await signup(_emailController.text.trim(),
                          _passwordController.text.trim());
                    }
                  },
                  height: 50,
                  minWidth: isLoading ? null : double.infinity,
                  color: Theme.of(context).primaryColor,
                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: isLoading
                      ? null
                      : const Text(
                          'Sign Up',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    const Text('Already have an account ?'),
                    const SizedBox(
                      width: 2,
                    ),
                    TextButton(
                      onPressed: () {
                        widget.toggleScreen();
                      },
                      child: const Text('Login'),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
