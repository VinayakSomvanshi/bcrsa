import 'dart:async';
// import 'dart:convert';
import 'dart:ui';
import 'package:forveel/Resources/themes/light_color.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:forveel/Data/staticdata.dart';
import 'package:forveel/Resources/Internet/check_network_connection.dart';
import 'package:forveel/Resources/Internet/internetpopup.dart';
import 'package:forveel/ui/Mycolors.dart';
import 'package:forveel/ui/Pages/home.dart';
import 'package:forveel/ui/Widgets/History/history_card.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:http/http.dart';
// import 'package:fluttertoast/fluttertoast.dart';

// ignore: use_key_in_widget_constructors
class HistoryPage extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  StreamSubscription<QuerySnapshot> subscription;
  Position _position;
  bool loading;
  List<DocumentSnapshot> _servicedata;
  CustomPopupMenu choice;
  List<CustomPopupMenu> choices;
  List<bool> filter = [true, true, true];
  @override
  void initState() {
    choices = <CustomPopupMenu>[
      CustomPopupMenu(
          title: 'All',
          icon: Icons.all_inclusive,
          onclick: () {
            setState(() {
              filter[0] = true;
              filter[1] = true;
              filter[2] = true;
            });
          }),
      CustomPopupMenu(
          title: 'Requests',
          icon: Icons.call,
          onclick: () {
            setState(() {
              filter[0] = true;
              filter[1] = false;
              filter[2] = false;
            });
          }),
      CustomPopupMenu(
          title: 'Under Service',
          icon: Icons.network_locked,
          onclick: () {
            setState(() {
              filter[1] = true;
              filter[0] = false;
              filter[2] = false;
            });
          }),
      CustomPopupMenu(
          title: 'History',
          icon: Icons.av_timer,
          onclick: () {
            setState(() {
              filter[2] = true;
              filter[0] = false;
              filter[1] = false;
            });
          }),
    ];
    // TODO: implement initState
    loading = true;
    _getcurrentlocation();
    super.initState();
    print("HistoryPage initState() called");
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
        title: Text(
          "History",
          style: GoogleFonts.lato(color: LightColor.darkgrey),
        ),
        actions: <Widget>[
          PopupMenuButton<CustomPopupMenu>(
            color: LightColor.black,
            icon: const Icon(
              Icons.more_vert,
              color: LightColor.black,
            ),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            elevation: 10,
            onSelected: (choice) {
              choice.onclick();
            },
            itemBuilder: (BuildContext context) {
              return choices.map((CustomPopupMenu choice) {
                return PopupMenuItem<CustomPopupMenu>(
                  value: choice,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Icon(
                        choice.icon,
                        color: grey,
                      ),
                      Text(
                        choice.title,
                        style: GoogleFonts.lato(color: grey),
                      )
                    ],
                  ),
                );
              }).toList();
            },
          )
        ],
      ),
      body: Container(
          child: loading
              ? Center(
                  child: SpinKitThreeBounce(
                    color: myyellow,
                  ),
                )
              : (_servicedata != null && _servicedata.isNotEmpty )
                  ? Container(
                      decoration: const BoxDecoration(color: LightColor.black),
                      child: ClipRRect(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                          child: ListView.builder(
                              itemCount: _servicedata.length,
                              itemBuilder: (context, index) {
                                if (_servicedata[index]['status'] ==
                                        "pending" &&
                                    filter[0]) {
                                  return HistoryCard(
                                    _servicedata[index],
                                    _position,
                                  );
                                  
                                } else if ((_servicedata[index]['status']
                                            .contains('cancelled') ||
                                        _servicedata[index]['status'] ==
                                            "success") &&
                                    filter[2]) {
                                  return HistoryCard(
                                      _servicedata[index], _position);
                                } else if ((_servicedata[index]['status'] ==
                                            "accepted" ||
                                        _servicedata[index]['status'] ==
                                            "picked up" ||
                                        _servicedata[index]['status'] ==
                                            "repaired" ||
                                        _servicedata[index]['status'] ==
                                            "out for pickup") &&
                                    filter[1]) {
                                  return HistoryCard(
                                      _servicedata[index], _position);
                                 
                                }
                                // print("_servicedata[index]: ${_servicedata[index]}");
                                return const SizedBox(
                                  height: 0,
                                  width: 0,
                                );
                              }),
                        ),
                      ),
                    )
                  : SizedBox(
                      child: Center(
                        child: Text(
                          "No History Data!",
                          style: TextStyle(color: myyellow),
                        ),
                      ),
                    )),
    );
  }

  _refreshavalability() async {
    subscription = FirebaseFirestore.instance
        .collection('service')
        .where('userid', isEqualTo: Home.userdata.id)
        .snapshots()
        .listen((event) {
      if (event.docs.isNotEmpty) {
        if (!mounted) return;

        setState(() {
          _servicedata = event.docs;
        });
      }
    });
  }

  _loadhistory() async {
    if (await IsConnectedtoInternet()) {
      // ignore: use_build_context_synchronously
      ShowInternetDialog(context);
      return;
    }

    FirebaseFirestore.instance
        .collection('service')
        .where('userid', isEqualTo: Home.userdata.id)
        // .orderBy("datetime", descending: true)
        .get()
        .then((value) {
      _servicedata = value.docs;
      if (_servicedata.isNotEmpty) {
        staticdata.historydata = _servicedata;
        if (!mounted) return;

        setState(() {
          loading = false;
          _servicedata = _servicedata;
        });
      } else {
        if (!mounted) return;

        setState(() {
          loading = false;
          _servicedata = _servicedata;
        });
      }
    });
    _refreshavalability();
  }

  _getcurrentlocation() async {
    _position = await Geolocator.getCurrentPosition();
    if (_position == null) {
      _position = await Geolocator.getLastKnownPosition();
    }
    if (staticdata.historydata != null) {
      if (!mounted) return;
      setState(() {
        loading = false;
        _servicedata = staticdata.historydata;
      });
      await _refreshavalability();
      return;
    }
    _loadhistory();
  }

  @override
  void dispose() {
    subscription.cancel();
    // TODO: implement dispose
    super.dispose();
  }
}

class CustomPopupMenu {
  CustomPopupMenu({this.title, this.icon, this.onclick});
  String title;
  IconData icon;
  VoidCallback onclick;
}
