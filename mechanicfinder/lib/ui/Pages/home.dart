import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mechanicfinder/Resources/themes/light_color.dart';
import 'package:mechanicfinder/ui/Mycolors.dart';
import 'package:mechanicfinder/ui/Start/Login/Login.dart';
import 'package:mechanicfinder/ui/Widget/Home/Drawer.dart';
import 'package:mechanicfinder/ui/Widget/Home/online.dart';
import 'package:mechanicfinder/ui/Widget/Home/request.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  static DocumentSnapshot userdata = userdata;
  Home(DocumentSnapshot snapshot) {
    userdata = snapshot;
  }
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Position? _position;
  late List<DocumentSnapshot> _data;
  late bool loading;
  var locationOptions;

  late StreamSubscription<Position?> positionStream;
  var geolocator = Geolocator();
  List<bool> filter = [true, true, true];
  List<int> counts = [0, 0, 0];
  late StreamSubscription<QuerySnapshot> _subscription;

  @override
  void initState() {
    super.initState();
    loading = true;
    locationOptions =
        // LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 10);
        positionStream =
            Geolocator.getPositionStream().listen((Position position) {
      if (position != null) {
        setState(() {
          _position = position;
        });
      }
    });

    _getcurrentlocation();
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
        drawer: drawer(),
        appBar: AppBar(
          iconTheme: new IconThemeData(color: LightColor.orange),
          backgroundColor: LightColor.black,
          title: online(),
          centerTitle: true,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(48.0),
            child: Theme(
              data: Theme.of(context).copyWith(accentColor: Colors.white),
              child: Container(
                height: 48.0,
                alignment: Alignment.center,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                    CountsContainer(
                      text: "All",
                      counts: (counts[0] + counts[1] + counts[2]).toString(),
                      icon: Icons.all_inclusive,
                      active: filter.contains(false) ? false : true,
                      ontap: () {
                        setState(() {
                          filter[0] = true;
                          filter[1] = true;
                          filter[2] = true;
                        });
                      },
                    ),
                    CountsContainer(
                      text: "Requests",
                      counts: counts[0].toString(),
                      icon: Icons.call,
                      active:
                          (filter.contains(false) && filter[0]) ? true : false,
                      ontap: () {
                        setState(() {
                          filter[0] = true;
                          filter[1] = false;
                          filter[2] = false;
                        });
                      },
                    ),
                    CountsContainer(
                      text: "Under Service",
                      counts: counts[1].toString(),
                      icon: Icons.network_locked,
                      active:
                          (filter.contains(false) && filter[1]) ? true : false,
                      ontap: () {
                        setState(() {
                          filter[0] = false;
                          filter[1] = true;
                          filter[2] = false;
                        });
                      },
                    ),
                    CountsContainer(
                      text: "History",
                      counts: counts[2].toString(),
                      icon: Icons.av_timer,
                      active:
                          (filter.contains(false) && filter[2]) ? true : false,
                      ontap: () {
                        setState(() {
                          filter[0] = false;
                          filter[1] = false;
                          filter[2] = true;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          elevation: 0,
        ),
        body: Container(
          alignment: Alignment.center,
          child: () {
            if (loading) {
              return SpinKitCircle(
                color: grey,
              );
            } else if (_data == null) {
              return Center(
                child: Text("No services yet"),
              );
            } else {
              if (_data.isEmpty) {
                return Center(
                  child: Text("No services yet"),
                );
              }
              return Requests(_data, _position!, filter);
            }
          }(),
        ),
      ),
    );
  }

  _getcurrentlocation() async {
    _position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
    );
    _position ??= await Geolocator.getLastKnownPosition(
      
        // desiredAccuracy: LocationAccuracy.best,
        );
    setState(() {
      _position = _position;
    });
    _getData();
  }

  _getData() async {
    FirebaseFirestore.instance
        .collection('service')
        .where('mechanicid', isEqualTo: Home.userdata.id)
        .orderBy('datetime', descending: true)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        setState(() {
          loading = false;
          _data = value.docs;
        });
        _countdata(value.docs);
      } else {
        setState(() {
          loading = false;
        });
      }
    });
    _refreshdata();
  }

  _refreshdata() async {
    _subscription = FirebaseFirestore.instance
        .collection('service')
        .where('mechanicid', isEqualTo: Home.userdata.id)
        .orderBy('datetime', descending: true)
        .snapshots()
        .listen((event) {
      setState(() {
        _data = event.docs;
      });
      _countdata(event.docs);
    });
  }

  _countdata(List<DocumentSnapshot> data) async {
    counts = [0, 0, 0];
    for (int index = 0; index < data.length; index++) {
      if (data[index]['status'] == "accepted" ||
          data[index]['status'] == "picked up" ||
          data[index]['status'] == "repaired" ||
          data[index]['status'] == "out for pickup") {
        counts[1]++;
      } else if (data[index]['status'].contains('cancelled') ||
          data[index]['status'] == "success") {
        counts[2]++;
      } else if (data[index]['status'] == "pending") {
        counts[0]++;
      }
      setState(() {
        counts = counts;
      });
    }
  }

  @override
  void dispose() {
    _subscription.cancel();
    // TODO: implement dispose
    super.dispose();
  }
}

class CustomPopupMenu {
  CustomPopupMenu(
      {required this.title, required this.icon, required this.onclick});
  String title;
  IconData icon;
  VoidCallback onclick;
}

class CountsContainer extends StatefulWidget {
  String text;
  String counts;
  IconData icon;
  VoidCallback ontap;
  bool active;
  CountsContainer(
      {required this.text,
      required this.counts,
      required this.icon,
      required this.ontap,
      required this.active});
  @override
  _CountsContainerState createState() => _CountsContainerState();
}

class _CountsContainerState extends State<CountsContainer> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: widget.ontap,
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: widget.active ? blue : textc.withOpacity(0.3)),
          padding: EdgeInsets.all(3),
          margin: EdgeInsets.only(
            left: 6,
          ),
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(
                    widget.icon,
                    color: widget.active ? background : blue,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    widget.text,
                    style: GoogleFonts.lato(
                        color: widget.active ? background : grey),
                  ),
                ],
              ),
              Text(
                widget.counts,
                style: GoogleFonts.lato(
                    color: widget.active ? background : voilet),
              )
            ],
          ),
        ),
      ),
    );
  }
}
