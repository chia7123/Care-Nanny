import 'package:flutter/material.dart';
import 'package:fyp2/screen/authentication.dart';

class Welcome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[200],  
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(),
            Container(
              height: 400,
              child: FittedBox(
                child: Image.asset(
                  'assets/images/logo.png',
                ),
                fit: BoxFit.contain,
              ),
            ),
            const Spacer(),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Hey There, \nWelcome to CareNanny',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Login in your account to continue',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const Authenticate()));
              },
              style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                  onPrimary: Colors.black,
                  minimumSize: const Size(double.infinity, 50)),
              icon: const Icon(
                Icons.keyboard_arrow_right,
                size: 25,
              ),
              label: const Text('Press Here to Continue'),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
