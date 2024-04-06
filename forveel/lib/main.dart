import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:forveel/ui/Mycolors.dart';
import 'package:forveel/ui/Widgets/Start/logindecider.dart';
import 'package:permission_handler/permission_handler.dart'; // Ensure this line is present

import 'firebase_options.dart';

void main() async {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    systemNavigationBarColor: Colors.transparent,
  ));
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Request location permission here
  await _requestLocationPermission();
  // Request notification permission here
  await _requestNotificationPermission();

  runApp(MaterialApp(
    theme: ThemeData(
      backgroundColor: background,
      hintColor: textc,
      buttonColor: green,
      primaryColor: voilet,
      primaryColorDark: myappbar,
    ),
    // darkTheme: ThemeData.dark(),
    debugShowCheckedModeBanner: false,
    title: "Road - Rescue : Customer",
    home: LoginDecider(),
  ));
}

// Function to request location permission
Future<void> _requestLocationPermission() async {
  PermissionStatus status = await Permission.location.request();
  if (status.isGranted) {
    print('Location permission granted.');
  } else {
    print('Location permission denied.');
  }
}

// Function to request notification permission
Future<void> _requestNotificationPermission() async {
  PermissionStatus status = await Permission.notification.request();
  if (status.isGranted) {
    print('Notification permission granted.');
  } else {
    print('Notification permission denied.');
  }
}
