import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mechanicfinder/Resources/Internet/check_network_connection.dart';
import 'package:mechanicfinder/Resources/Internet/internetpopup.dart';
import 'package:mechanicfinder/Resources/themes/light_color.dart';
import 'package:mechanicfinder/ui/Pages/home.dart';
import 'package:mechanicfinder/ui/Pages/puncturehome.dart';
import 'package:mechanicfinder/ui/Pages/waiting.dart';
import 'package:mechanicfinder/ui/Start/Register/register.dart';
import 'package:mechanicfinder/ui/Start/forgot/Forgot.dart';
import 'package:mechanicfinder/ui/loader_dialog.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

import '../../Mycolors.dart';

class LoginFormPage extends StatefulWidget {
  @override
  _LoginFormPageState createState() => _LoginFormPageState();
}

class _LoginFormPageState extends State<LoginFormPage> {
  late String phone;
  late String password;
  late bool showpass;
  var _formkey = GlobalKey<FormState>();
  @override
  void initState() {
    showpass = true;
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formkey,
      child: ListView(
        children: <Widget>[
          Text(
            "Login",
            style: TextStyle(color: pink, letterSpacing: 2, fontSize: 30),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          new TextFormField(
            style: TextStyle(color: grey),
            maxLength: 10,
            keyboardType: TextInputType.number,
            decoration: new InputDecoration(
              counterText: "",
              labelText: "Phone Number",
              border: new OutlineInputBorder(
                gapPadding: 7,
                borderRadius: new BorderRadius.circular(10),
              ),
            ),
            // ignore: missing_return
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please enter your phone number";
              } else {
                phone = value;
                return null;
              }
            },
          ),
          SizedBox(height: 15),
          Padding(
            padding: EdgeInsets.all(0),
            child: new TextFormField(
              obscureText: showpass,
              style: TextStyle(color: grey),
              keyboardType: TextInputType.emailAddress,
              decoration: new InputDecoration(
                suffixIcon: IconButton(
                  icon: Icon(showpass
                      ? FontAwesomeIcons.eyeSlash
                      : FontAwesomeIcons.eye),
                  onPressed: () {
                    setState(() {
                      showpass == false ? showpass = true : showpass = false;
                    });
                  },
                ),
                labelText: "Password",
                border: new OutlineInputBorder(
                  gapPadding: 7,
                  borderRadius: new BorderRadius.circular(10),
                ),
              ),
              // ignore: missing_return
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter your password";
                } else {
                  password = value;
                  return null;
                }
              },
            ),
          ),
          Container(
            alignment: Alignment.center,
            width: 100,
            child: ElevatedButton(
              // color: myyellow,
              // shape: RoundedRectangleBorder(
              //     borderRadius: BorderRadius.circular(30)
              // ),
              onPressed: () {
                if (_formkey.currentState!.validate()) {
                  // ();
                  _loginuser();
                }
              },
              child: Text(
                'Login',
                style: TextStyle(color: background),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 10),
            alignment: Alignment.bottomCenter,
            child: ElevatedButton(
              // borderSide: BorderSide(color: LightColor.orange),
              child: Text(
                "Do not have an account? Register",
                style: GoogleFonts.lato(color: Color.fromARGB(255, 255, 255, 255)),
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    PageTransition(
                        child: Register(),
                        type: PageTransitionType.fade,
                        duration: Duration(milliseconds: 50)));
              },
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 4),
            alignment: Alignment.bottomCenter,
            child: ElevatedButton(
              // borderSide: BorderSide(color: LightColor.skyBlue),
              child: Text(
                "Forgot password?",
                style: GoogleFonts.lato(color: Color.fromARGB(255, 255, 0, 0)),
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    PageTransition(
                        child: Forgot(),
                        type: PageTransitionType.fade,
                        duration: Duration(milliseconds: 50)));
              },
            ),
          ),
        ],
      ),
    );
  }

  _loginuser() async {
    if (await IsConnectedtoInternet()) {
      ShowInternetDialog(context);
      return;
    }
    LoaderDialog(context, false);
    FirebaseFirestore.instance
        .collection('mechanic')
        .where('phone', isEqualTo: phone)
        .get()
        .then((value) async {
      if (value.docs.isNotEmpty) {
        if (value.docs[0]['pwd'] != password) {
          Navigator.pop(context);
          Toast.show("Wrong Password",
              textStyle: grey,
              backgroundColor: Colors.red,
              gravity: Toast.center,
              duration: Toast.lengthLong);
        } else {
          FirebaseFirestore.instance
              .collection('mechanic')
              .doc(value.docs[0].id)
              .update({
            "datetime": DateTime.now().millisecondsSinceEpoch.toString()
          });
          await FirebaseAuth.instance.signInAnonymously();
          Navigator.pop(context);
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('userlogin', value.docs[0].id);
          if (value.docs[0]['verified']) {
            if (value.docs[0]["onlypuncture"]) {
              Navigator.push(
                  context,
                  PageTransition(
                      child: PunctureHome(value.docs[0]),
                      type: PageTransitionType.fade,
                      duration: Duration(milliseconds: 50)));
            } else {
              Navigator.push(
                  context,
                  PageTransition(
                      child: Home(value.docs[0]),
                      type: PageTransitionType.fade,
                      duration: Duration(milliseconds: 50)));
            }
          } else {
            Navigator.push(
                context,
                PageTransition(
                    child: waiting(value.docs[0]),
                    type: PageTransitionType.fade,
                    duration: Duration(milliseconds: 50)));
          }
        }
      } else {
        Navigator.pop(context);
        Toast.show("Account does not exists",
            textStyle: grey,
            backgroundColor: Colors.red,
            gravity: Toast.center,
            duration: Toast.lengthLong);
      }
    });
  }

  static const platform = const MethodChannel('samples.flutter.dev/battery');

  Future<void> _startActivity() async {
    try {
      String result = await platform.invokeMethod('StartSecondActivity');
      if (result == "success") {
        _loginuser();
      } else {
        Toast.show("Please allow location permission");
      }
    } on PlatformException catch (e) {
      debugPrint("Error: '${e.message}'.");
      Toast.show("Please allow location permission");
    }
  }
}
