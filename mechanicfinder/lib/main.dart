import 'package:flutter/material.dart';
import 'package:mechanicfinder/ui/Mycolors.dart';
import 'package:mechanicfinder/ui/Start/logindecider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: "forveel partner",
    home: LoginDecider(),
  ));
}
