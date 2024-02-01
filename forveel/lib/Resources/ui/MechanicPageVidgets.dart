import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:forveel/Resources/Internet/check_network_connection.dart';
import 'package:forveel/ui/Mycolors.dart';
import 'package:forveel/ui/Pages/history_page.dart';
import 'package:google_fonts/google_fonts.dart';

class VtypesShow extends StatelessWidget {
  List<dynamic> vtypes;
  List<dynamic> two;
  List<dynamic> four;
  VtypesShow(this.vtypes, this.two, this.four);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 60,
      alignment: Alignment.center,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: List.generate(vtypes.length, (index) {
          return Container(
            margin: EdgeInsets.only(left: 6, right: 6),
            alignment: Alignment.center,
            child: OutlinedButton(
  style: OutlinedButton.styleFrom(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
    side: BorderSide(color: voilet),
  ),
  onPressed: () {},
  child: Row(
    mainAxisAlignment: MainAxisAlignment.center,
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      vtypes[index] == "tw"
          ? Icon(Icons.motorcycle, color: voilet)
          : Icon(Icons.directions_car, color: voilet),
      SizedBox(
        width: 5,
      ),
      vtypes[index] == "tw"
          ? Text(
              "Two wheeler",
              style: GoogleFonts.lato(color: voilet),
            )
          : Text(
              "Four wheeler",
              style: GoogleFonts.lato(color: voilet),
            ),
      SizedBox(
        width: 5,
      ),
      if (vtypes[index] == "tw")
        PopupMenuButton<dynamic>(
          color: background,
          icon: Icon(
            Icons.more_horiz,
            color: voilet,
          ),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 10,
          itemBuilder: (BuildContext context) {
            return two.map((dynamic choice) {
              return PopupMenuItem<dynamic>(
                value: choice,
                child: Text(
                  choice,
                  style: GoogleFonts.lato(color: grey),
                ),
              );
            }).toList();
          },
        ),
    ],
  ),
),
          );
        }),
      ),
    );
  }
}

class Skills extends StatelessWidget {
  List<dynamic> types;
  Skills(this.types);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 60,
      alignment: Alignment.center,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: List.generate(types.length, (index) {
          return Container(
              margin: EdgeInsets.only(left: 6, right: 6),
              alignment: Alignment.center,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  side: BorderSide(color: voilet),
                ),
                onPressed: () {},
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(FontAwesomeIcons.searchengin, color: voilet),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      repair(types[index]),
                      style: GoogleFonts.lato(color: voilet),
                    ),
                  ],
                ),
              ));
        }),
      ),
    );
  }

  String repair(value) {
    value = value.replaceAll("_", " ");
    return "${value[0].toUpperCase()}${value.substring(1)}";
  }
}
