import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mechanicfinder/ui/Mycolors.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:toast/toast.dart';

import 'Addressbox.dart';

class AddLocation extends StatefulWidget {
  @override
  _AddLocationState createState() => _AddLocationState();
}

class _AddLocationState extends State<AddLocation> {
  late Position _position;
  late String _address;
  late String _city;
  late double pinpill;
  int a = 0;
  bool move = true;

  static const LatLng _center = const LatLng(19.26806793449255, 72.96724717955107);
  Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};
  Completer<GoogleMapController> _mapController = Completer();
  MapType _currentMapType = MapType.normal;
  late GoogleMapController _mapcontroller;

  @override
  void initState() {
    pinpill = -500;
    a = 0;
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          GoogleMap(
            markers: Set<Marker>.of(_markers.values),
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 12.0,
            ),
            onCameraMove: _oncameramove,
            mapType: _currentMapType,
            onCameraIdle: () {
              if (a == 1) {
                setState(() {
                  _getgeocodedaddress(_position);
                  pinpill = 80;
                });
                a = 0;
              }
            },
          ),
          // Addressbox(_address, pinpill,top: 10,),
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              padding: EdgeInsets.all(20),
              child: FloatingActionButton(
                backgroundColor: background,
                child: Icon(
                  Icons.arrow_forward,
                  color: blue,
                ),
                onPressed: () async {
                  bool waiter = await showDialog(
                      context: context,
                      barrierDismissible: true,
                      builder: (context) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                          title: Text(
                            "Are you sure you wants to submit this address?",
                            style: GoogleFonts.lato(color: grey),
                          ),
                          actions: <Widget>[
                            ElevatedButton(
                              child: Text(
                                "Yes",
                                style: GoogleFonts.lato(color: green),
                              ),
                              onPressed: () {
                                if (_city != null &&
                                    _address != null &&
                                    _position != null) {
                                  Navigator.pop(context, true);
                                } else {
                                  Toast.show("Please select a location!");
                                }
                              },
                            ),
                            ElevatedButton(
                              child: Text(
                                "Cancel",
                                style: GoogleFonts.lato(color: voilet),
                              ),
                              onPressed: () {
                                Navigator.pop(context, false);
                              },
                            ),
                          ],
                        );
                      });
                  if (waiter) {
                    Navigator.pop(context, {
                      "address": _address,
                      "city": _city,
                      "lat": _position.latitude.toString(),
                      "long": _position.longitude.toString()
                    });
                  }
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  void _onMapCreated(GoogleMapController controller) async {
    _mapController.complete(controller);
    _mapcontroller = controller;
    getcurrentlocation();
  }

  _addusermarker(Position position) async {
    MarkerId markerId = MarkerId("mid");
    Marker marker = Marker(
        markerId: markerId,
        position: LatLng(position.latitude, position.longitude),
        draggable: false,
        icon: await BitmapDescriptor.fromAssetImage(
            ImageConfiguration(devicePixelRatio: 2.5),
            "assets/images/mechanic.png"));
    if (!mounted) return;
    setState(() {
      _markers[markerId] = marker;
    });
  }

  Future<void> getcurrentlocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
      setState(() {
        _position = position;
      });
      _getgeocodedaddress(_position);
    } catch (e) {
      Position? lastPosition = await Geolocator.getLastKnownPosition();
      setState(() {
        _position = lastPosition!;
      });
      _getgeocodedaddress(_position);
    }
  }

  _getgeocodedaddress(Position position) async {
    _position = Position(
      latitude: position.latitude,
      longitude: position.longitude,
      timestamp: DateTime.now(),
      accuracy: 0.0,
      altitude: 0.0,
      heading: 0.0,
      speed: 0.0,
      speedAccuracy: 0.0,
    );
    if (!mounted) return;
    if (move) {
      _mapcontroller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(_position.latitude, _position.longitude),
            zoom: 18,
          ),
        ),
      );
      move = false;
    }
    final coordinates = new Coordinates(position.latitude, position.longitude);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    if (!mounted) return;
    setState(() {
      pinpill = 80;
      _address = ' ${first.locality}, ${first.adminArea},${first.subLocality},'
          ' ${first.subAdminArea},${first.addressLine}, ${first.featureName},${first.thoroughfare != null ? first.thoroughfare : ""}, ${first.subThoroughfare != null ? first.subThoroughfare : ""}';
      _address = _address.replaceAll("null", "");
    });
    _city = first.locality;
    _addusermarker(_position);
  }

  void _oncameramove(CameraPosition position) {
    a = 1;
    _position = Position(
        timestamp: DateTime.now(),
        accuracy: 0.0,
        altitude: 0.0,
        heading: 0.0,
        speed: 0.0,
        speedAccuracy: 0.0,
        latitude: position.target.latitude,
        longitude: position.target.longitude);
    if (_markers.length > 0) {
      MarkerId markerId = MarkerId("mid");
      Marker? marker = _markers[markerId];
      if (marker != null) {
        Marker updatedMarker = marker.copyWith(
          positionParam: position.target,
        );
        if (!mounted) return;
        setState(() {
          pinpill = -500;
          _markers[markerId] = updatedMarker;
        });
      }
    }
  }
}
