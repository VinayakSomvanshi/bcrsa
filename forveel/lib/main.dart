import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:forveel/ui/Mycolors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'package:forveel/ui/Widgets/Start/logindecider.dart';

void main() async {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent));
       WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MaterialApp(
    theme: new ThemeData(
      backgroundColor: background,
      hintColor: textc,
      buttonColor: green,
      primaryColor: voilet,
      primaryColorDark: myappbar,
    ),
    debugShowCheckedModeBanner: false,
    title: "RSA",
    home: LoginDecider(),
  ));
}
