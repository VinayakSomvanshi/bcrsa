import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mechanicfinder/Resources/themes/light_color.dart';
import 'package:mechanicfinder/ui/Mycolors.dart';
import 'package:mechanicfinder/ui/Pages/home.dart';
import 'package:mechanicfinder/ui/loader_dialog.dart';
import 'package:google_fonts/google_fonts.dart';

class AddBrands extends StatefulWidget {
  String selection;
  AddBrands(this.selection);
  @override
  _AddBrandsState createState() => _AddBrandsState();
}

class _AddBrandsState extends State<AddBrands> {
  List<Map> _bikes = [
    {'name': 'Honda', 'value': false},
    {'name': 'Hero', 'value': false},
    {'name': 'BMW', 'value': false},
    {'name': 'TVS', 'value': false},
    {'name': 'Bajaj', 'value': false},
    {'name': 'Yamaha', 'value': false},
    {'name': 'Royal Enfield', 'value': false},
    {'name': 'Suzuki', 'value': false},
    {'name': 'Piaggio', 'value': false},
    {'name': 'Mahindra', 'value': false},
    {'name': 'UM Lohia', 'value': false},
  ];
  List<Map> _car = [
    {'name': 'Maruti Suzuki', 'value': false},
    {'name': 'Toyota', 'value': false},
    {'name': 'Hyundai', 'value': false},
    {'name': 'Tata', 'value': false},
    {'name': 'Jeep', 'value': false},
    {'name': 'Ford', 'value': false},
    {'name': 'MG Motor', 'value': false},
    {'name': 'Honda', 'value': false},
    {'name': 'Mahindra', 'value': false},
    {'name': 'Kia', 'value': false},
    {'name': 'Volkswagen', 'value': false},
    {'name': 'Renault', 'value': false},
    {'name': 'BMW', 'value': false},
    {'name': 'Mercedes Benz', 'value': false},
    {'name': 'Datsun', 'value': false},
    {'name': 'Volvo', 'value': false},
    {'name': 'Fiat', 'value': false},
    {'name': 'Audi', 'value': false},
    {'name': 'Skoda', 'value': false},
    {'name': 'Mitsubishi', 'value': false},
    {'name': 'Nissan', 'value': false},
    {'name': 'jaguar', 'value': false},
    {'name': 'Lamborghini', 'value': false},
    {'name': 'Rolls Royce', 'value': false},
    {'name': 'Mini', 'value': false},
    {'name': 'Bugati', 'value': false},
    {'name': 'Aston Martin', 'value': false},
    {'name': 'Land Rover', 'value': false},
    {'name': 'Bentley', 'value': false},
    {'name': 'Force Motor', 'value': false},
    {'name': 'Tesla', 'value': false},
    {'name': 'Porche', 'value': false},
    {'name': 'Ferrari', 'value': false},
    {'name': 'Maserati', 'value': false},
    {'name': 'ISUZU', 'value': false},
    {'name': 'Bajaj', 'value': false},
    {'name': 'DC', 'value': false},
    {'name': 'Premier', 'value': false},
    {'name': 'Haval', 'value': false},
    {'name': 'Lexus', 'value': false},
    {'name': 'Chevrolet', 'value': false},
    {'name': 'Citroen', 'value': false},
  ];
  late DocumentSnapshot user;
  @override
  void initState() {
    user = Home.userdata;
    _startup(Home.userdata);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: LightColor.black,
        centerTitle: true,
        title: Text(
          widget.selection,
          style: GoogleFonts.lato(color: grey),
        ),
        actions: <Widget>[
          FloatingActionButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Text("Save"),
            onPressed: () {
              _save();
            },
          ),
        ],
      ),
      body: Container(
          alignment: Alignment.topCenter,
          color: background,
          child: () {
            if (widget.selection == "Two wheeler") {
              if (user['Two wheeler'].isEmpty) {
                return ListView.builder(
                    itemCount: _bikes.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(
                          _bikes[index]['name'],
                          style: GoogleFonts.lato(color: grey),
                        ),
                        leading: Icon(
                          Icons.motorcycle,
                          color: grey,
                        ),
                        trailing: Switch(
                          value: _bikes[index]['value'],
                          onChanged: (a) {
                            setState(() {
                              _bikes[index]['value'] = a;
                            });
                          },
                        ),
                      );
                    });
              } else {
                return ListView(
                  children: <Widget>[
                    Text(
                      "Brands you work on",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.lato(
                          color: grey,
                          fontWeight: FontWeight.w500,
                          fontSize: 20),
                    ),
                    Container(
                      alignment: Alignment.topCenter,
                      height: MediaQuery.of(context).size.height / 3,
                      child: Scrollbar(
                        child: ListView.builder(
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(
                                user['Two wheeler'][index],
                                style: GoogleFonts.lato(color: grey),
                              ),
                              leading: Icon(
                                Icons.motorcycle,
                                color: grey,
                              ),
                            );
                          },
                          shrinkWrap: true,
                          itemCount: user['Two wheeler'].length,
                        ),
                      ),
                    ),
                    Divider(
                      height: 2,
                    ),
                    Text(
                      "Add more brands",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.lato(
                          color: grey,
                          fontWeight: FontWeight.w500,
                          fontSize: 20),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 15),
                      alignment: Alignment.topCenter,
                      height: (MediaQuery.of(context).size.height) / 2,
                      child: Scrollbar(
                        child: ListView.builder(
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(
                                _bikes[index]['name'],
                                style: GoogleFonts.lato(color: grey),
                              ),
                              leading: Icon(
                                Icons.motorcycle,
                                color: grey,
                              ),
                              trailing: Switch(
                                value: _bikes[index]['value'],
                                onChanged: (a) {
                                  setState(() {
                                    _bikes[index]['value'] = a;
                                  });
                                },
                              ),
                            );
                          },
                          shrinkWrap: true,
                          itemCount: _bikes.length,
                        ),
                      ),
                    ),
                  ],
                );
              }
            } else if (widget.selection == "Four wheeler") {
              if (user['Four wheeler'].isEmpty) {
                return ListView.builder(
                    itemCount: _car.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(
                          _car[index]['name'],
                          style: GoogleFonts.lato(color: grey),
                        ),
                        leading: Icon(
                          Icons.directions_car,
                          color: grey,
                        ),
                        trailing: Switch(
                          value: _car[index]['value'],
                          onChanged: (a) {
                            setState(() {
                              _car[index]['value'] = a;
                            });
                          },
                        ),
                      );
                    });
              } else {
                return ListView(
                  children: <Widget>[
                    Text(
                      "Brands you work on",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.lato(
                          color: grey,
                          fontWeight: FontWeight.w500,
                          fontSize: 20),
                    ),
                    Container(
                      alignment: Alignment.topCenter,
                      height: MediaQuery.of(context).size.height / 3,
                      child: Scrollbar(
                        child: ListView.builder(
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(
                                user['Four wheeler'][index],
                                style: GoogleFonts.lato(color: grey),
                              ),
                              leading: Icon(
                                Icons.directions_car,
                                color: grey,
                              ),
                            );
                          },
                          shrinkWrap: true,
                          itemCount: user['Four wheeler'].length,
                        ),
                      ),
                    ),
                    Divider(
                      height: 2,
                    ),
                    Text(
                      "Add more brands",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.lato(
                          color: grey,
                          fontWeight: FontWeight.w500,
                          fontSize: 20),
                    ),
                    Container(
                      alignment: Alignment.topCenter,
                      height: (MediaQuery.of(context).size.height) / 2,
                      child: Scrollbar(
                        child: ListView.builder(
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(
                                _car[index]['name'],
                                style: GoogleFonts.lato(color: grey),
                              ),
                              leading: Icon(
                                Icons.directions_car,
                                color: grey,
                              ),
                              trailing: Switch(
                                value: _car[index]['value'],
                                onChanged: (a) {
                                  setState(() {
                                    _car[index]['value'] = a;
                                  });
                                },
                              ),
                            );
                          },
                          shrinkWrap: true,
                          itemCount: _car.length,
                        ),
                      ),
                    ),
                  ],
                );
              }
            }
            return Container(
              alignment: Alignment.center,
            );
          }()),
    );
  }

  _startup(DocumentSnapshot user) {
    if (user['Two wheeler'].isNotEmpty) {
      for (int i = 0; i < _bikes.length; i++) {
        if (user['Two wheeler'].contains(_bikes[i]['name'])) {
          _bikes[i]['value'] = true;
        }
      }
    }
    if (user['Four wheeler'].isNotEmpty) {
      for (int i = 0; i < _car.length; i++) {
        if (user['Four wheeler'].contains(_car[i]['name'])) {
          _car[i]['value'] = true;
        }
      }
    }
  }

  _save() async {
    LoaderDialog(context, false);
    if (widget.selection == "Two wheeler") {
      List<dynamic> _bikelist = _getbikes();
      FirebaseFirestore.instance
          .collection('mechanic')
          .doc(user.id)
          .update({"Two wheeler": _bikelist}).then((value) {
        FirebaseFirestore.instance
            .collection("mechanic")
            .doc(Home.userdata.id)
            .get()
            .then((value) {
          Home.userdata = value;
          setState(() {
            user = value;
            _startup(value);
          });
          Navigator.pop(context);
        });
      });
    } else if (widget.selection == "Four wheeler") {
      List<dynamic> _carlist = _getcars();
      FirebaseFirestore.instance
          .collection('mechanic')
          .doc(user.id)
          .update({"Four wheeler": _carlist}).then((value) {
        FirebaseFirestore.instance
            .collection("mechanic")
            .doc(Home.userdata.id)
            .get()
            .then((value) {
          Home.userdata = value;
          setState(() {
            user = value;
            _startup(value);
          });
          Navigator.pop(context);
        });
      });
    }
  }

  List<dynamic> _getbikes() {
    List<dynamic> temp = [];
    for (int i = 0; i < _bikes.length; i++) {
      if (_bikes[i]['value']) {
        temp.add(_bikes[i]['name']);
      }
    }
    return temp;
  }

  List<dynamic> _getcars() {
    List<dynamic> temp = [];
    for (int i = 0; i < _car.length; i++) {
      if (_car[i]['value']) {
        temp.add(_car[i]['name']);
      }
    }
    return temp;
  }
}
