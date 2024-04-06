import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:mechanicfinder/ui/Mycolors.dart';
import 'package:mechanicfinder/ui/Start/logindecider.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await _requestLocationPermission();
  await _requestCameraPermission(); // Request camera permission
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: "Road - Rescue : Mechanic",
    home: LoginDecider(),
  ));
}

Future<void> _requestLocationPermission() async {
  PermissionStatus status = await Permission.location.request();
  if (status.isGranted) {
    print('Location permission granted.');
  } else {
    print('Location permission denied.');
  }
}

Future<void> _requestCameraPermission() async {
  PermissionStatus status = await Permission.camera.request();
  if (status.isGranted) {
    print('Camera permission granted.');
  } else {
    print('Camera permission denied.');
  }
}
