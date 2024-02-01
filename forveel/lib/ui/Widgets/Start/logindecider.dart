import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:forveel/Resources/Internet/check_network_connection.dart';
import 'package:forveel/Resources/Internet/internetpopup.dart';
import 'package:forveel/Resources/ui/poweredby.dart';
import 'package:forveel/ui/Mycolors.dart';
import 'package:forveel/ui/Pages/home.dart';
import 'package:forveel/ui/Widgets/Start/register.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginDecider extends StatefulWidget {
  @override
  _LoginDeciderState createState() => _LoginDeciderState();
}

class _LoginDeciderState extends State<LoginDecider> {
  bool _inter = false;
  bool _isLoggedIn = false;

  @override
  void initState() {
    _checklogin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/forveel_logo_png.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height / 3,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      "RSA",
                      style: GoogleFonts.lato(color: textc, fontSize: 40),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    (_inter)
                        ? _noInternet()
                        : (_isLoggedIn)
                            ? SizedBox.shrink()
                            : SpinKitWave(
                                color: textc,
                              )
                  ],
                ),
              ),
              Poweredby(),
            ],
          ),
        ),
      ),
    );
  }

  _checklogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('userlogin') && prefs.getString('userlogin') != "0") {
      String userId = prefs.getString('userlogin');
      FirebaseFirestore.instance.collection("user").doc(userId).get().then((value) {
        if (value.exists) {
          setState(() {
            _isLoggedIn = true;
          });
          Navigator.push(
            context as BuildContext,
            PageTransition(
              child: Home(value),
              type: PageTransitionType.fade,
              duration: Duration(milliseconds: 50),
            ),
          );
        } else {
          _getuser(userId);
        }
      });
    } else {
      Navigator.push(
        context as BuildContext,
        PageTransition(
          child: Register(),
          type: PageTransitionType.fade,
          duration: Duration(milliseconds: 50),
        ),
      );
    }
  }

  _getuser(id) async {
    if (await IsConnectedtoInternet()) {
      setState(() {
        _inter = true;
      });
      return;
    }
    FirebaseFirestore.instance.collection("user").doc(id).get().then((value) {
      if (!value.exists) {
        Navigator.push(
          context as BuildContext,
          PageTransition(
            child: Register(),
            type: PageTransitionType.fade,
            duration: Duration(milliseconds: 50),
          ),
        );
      } else {
        setState(() {
          _isLoggedIn = true;
        });
        Navigator.push(
          context as BuildContext,
          PageTransition(
            child: Home(value),
            type: PageTransitionType.fade,
            duration: Duration(milliseconds: 50),
          ),
        );
      }
    });
  }

  Widget _noInternet() {
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.error,
            color: Colors.red,
            size: 70,
          ),
          SizedBox(
            height: 7,
          ),
          Text("No Internet"),
          SizedBox(
            height: 7,
          ),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: Colors.blue.shade700),
            ),
            child: Text("Retry"),
            onPressed: () {
              setState(() {
                _inter = false;
              });
              _checklogin();
            },
          ),
        ],
      ),
    );
  }
}
