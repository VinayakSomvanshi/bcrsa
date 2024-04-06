import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mechanicfinder/Resources/themes/light_color.dart';
import 'package:mechanicfinder/ui/Mycolors.dart';
import 'package:mechanicfinder/ui/Pages/home.dart';
import 'package:google_fonts/google_fonts.dart';

class PickupSetting extends StatefulWidget {
  @override
  _PickupSettingState createState() => _PickupSettingState();
}

class _PickupSettingState extends State<PickupSetting> {
  bool pickup = false; // initialize to false by default
  int a = 0;

  @override
  void initState() {
    super.initState();
    _loadPickupSetting();
  }

  Future<void> _loadPickupSetting() async {
    // Retrieve pickup setting from Firestore
    final snapshot = await FirebaseFirestore.instance
        .collection("mechanic")
        .doc(Home.userdata.id)
        .get();

    setState(() {
      pickup = snapshot.get('pickup') ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Pickup settings",
          style: GoogleFonts.lato(color: grey),
        ),
        backgroundColor: LightColor.black,
      ),
      body: Container(
        color: LightColor.lightGrey,
        child: ListView(
          children: <Widget>[
            ListTile(
              title: Text(
                "Enable Pickup",
                style: GoogleFonts.lato(color: grey),
              ),
              subtitle: Text(
                "You also pick up the vehicle from the location.",
                style: GoogleFonts.lato(color: grey),
              ),
              leading: Icon(
                FontAwesomeIcons.carCrash,
                color: LightColor.orange,
              ),
              trailing: Switch(
                value: pickup,
                onChanged: (value) async {
                  if (a == 1) return;
                  setState(() {
                    pickup = value;
                  });
                  a = 1;
                  await FirebaseFirestore.instance
                      .collection("mechanic")
                      .doc(Home.userdata.id)
                      .update({"pickup": value});
                  a = 0;
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
