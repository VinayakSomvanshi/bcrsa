import 'dart:convert';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:forveel/Resources/Internet/check_network_connection.dart';
import 'package:forveel/Resources/Internet/internetpopup.dart';
import 'package:forveel/ui/Pages/mechanic_page_uid.dart';
import 'package:forveel/ui/Pages/mechanic_update_page.dart';
import 'package:forveel/ui/loader_dialog.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:page_transition/page_transition.dart';
import 'package:time_formatter/time_formatter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vibration/vibration.dart';

import '../../Mycolors.dart';

class HistoryCard extends StatefulWidget {
  DocumentSnapshot data;
  Position position;
  HistoryCard(this.data, this.position);

  @override
  _HistoryCardState createState() => _HistoryCardState();
}

class _HistoryCardState extends State<HistoryCard> {
  String formatted = "";
  @override
  void initState() {
    // TODO: implement initState
    // formatted = formatTime(int.parse(widget.data['datetime']));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          if (widget.data['status'] != "success" &&
              widget.data['status'] != "cancelled by you" &&
              widget.data['status'] != "cancelled by mechanic") {
            Navigator.push(
                context,
                PageTransition(
                    child: MechanicUpdatePage(
                        widget.data['mechanicid'],
                        widget.data['status'],
                        widget.data.id,
                        widget.data['issue'],
                        widget.data['uservehicle']),
                    type: PageTransitionType.fade,
                    duration: Duration(milliseconds: 100)));
          } else {
            Fluttertoast.showToast(
                msg: "This request was ${widget.data['status']}",
                gravity: ToastGravity.TOP,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.grey[600],
                textColor: Colors.white,
                fontSize: 16.0);
          }
        },
        child: Card(
          elevation: 15,
          color: background.withOpacity(0.3),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Container(
              padding: EdgeInsets.all(6),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: background.withOpacity(0.3),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        blurRadius: 20,
                        offset: Offset.zero,
                        color: Colors.grey.withOpacity(0.5))
                  ]),
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                        margin: EdgeInsets.only(left: 10),
                        width: 50,
                        height: 50,
                        child: ClipOval(
                            // child: (widget.data['photo'] == "" ||
                            //         widget.data['photo'] == null)
                            child: Image.asset("assets/images/mechanic.png",
                                fit: BoxFit.cover)
                            //     : CachedNetworkImage(
                            //         imageUrl: widget.data['photo'].toString(),
                            //         placeholder: (context, url) =>
                            //             CircularProgressIndicator(),
                            //         errorWidget: (context, url, error) =>
                            //             Icon(Icons.error),
                            //       )
                            )),

                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(left: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                                "${widget.data['shopname']} (${widget.data['name']})",
                                style: GoogleFonts.lato(
                                    color: background,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text("Status - " + widget.data['status'],
                                    style: GoogleFonts.lato(
                                        fontSize: 14,
                                        color: green,
                                        fontWeight: FontWeight.w600)),
                                Row(
                                  children: <Widget>[
                                    (widget.data['status'] ==
                                                "cancelled by you" ||
                                            widget.data['status'] ==
                                                "cancelled by mechanic")
                                        ? Icon(
                                            Icons.error,
                                            color: Colors.red,
                                            size: 10,
                                          )
                                        : (widget.data['status'] == "success")
                                            ? Icon(
                                                Icons.done_outline,
                                                color: Colors.green,
                                                size: 10,
                                              )
                                            : Container(),
                                    SizedBox(
                                      width: 4,
                                    ),
                                    (widget.data['status'] == "success")
                                        ? IconButton(
                                            icon: Icon(
                                              FontAwesomeIcons.pen,
                                              size: 20,
                                              color: Colors.blue,
                                              semanticLabel:
                                                  widget.data['charges'],
                                            ),
                                            onPressed: _dialogdesider,
                                          )
                                        : Container(),
                                    // (widget.data['status'] == "success")
                                    //     ? ElevatedButton(
                                    //         style: ElevatedButton.styleFrom(
                                    //             shape: RoundedRectangleBorder(
                                    //                 borderRadius:
                                    //                     BorderRadius.circular(
                                    //                         8.0)),
                                    //             foregroundColor:
                                    //                 Color(0xffffffff),
                                    //             backgroundColor:
                                    //                 Color(0xFF272727),
                                    //             side: BorderSide(
                                    //                 color: Color(0xFF272727)),
                                    //             padding:
                                    //                 const EdgeInsets.symmetric(
                                    //                     vertical: 5.0,
                                    //                     horizontal: 5.0)),
                                    //         onPressed: () {},
                                    //         child: Text("pay"))
                                    //     : Container()
                                  ],
                                )
                              ],
                            ),
                            Container(
                              child: (widget.data['reason'].isNotEmpty)
                                  ? Text(
                                      widget.data['reason'],
                                      style: TextStyle(color: background),
                                    )
                                  : Container(),
                            ),
                            (widget.data['status'] == "success")
                                ? Text(" Rs. ${widget.data['charges']}",
                                    style: TextStyle(
                                        fontSize: 12, color: background))
                                : Text(
                                    widget.data['issue'],
                                    style: TextStyle(color: background),
                                  ),
                            Text(
                              "vehicle :${widget.data['uservehicle']}",
                              style: TextStyle(color: background),
                            ),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Row(
                                children: <Widget>[
                                  Icon(Icons.av_timer, color: background),
                                  Text(
                                    formatted,
                                    style: TextStyle(color: background),
                                  ),
                                ],
                              ),
                            )
                          ], // end of Column Widgets
                        ), // end of Column
                      ), // end of Container
                    ),
                    GestureDetector(
                      child: Padding(
                        padding: EdgeInsets.all(15),
                        child: Column(
                          children: <Widget>[
                            Icon(
                              FontAwesomeIcons.directions,
                              color: myyellow,
                            ),
                            Text(
                              "Directions",
                              style: TextStyle(fontSize: 10, color: background),
                            )
                          ],
                        ),
                      ),
                      onTap: (widget.position != null)
                          ? _launchMapsUrl
                          : () {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text("Problem starting navigation"),
                              ));
                            },
                    )

                    // third w// idget
                  ])),
        ),
      ),
    );
  }

  void _launchMapsUrl() async {
    if (await IsConnectedtoInternet()) {
      ShowInternetDialog(context);
      return;
    }
    final url =
        'https://www.google.com/maps/dir/?api=1&origin=${widget.position.latitude},${widget.position.longitude}&destination=${widget.data['lat']},${widget.data['long']}&travelmode=driving';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _showreviewdialog() {
    showDialog(
        barrierDismissible: true,
        context: context as BuildContext,
        builder: (context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            elevation: 10,
            backgroundColor: background,
            content: Container(
                child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    return Icon(
                      FontAwesomeIcons.solidStar,
                      color: Colors.yellow,
                    );
                  }),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  widget.data['review'],
                  style: TextStyle(color: textc),
                )
              ],
            )),
            title: Text(
              "Rating and review",
              style: TextStyle(
                color: grey,
                letterSpacing: 2,
              ),
              textAlign: TextAlign.center,
            ),
          );
        });
  }

  _showreviewingdialog() {
    showDialog(
        barrierDismissible: true,
        context: context as BuildContext,
        builder: (context) {
          return reviewdialog(widget.data['shopname'], widget.data.id,
              widget.data['mechanicid']);
        });
  }

  _dialogdesider() {
    if (widget.data['isreviewed'] == true) {
      _showreviewdialog();
    } else {
      _showreviewingdialog();
    }
  }
}

