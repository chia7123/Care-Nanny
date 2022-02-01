import 'package:flutter/material.dart';
import 'package:fyp2/authentication/login.dart';
import 'package:fyp2/authentication/signup.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({ Key key }) : super(key: key);

  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool isToggle = false;
  void toggleScreen(){
    setState(() {
      isToggle= !isToggle;
    });
  }
  @override
  Widget build(BuildContext context) {
    if(isToggle){
      return SignUp(toggleScreen:toggleScreen);
    }
    else{
      return Login(toggleScreen:toggleScreen);
    }
  }
}