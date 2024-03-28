import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:forveel/ui/Widgets/History/history_card.dart';
import 'package:forveel/ui/Pages/history_page.dart';

class RequestSentSuccessPage extends StatefulWidget {
 @override
 _RequestSentSuccessPageState createState() => _RequestSentSuccessPageState();
}

class _RequestSentSuccessPageState extends State<RequestSentSuccessPage> with SingleTickerProviderStateMixin {
 AnimationController _controller;
 Animation<double> _animation;

 @override
 void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);

    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        PageTransition(
          child: HistoryPage(),
          type: PageTransitionType.fade,
          duration: Duration(milliseconds: 300),
        ),
      );
    });
 }

 @override
 void dispose() {
    _controller.dispose();
    super.dispose();
 }

 @override
 Widget build(BuildContext context) {
    return Container(
      color: Colors.lightGreen,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              AnimatedBuilder(
                animation: _animation,
                builder: (BuildContext context, Widget child) {
                 return Transform.scale(
                    scale: _animation.value,
                    child: Icon(
                      Icons.check,
                      size: 100.0, // Size of the check icon
                      color: Colors.white,
                    ),
                 );
                },
              ),
              SizedBox(height: 20), // Add some space between the icon and the text
              Text(
                'Request Verified and Sent Successfully!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
 }
}