class reviewdialog extends StatefulWidget {
  String shopname;
  String rid;
  String mid;

  reviewdialog(this.shopname, this.rid, this.mid);
  @override
  _reviewdialogState createState() => _reviewdialogState();
}

class _reviewdialogState extends State<reviewdialog> {
  TextEditingController _controller = new TextEditingController();
  bool doselect;
  int ind;
  int rating;
  List<String> imogi;

  @override
  void initState() {
    imogi = [
      "assets/images/emojia.png",
      "assets/images/sad.png",
      "assets/images/smile.png",
      "assets/images/emojib.png",
      "assets/images/emoji.png"
    ];

    doselect = true;
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaY: 5, sigmaX: 5),
        child: AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 10,
          backgroundColor: background,
          content: Container(
              child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              doselect
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(imogi.length, (index) {
                        return Container(
                          margin: EdgeInsets.all(4),
                          child: GestureDetector(
                            child: Image.asset(
                              imogi[index],
                              height: 30,
                              width: 30,
                            ),
                            onTap: () {
                              Vibration.vibrate(duration: 100);
                              rating = index;
                              setState(() {
                                ind = index;
                                doselect = false;
                              });
                            },
                          ),
                        );
                      }),
                    )
                  : Image.asset(
                      imogi[ind],
                      height: 30,
                      width: 30,
                    ),
              SizedBox(
                height: 20,
              ),
              TextField(
                style: TextStyle(color: textc),
                controller: _controller,
                maxLines: 5,
                maxLength: 1000,
                decoration: InputDecoration(hintText: "Write something..."),
              ),
              SizedBox(
                height: 10,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  primary: Colors
                      .blue, // specify the background color for the button
                ),
                child: Text(
                  "Submit",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  if (rating != null &&
                      _controller.text != "" &&
                      _controller.text != null) {
                    LoaderDialog(context, true);
                    _addreviewrating(
                        widget.rid, _controller.text, rating, widget.mid);
                  } else {
                    if (rating == null) {
                      Fluttertoast.showToast(
                          msg: "Please select an emoji!",
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0);
                    }

                    Vibration.vibrate(duration: 100);
                  }
                },
              )
            ],
          )),
          title: Text(
            "Rate/Review ${widget.shopname}",
            style: TextStyle(
              color: textc,
              letterSpacing: 2,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  _addreviewrating(rid, review, rating, mid) async {
    if (await IsConnectedtoInternet()) {
      ShowInternetDialog(context);
      return;
    }
    rating = rating + 1;
    await FirebaseFirestore.instance
        .collection('mechanic')
        .doc(mid)
        .get()
        .then((value) {
      rating = ((double.parse(value['rating']['value']) *
                      double.parse(value['rating']['count']) +
                  double.parse(rating.toString())) /
              (double.parse(value['rating']['count']) + 1))
          .toString();
      FirebaseFirestore.instance.collection('mechanic').doc(mid).update({
        'rating': {
          "value": rating,
          "count": (double.parse(value['rating']['count']) + 1).toString()
        }
      });
    });
    FirebaseFirestore.instance.collection('service').doc(rid).update({
      "review": review.toString(),
      "rating": rating.toString(),
      "isreviewed": true,
      "datetime": DateTime.now().millisecondsSinceEpoch.toString()
    }).then((value) {
      Fluttertoast.showToast(
          msg: "Review successfully submitted",
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
      Navigator.pop(context as BuildContext);
      Navigator.pop(context as BuildContext);
      Navigator.pop(context as BuildContext);
    });
  }
}
