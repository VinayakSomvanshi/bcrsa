import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mechanicfinder/Resources/Internet/check_network_connection.dart';
import 'package:mechanicfinder/Resources/Internet/internetpopup.dart';
import 'package:mechanicfinder/ui/Mycolors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toast/toast.dart';

class UploadVideo extends StatefulWidget {
  File? photo;
  File? adhar;
  UploadVideo(this.photo, this.adhar);
  @override
  _UploadVideoState createState() => _UploadVideoState();
}

class _UploadVideoState extends State<UploadVideo> {
  Widget? cent;
  String? adhar;
  String? photo;

  @override
  void initState() {
    super.initState();
    cent = Text("Starting...");
    uploadFile();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Container(
        height: MediaQuery.of(context).size.width / 4,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaY: 5, sigmaX: 5),
          child: AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: cent,
            content: Container(
              height: MediaQuery.of(context).size.width / 5,
              alignment: Alignment.center,
              child: SpinKitWave(
                color: Colors.blue, // Uncommented and specified a color
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future uploadFile() async {
    if (!await IsConnectedtoInternet()) {
      Navigator.pop(context);
      ShowInternetDialog(context);
      return;
    }

    String date = DateTime.now().millisecondsSinceEpoch.toString();
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference photoReference = storage.ref().child('profile/$date.jpeg');
    Reference adharReference = storage.ref().child('adhar/$date.jpeg');

    if (widget.photo == null || widget.adhar == null) {
      Toast.show("Please select a photo and adhar card.",
          backgroundColor: Colors.red);
      return;
    }

    try {
      UploadTask photoUploadTask = photoReference.putFile(widget.photo!);
      cent = _uploadStatus(photoUploadTask);
      await photoUploadTask.whenComplete(() async {
        String downloadUrl = await photoReference.getDownloadURL();
        // Do something with the download URL
      });

      UploadTask adharUploadTask = adharReference.putFile(widget.adhar!);
      cent = _uploadStatus(adharUploadTask);
      await adharUploadTask.whenComplete(() async {
        String adharURL = await adharReference.getDownloadURL();
        adhar = adharURL;
        if (adhar == null || photo == null) {
          Toast.show("Some error occurred!", backgroundColor: Colors.red);
          Navigator.pop(context);
        } else {
          Navigator.pop(context, {"adhar": adhar, "photo": photo});
        }
      });
    } catch (e) {
      Toast.show("An error occurred during upload: $e",
          backgroundColor: Colors.red);
    }
  }
}

String _bytesTransferred(TaskSnapshot snapshot) {
  double res = snapshot.bytesTransferred / 1024.0;
  double res2 = snapshot.totalBytes / 1024.0;
  double percentage = (res * 100) / res2;
  return percentage.toStringAsFixed(2);
}

Widget _uploadStatus(UploadTask task) {
  return StreamBuilder<TaskSnapshot>(
    stream: task.snapshotEvents,
    builder: (BuildContext context, AsyncSnapshot<TaskSnapshot> snapshot) {
      Widget subtitle;
      if (snapshot.hasData) {
        final TaskSnapshot snap = snapshot.data!;
        subtitle = Text('${_bytesTransferred(snap)}%');
      } else {
        subtitle = const Text('Starting...');
      }
      return ListTile(
        title: task.snapshot.state == TaskState.success
            ? Text(
                'Finishing...',
                style: GoogleFonts.lato(),
              )
            : Text(
                'Uploading..',
                style: GoogleFonts.lato(),
              ),
        subtitle: subtitle,
      );
    },
  );
}
