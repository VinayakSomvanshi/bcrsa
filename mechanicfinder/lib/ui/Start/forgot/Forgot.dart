import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mechanicfinder/Resources/Internet/check_network_connection.dart';
import 'package:mechanicfinder/Resources/Internet/internetpopup.dart';
import 'package:mechanicfinder/Resources/themes/light_color.dart';
import 'package:mechanicfinder/ui/Mycolors.dart';
import 'package:mechanicfinder/ui/Pages/home.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

import '../../loader_dialog.dart';

class Forgot extends StatefulWidget {
  @override
  _ForgotState createState() => _ForgotState();
}

class _ForgotState extends State<Forgot> {
  static const platform = const MethodChannel('samples.flutter.dev/battery');

  Color black = Colors.black;
  late String myvarificationid;
  static var firebaseAuth = FirebaseAuth.instance;
  late String phone;
  TextEditingController _controller = new TextEditingController();
  TextEditingController _controllerotp = new TextEditingController();
  late double pinpilltop;
  late double pinpilltopotp;
  late double pinpillloading;
  late String status;
  @override
  void initState() {
    status = "";
    pinpilltop = 1;
    pinpilltopotp = -500;
    pinpillloading = -500;
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: BoxDecoration(color: background),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaY: 6, sigmaX: 6),
        child: Container(
          child: Stack(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 50),
                      alignment: Alignment.center,
                      height: MediaQuery.of(context).size.height / 2,
                      child: Column(
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width / 2,
                            height: MediaQuery.of(context).size.width / 2,
                            child: ClipOval(
                              child: Image.asset(
                                "assets/images/forveel_logo_png.png",
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Text(
                            "Road - Rescue Partner",
                            style: GoogleFonts.lato(
                                color: LightColor.lightblack, fontSize: 30),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              //getting login
              AnimatedPositioned(
                duration: Duration(milliseconds: 300),
                bottom: pinpilltop,
                child: GestureDetector(
                  child: Container(
                    height: MediaQuery.of(context).size.height / 2,
                    width: MediaQuery.of(context).size.width,
                    child: ListView(
                      children: <Widget>[
                        Container(
                          alignment: Alignment.center,
                          child: Text(
                            "Enter phone number",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.lato(
                                color: textc,
                                fontWeight: FontWeight.w300,
                                fontSize: 30),
                          ),
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height / 2,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                margin: EdgeInsets.all(20),
                                elevation: 10,
                                color: Colors.white,
                                child: Container(
                                  padding: EdgeInsets.all(15),
                                  child: TextField(
                                    keyboardType: TextInputType.phone,
                                    maxLength: 10,
                                    style: GoogleFonts.lato(color: grey),
                                    decoration: InputDecoration(
                                      counterText: "",
                                      hintText: "Phone",
                                      hintStyle: GoogleFonts.lato(color: black),
                                      border: InputBorder.none,
                                    ),
                                    controller: _controller,
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                // shape: RoundedRectangleBorder(
                                //     borderRadius: BorderRadius.circular(15)
                                // ),
                                // color: voilet,
                                child: Text(
                                  "Send OTP",
                                  style: GoogleFonts.lato(color: background),
                                ),
                                onPressed: () {
                                  if (_controller.text == "") return;
                                  startPhoneAuth(_controller.text);
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  onTap: () {},
                ),
              ),

              //getting otp
              AnimatedPositioned(
                duration: Duration(milliseconds: 300),
                bottom: pinpilltopotp,
                child: GestureDetector(
                  child: Container(
                    height: MediaQuery.of(context).size.height / 2,
                    width: MediaQuery.of(context).size.width,
                    child: ListView(
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20)),
                          alignment: Alignment.center,
                          child: Material(
                            borderRadius: BorderRadius.circular(20),
                            child: InkWell(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Change number",
                                  style: GoogleFonts.lato(color: grey),
                                ),
                              ),
                              onTap: () {
                                setState(() {
                                  pinpilltopotp = -500;
                                  pinpilltop = 1;
                                  pinpillloading = -500;
                                });
                              },
                            ),
                          ),
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height / 2,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                margin: EdgeInsets.all(20),
                                elevation: 10,
                                color: Colors.white,
                                child: Container(
                                  padding: EdgeInsets.all(15),
                                  child: TextField(
                                    keyboardType: TextInputType.phone,
                                    maxLength: 6,
                                    style: GoogleFonts.lato(color: grey),
                                    decoration: InputDecoration(
                                        counterText: "",
                                        hintText: "OTP",
                                        hintStyle: TextStyle(color: black),
                                        border: InputBorder.none),
                                    controller: _controllerotp,
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                // shape: RoundedRectangleBorder(
                                //     borderRadius: BorderRadius.circular(15)
                                // ),
                                // color: voilet,
                                child: Text(
                                  "Submit",
                                  style: GoogleFonts.lato(color: background),
                                ),
                                onPressed: () {
                                  if (_controllerotp.text.length < 6) {
                                    Toast.show(
                                        "Please enter 6 digit code", );
                                    return;
                                  }
                                  if (_controllerotp.text.isEmpty) return;
                                  _signInWithPhoneNumber(_controllerotp.text);
                                },
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  onTap: () {},
                ),
              ),

              //loading
              AnimatedPositioned(
                duration: Duration(milliseconds: 300),
                bottom: pinpillloading,
                child: GestureDetector(
                  child: Container(
                      height: MediaQuery.of(context).size.height / 2,
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(status,
                              style: TextStyle(fontSize: 25, color: textc)),
                          SpinKitWave(color: textc)
                        ],
                      )),
                  onTap: () {},
                ),
              )
            ],
          ),
        ),
      ),
    ));
  }

  late String DocumentId;
  startPhoneAuth(phone) async {
    this.phone = phone;
    FocusScope.of(context).requestFocus(FocusNode());
    if (await IsConnectedtoInternet()) {
      ShowInternetDialog(context);
      return;
    }
    await FirebaseFirestore.instance
        .collection("mechanic")
        .where('phone', isEqualTo: phone)
        .get()
        .then((value) {
      if (value.docs.isEmpty) {
        Navigator.pop(context);
        Toast.show("No account with this number",
            duration: Toast.lengthLong);
      } else {
        DocumentId = value.docs[0].id;
      }
    });
    firebaseAuth.verifyPhoneNumber(
        phoneNumber: "+91" + phone,
        timeout: Duration(seconds: 60),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
    setState(() {
      pinpilltop = -500;
      pinpillloading = 1;
      status = "Sending OTP";
    });
  }

  codeSent(String verificationId, [ forceResendingToken= null]) async {
    myvarificationid = verificationId;
    phone = _controller.text;
    Toast.show("code sent",);
    setState(() {
      pinpillloading = -500;
      pinpilltopotp = 1;
      pinpillloading = -500;
    });
  }

  codeAutoRetrievalTimeout(String verificationId) {
    Toast.show("code auto retrival timeout",);
  }

  verificationFailed(FirebaseAuthException authException) {
    setState(() {
      pinpilltopotp = -500;
      pinpilltop = 1;
      pinpillloading = -500;
    });
     String errorMessage = authException.message ?? '';
    if (errorMessage.contains('not authorized')) {
      setState(() {
        pinpilltopotp = -500;
        pinpilltop = 1;
        pinpillloading = -500;
      });
      Toast.show('Something has gone wrong, please try later', );
    } else if (errorMessage.contains('Network')) {
      setState(() {
        pinpilltopotp = -500;
        pinpilltop = 1;
        pinpillloading = -500;
      });
      Toast.show(
          'Please check your internet connection and try again', );
    } else {
      setState(() {
        pinpilltopotp = -500;
        pinpilltop = 1;
        pinpillloading = -500;
      });
      Toast.show('Something has gone wrong, please try later', );
    }
  }

  _OnAuthSuccess() async {
    _setnewpass();
  }

  void verificationCompleted(AuthCredential phoneAuthCredential) async {
    firebaseAuth
        .signInWithCredential(phoneAuthCredential)
        .then((UserCredential value) {
      if (value.user != null) {
        Toast.show('Authentication successful', );
        _OnAuthSuccess();
      } else {
        setState(() {
          pinpilltopotp = -500;
          pinpilltop = 1;
          pinpillloading = -500;
        });
        Toast.show('Invalid code/invalid authentication');
      }
    }).catchError((error) {
      setState(() {
        pinpilltopotp = -500;
        pinpilltop = 1;
        pinpillloading = -500;
      });
      Toast.show('Something has gone wrong, please try later');
    });
  }

  void _signInWithPhoneNumber(String smsCode) async {
    FocusScope.of(context).requestFocus(FocusNode());
    if (await IsConnectedtoInternet()) {
      ShowInternetDialog(context);
      return;
    }
    setState(() {
      pinpilltopotp = -500;
      pinpilltop = -500;
      pinpillloading = 1;
      status = "Verifying OTP";
    });
    if (myvarificationid == "") {
      Toast.show("wrong pin",);
      return;
    }
    var _authCredential = await PhoneAuthProvider.credential(
        verificationId: myvarificationid, smsCode: smsCode);
    firebaseAuth.signInWithCredential(_authCredential).catchError((error) {
      setState(() {
        setState(() {
          pinpilltopotp = -500;
          pinpilltop = 1;
          pinpillloading = -500;
        });
        Toast.show("Something has gone wrong, please again", );
      });
    }).then((user) async {
      if (user == null) {
        setState(() {
          status = "Wrong Otp";
          Toast.show("wrong OTP", );
          pinpilltopotp = -500;
          pinpilltop = 1;
          pinpillloading = -500;
        });
        return;
      }
      if (user.user != null) {
        setState(() {
          pinpilltopotp = -500;
          pinpilltop = -500;
          pinpillloading = 1;
          status = "Logging in";
        });
        _OnAuthSuccess();
      } else {
        setState(() {
          status = "Wrong Otp";
          Toast.show("Wrong OTP", );
          pinpilltopotp = -500;
          pinpilltop = 1;
          pinpillloading = -500;
        });
      }
    });
  }

  _setnewpass() {
    TextEditingController _newpasscontroller = new TextEditingController();
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return WillPopScope(
            onWillPop: () {
              setState(() {
                status = "";
                pinpilltopotp = -500;
                pinpilltop = 1;
                pinpillloading = -500;
              });
              Navigator.pop(context);
              return Future.value(true);
            },
            child: AlertDialog(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Text(
                    "Set new password",
                    style: GoogleFonts.lato(color: LightColor.grey),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.cancel,
                      color: LightColor.orange,
                    ),
                    onPressed: () {
                      setState(() {
                        status = "";
                        pinpilltopotp = -500;
                        pinpilltop = 1;
                        pinpillloading = -500;
                      });
                      Navigator.pop(context);
                    },
                  )
                ],
              ),
              content: Container(
                width: MediaQuery.of(context).size.width - 20,
                height: MediaQuery.of(context).size.height / 2,
                alignment: Alignment.topCenter,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    TextField(
                      controller: _newpasscontroller,
                      decoration: InputDecoration(labelText: "New Password"),
                    ),
                    ElevatedButton(
                      // borderSide: BorderSide(color: LightColor.orange),
                      child: Text(
                        "Submit",
                        style: GoogleFonts.lato(color: LightColor.orange),
                      ),
                      onPressed: () => _setnew(_newpasscontroller.text),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  void _setnew(text) async {
    LoaderDialog(context, false);
    if (text == "") return;
    if (DocumentId != null) {
      FirebaseFirestore.instance
          .collection("mechanic")
          .doc(DocumentId)
          .update({"pwd": text}).then((value) {
        Toast.show('Password successfully reset',
            duration: Toast.lengthLong, gravity: Toast.center);
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pop(context);
      });
    }
  }
}
