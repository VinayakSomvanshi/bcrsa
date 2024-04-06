import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:forveel/Resources/Internet/check_network_connection.dart';
import 'package:forveel/Resources/Internet/internetpopup.dart';
import 'package:forveel/Resources/ui/poweredby.dart';
import 'package:forveel/ui/Mycolors.dart';
import 'package:forveel/ui/Pages/home.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../loader_dialog.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  static const platform = const MethodChannel('samples.flutter.dev/battery');

  Color black = Colors.black;
  String myvarificationid;
  static var firebaseAuth = FirebaseAuth.instance;
  String phone;
  TextEditingController _controller = new TextEditingController();
  TextEditingController _controllerotp = new TextEditingController();
  double pinpilltop;
  double pinpilltopotp;
  double pinpillloading;
  String status;
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
    return WillPopScope(
        onWillPop: () {
          SystemNavigator.pop();
          return Future.value(true);
        },
        child: Scaffold(
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
                                "Road - Rescue",
                                style:
                                    GoogleFonts.lato(color: grey, fontSize: 40),
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
                                "Login",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.lato(
                                    color: textc,
                                    fontWeight: FontWeight.bold,
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
                                        borderRadius:
                                            BorderRadius.circular(10)),
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
                                          hintStyle:
                                              GoogleFonts.lato(color: black),
                                          border: InputBorder.none,
                                        ),
                                        controller: _controller,
                                      ),
                                    ),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      primary: voilet,
                                    ),
                                    child: Text(
                                      "Send OTP",
                                      style: GoogleFonts.lato(
                                        color: background,
                                      ),
                                    ),
                                    onPressed: () {
                                      if (_controller.text == "") return;
                                      startPhoneAuth(_controller.text);
                                    },
                                  ),
                                  Poweredby()
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
                                      "Change Number",
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
                                        borderRadius:
                                            BorderRadius.circular(10)),
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
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      primary: voilet,
                                    ),
                                    onPressed: () {
                                      if (_controllerotp.text.length < 6) {
                                        Fluttertoast.showToast(
                                            msg: "Please enter 6 digit code",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.CENTER,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor: Colors.red,
                                            textColor: Colors.white,
                                            fontSize: 16.0);
                                        return;
                                      }
                                      if (_controllerotp.text.isEmpty) return;
                                      _signInWithPhoneNumber(
                                          _controllerotp.text);
                                    },
                                    child: Text(
                                      "Submit",
                                      style:
                                          GoogleFonts.lato(color: background),
                                    ),
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
        )));
  }

  startPhoneAuth(phone) async {
    this.phone = phone;
    FocusScope.of(context as BuildContext).requestFocus(FocusNode());
    if (await IsConnectedtoInternet()) {
      ShowInternetDialog(context);
      return;
    }
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

  codeSent(String verificationId, [int forceResendingToken]) async {
    myvarificationid = verificationId;
    phone = _controller.text;
    Fluttertoast.showToast(
        msg: "Code sent",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0);
    setState(() {
      pinpillloading = -500;
      pinpilltopotp = 1;
      pinpillloading = -500;
    });
  }

  codeAutoRetrievalTimeout(String verificationId) {
    Fluttertoast.showToast(
        msg: "Bruh",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  verificationFailed(FirebaseAuthException authException) {
    setState(() {
      pinpilltopotp = -500;
      pinpilltop = 1;
      pinpillloading = -500;
    });
    if (authException.message.contains('not authorized')) {
      setState(() {
        pinpilltopotp = -500;
        pinpilltop = 1;
        pinpillloading = -500;
      });
      Fluttertoast.showToast(
          msg: "Something has gone wrong, please try later",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    } else if (authException.message.contains('Network')) {
      setState(() {
        pinpilltopotp = -500;
        pinpilltop = 1;
        pinpillloading = -500;
      });
      Fluttertoast.showToast(
          msg: "Please check your internet connection and try again",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      setState(() {
        pinpilltopotp = -500;
        pinpilltop = 1;
        pinpillloading = -500;
      });
      Fluttertoast.showToast(
          msg: "Something has gone wrong, please try later",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  _OnAuthSuccess() async {
    LoaderDialog(context, false);
    _checkuserindatabase();
  }

  void verificationCompleted(AuthCredential phoneAuthCredential) async {
    firebaseAuth
        .signInWithCredential(phoneAuthCredential)
        .then((UserCredential value) {
      if (value.user != null) {
        Fluttertoast.showToast(
            msg: "Authentication Successful",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        _OnAuthSuccess();
      } else {
        setState(() {
          pinpilltopotp = -500;
          pinpilltop = 1;
          pinpillloading = -500;
        });
        Fluttertoast.showToast(
            msg: "Invalid auth",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    }).catchError((error) {
      setState(() {
        pinpilltopotp = -500;
        pinpilltop = 1;
        pinpillloading = -500;
      });
      Fluttertoast.showToast(
          msg: "Something has gone wrong, please try later",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    });
  }

  void _signInWithPhoneNumber(String smsCode) async {
    FocusScope.of(context as BuildContext).requestFocus(FocusNode());
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
      Fluttertoast.showToast(
          msg: "Wrong pin",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      return;
    }
    var _authCredential = PhoneAuthProvider.credential(
        verificationId: myvarificationid, smsCode: smsCode);

    firebaseAuth.signInWithCredential(_authCredential).catchError((error) {
      setState(() {
        setState(() {
          pinpilltopotp = -500;
          pinpilltop = 1;
          pinpillloading = -500;
        });
        Fluttertoast.showToast(
            msg: "Something has gone wrong, please try later",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      });
    }).then((user) async {
      if (user == null) {
        setState(() {
          status = "Wrong Otp";
          Fluttertoast.showToast(
              msg: "Wrong otp",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
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
          Fluttertoast.showToast(
              msg: "Wrong otp",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
          pinpilltopotp = -500;
          pinpilltop = 1;
          pinpillloading = -500;
        });
      }
    });
  }

  _checkuserindatabase() async {
  if (await IsConnectedtoInternet()) {
    ShowInternetDialog(context);
    return;
  }
  final QuerySnapshot result = await FirebaseFirestore.instance
    .collection("user")
    .where("phone", isEqualTo: this.phone)
    .get();

  final List<QueryDocumentSnapshot> documents = result.docs;

  if (documents.length == 0) {
    FirebaseFirestore.instance.collection("user").add({
      'phone': phone,
      "registerdatetime": DateTime.now().millisecondsSinceEpoch.toString(),
      "datetime": DateTime.now().millisecondsSinceEpoch.toString()
    }).then((value) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('userlogin', value.id.toString());
      value.get().then((value) {
        Navigator.push(
          context as BuildContext,
          PageTransition(
            child: Home(value),
            type: PageTransitionType.fade,
            duration: Duration(milliseconds: 10)
          )
        );
      });
    });
  } else {
    FirebaseFirestore.instance
      .collection('user')
      .doc(documents[0].id)
      .update({
        "datetime": DateTime.now().millisecondsSinceEpoch.toString()
      }).then((value) async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('userlogin', documents[0].id.toString());
        Navigator.push(
          context as BuildContext,
          PageTransition(
            child: Home(documents[0]),
            type: PageTransitionType.fade,
            duration: Duration(milliseconds: 10)
          )
        );
      });
  }
}
}