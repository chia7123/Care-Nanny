import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ResetPassword extends StatelessWidget {
  ResetPassword({Key key}) : super(key: key);

  final auth = FirebaseAuth.instance;
  final TextEditingController email = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Reset Password'),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Align(
                alignment: Alignment.centerLeft,
                child: Text('Please enter your email address: ')),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              decoration: const InputDecoration(
                  hintText: 'Email: ', border: OutlineInputBorder()),
              controller: email,
            ),
            const SizedBox(
              height: 10,
            ),
            MaterialButton(
              color: Theme.of(context).primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Text(
                'Reset Password',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                resetPassword(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void resetPassword(BuildContext context) async {
    if (email.text.isEmpty || !email.text.contains('@')) {
      Fluttertoast.showToast(msg: "Please enter a valid email");
      return;
    }

    await auth.sendPasswordResetEmail(email: email.text);
    Fluttertoast.showToast(msg: 'Email link has been sent to your mail');
    Navigator.pop(context);
  }
}
