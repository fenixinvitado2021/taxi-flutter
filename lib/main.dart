import 'package:flutter/material.dart';
import 'package:tagyourtaxi_driver/functions/functions.dart';
import 'package:tagyourtaxi_driver/functions/notifications.dart';
import 'pages/loadingPage/loadingpage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:socks5_client/socks5_client.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await Firebase.initializeApp();
  checkInternetConnection();

  initMessaging();

  final socks5Client = Socks5Client(
    socks5Host: '3.86.245.9',
    socks5Port: 9050,
  );

  http.Client client = http.Client(
    httpClient: socks5Client,
  );

  runApp(MyApp(client: client));
}

class MyApp extends StatelessWidget {
  final http.Client client;

  const MyApp({Key? key, required this.client}) : super(key: key);

  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    platform = Theme.of(context).platform;
    return GestureDetector(
        onTap: () {
          //remove keyboard on touching anywhere on the screen.
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
            FocusManager.instance.primaryFocus?.unfocus();
          }
        },
        child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'EEYTAXIuser',
            theme: ThemeData(),
            // set the http client configuration for the entire app
            builder: (context, child) {
              return http.ByteStream(
                  DelegatingStream.typed(client.send),
              ).toBytes().then((value) {
                String body = utf8.decode(value);
                return MaterialApp(
                  title: 'EEYTAXIuser',
                  theme: ThemeData(),
                  home: const LoadingPage(),
                );
              });
            }));
  }
}