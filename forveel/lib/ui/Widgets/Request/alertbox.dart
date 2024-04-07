import 'dart:convert';
import 'dart:ui';
import 'package:web3dart/web3dart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:forveel/Resources/Internet/check_network_connection.dart';
import 'package:forveel/Resources/Internet/internetpopup.dart';
import 'package:forveel/ui/Pages/history_page.dart';
import 'package:forveel/ui/Pages/home.dart';
import 'package:forveel/ui/Widgets/Request/RequestSentSuccessPage.dart';
import 'package:forveel/ui/Widgets/Request/selectvehicle.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:page_transition/page_transition.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../Mycolors.dart';
import '../../loader_dialog.dart';
import 'package:forveel/utils/web3_service.dart';
import '../../../utils/constants.dart';

class alertbox extends StatefulWidget {
 DocumentSnapshot mechanic;
 String address;
 alertbox(this.mechanic, this.address);
 @override
 _alertboxState createState() => _alertboxState();
}

class _alertboxState extends State<alertbox> {
 TextEditingController _controller = TextEditingController();
 String vehicle = "";
 Web3Service web3Service = Web3Service();
 http.Client httpClient;
 Web3Client ethClient;

 @override
 void initState() {
    super.initState();
    httpClient = http.Client();
    ethClient = Web3Client(infura_url, http.Client()); // Ensure infura_url is accessible
 }

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
                    hintText: "Explain Issue (Optional)",
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
                      _sendrequest(vehicle);
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

  void _sendrequest(String vehicleName) async {
 if (await IsConnectedtoInternet()) {
    ShowInternetDialog(context);
    return;
 }
 LoaderDialog(context, false);
 try {
    String vtype = vehicleName.split("-")[1]; // Extracting vtype from vehicle string
    String privateKey = private_key; // Replace this with actual private key retrieval logic

    // Corrected call to registerServiceRequest without ethClient argument
    final txHash = await web3Service.registerServiceRequest(vehicleName, vtype, privateKey);
    print('Transaction hash: $txHash');
      // Proceed with your existing logic to add the service request to Firestore
      FirebaseFirestore.instance.collection('service').add({
        "mechanicid": widget.mechanic.id,
        "userid": Home.userdata.id,
        "lat": widget.mechanic['lat'],
        "long": widget.mechanic['long'],
        "uservehicle": vehicleName,
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

        Navigator.pushReplacement(
            context,
            PageTransition(
                child: RequestSentSuccessPage(),
                type: PageTransitionType.fade,
                duration: Duration(milliseconds: 300)));
      });
    } catch (e) {
      print('Error registering service request: $e');
      // Handle error appropriately
    }
  }
}
