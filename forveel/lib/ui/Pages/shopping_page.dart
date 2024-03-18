import 'package:flutter/material.dart';
import 'package:forveel/ui/Mycolors.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:walletconnect_dart/walletconnect_dart.dart';
import 'package:google_fonts/google_fonts.dart';

class ShoppingPage extends StatefulWidget {
  @override
  _ShoppingPageState createState() => _ShoppingPageState();
}

class _ShoppingPageState extends State<ShoppingPage> {
 

  // Create a connector
  final connector = WalletConnect(
    bridge: 'https://bridge.walletconnect.org',
    clientMeta: PeerMeta(
      name: 'WalletConnect',
      description: 'WalletConnect Developer App',
      url: 'https://walletconnect.org',
      icons: [
        'https://gblobscdn.gitbook.com/spaces%2F-LJJeCjcLrr53DcT1Ml7%2Favatar.png?alt=media'
      ],
    ),
  );

  var _session, session, _uri;
  connectMeatamaskWallet(BuildContext context) async {
    if (!connector.connected) {
      try {
        session = await connector.createSession(onDisplayUri: (uri) async {
          _uri = uri;
          await launchUrlString(uri, mode: LaunchMode.externalApplication);
        });
        setState(() {
          _session = session;
        });
        print(session);
      } catch (error) {
        print("error at connector $error");
      }
    }
  }
 @override
  Widget build(BuildContext context) {
    connector.on(
        'connect',
        (session) => setState(() {
              _session = session;
            }));
    connector.on(
        'session_update',
        (payload) => setState(() {
              _session = payload;
            }));
    connector.on(
        'disconnect',
        (session) => setState(() {
              _session = null;
            }));
    return Scaffold(
      body: (session == null)
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //     Padding(
                  //       padding: const EdgeInsets.all(8.0),
                  //       child: Text(
                  //         "please click button to connect with metamask wallet",
                  //         style: GoogleFonts.poppins(
                  // fontSize: 17, fontWeight: FontWeight.w400),
                  //       ),
                  //     ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0)),
                          foregroundColor: Color(0xffffffff),
                          backgroundColor: Color(0xFF272727),
                          side: BorderSide(color: Color(0xFF272727)),
                          padding: const EdgeInsets.symmetric(
                              vertical: 15.0, horizontal: 15.0)),
                      onPressed: () {
                        connectMeatamaskWallet(context);
                        print("Wallet connected");
                      },
                      child: Text("Connect Wallet"))
                ],
              ),
            )
          : Text("You are connected"),
    );
  }
}
