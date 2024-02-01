import 'dart:convert';

import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:forveel/Resources/Internet/check_network_connection.dart';
import 'package:forveel/Resources/Internet/internetpopup.dart';
import 'package:forveel/ui/Pages/history_page.dart';
import 'package:forveel/ui/Pages/home.dart';
import 'package:forveel/ui/Widgets/Request/selectvehicle.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:page_transition/page_transition.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../Mycolors.dart';
import '../../loader_dialog.dart';

class alertbox extends StatefulWidget {
  DocumentSnapshot mechanic;
  String address;
  alertbox(this.mechanic, this.address);
  @override
  _alertboxState createState() => _alertboxState();
}

class _alertboxState extends State<alertbox> {
  TextEditingController _controller = new TextEditingController();
  String vehicle = "";
  @override
  Widget build(BuildContext context) {
    return Container(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaY: 5.0, sigmaX: 5.0),
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 10,
          backgroundColor: background,
          title: ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              primary: voilet,
            ),
            child: Text(
              "Select Vehicle",
              style: GoogleFonts.lato(color: background),
            ),
            onPressed: () async {
              FocusScope.of(context).requestFocus(FocusNode());
              Map<String, dynamic> abc = await showDialog(
                context: context,
                builder: (context) {
                  return selectvehicle(
                    widget.mechanic['vehicle_type'],
                    widget.mechanic['Two wheeler'],
                    widget.mechanic['Four wheeler'],
                  );
                },
              );
              print("abc: $abc");
              if (abc != null && abc.containsKey("vehicle")) {
                setState(() {
                  vehicle = abc["vehicle"] + "-" + abc['vtype'];
                });
              }
            },
          ),
          content: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  vehicle,
                  style: TextStyle(color: grey),
                ),
                SizedBox(height: 7),
                TextField(
                  style: GoogleFonts.lato(color: grey),
                  controller: _controller,
                  maxLines: 5,
                  maxLength: 500,
                  decoration: const InputDecoration(
                    hintText: "Explain issue (optional)...",
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    primary: green,
                  ),
                  child: Text(
                    "Submit Request",
                    style: GoogleFonts.lato(color: background),
                  ),
                  onPressed: () {
                    if (vehicle.isEmpty) {
                      Fluttertoast.showToast(
                          msg: "Please select a vehicle!",
                          gravity: ToastGravity.TOP,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0);
                    } else {
                      _sendrequest(_controller.text, vehicle);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _sendrequest(text, vehicle) async {
    if (await IsConnectedtoInternet()) {
      ShowInternetDialog(context);
      return;
    }
    LoaderDialog(context, false);
    FirebaseFirestore.instance.collection('service').add({
      "mechanicid": widget.mechanic.id,
      "userid": Home.userdata.id,
      "issue": text,
      "lat": widget.mechanic['lat'],
      "long": widget.mechanic['long'],
      "uservehicle": vehicle,
      "status": "pending",
      "review": "",
      "charges": "",
      "rating": "",
      "isreviewed": false,
      "reason": "",
      "name": widget.mechanic['name'],
      "shopname": widget.mechanic['shopname'],
      "phone": Home.userdata['phone'].toString(),
      "address": widget.address,
      "datetime": DateTime.now().millisecondsSinceEpoch.toString(),
      "photo": widget.mechanic['photo'].toString()
    }).then((value) {
      if (!mounted) return;
      if (value == null) {
        Fluttertoast.showToast(
            msg: "An error occurred",
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        return;
      }

      Navigator.pop(context as BuildContext);
      Navigator.pop(context as BuildContext);
      Navigator.pop(context as BuildContext);
      Navigator.push(
          context as BuildContext,
          PageTransition(
              child: HistoryPage(),
              type: PageTransitionType.fade,
              duration: Duration(milliseconds: 10)));
    });
  }
}
