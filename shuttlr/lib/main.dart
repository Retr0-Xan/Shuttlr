// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shuttlr/pages/landing_page.dart';
import 'package:shuttlr/pages/sign_in.dart';
import 'package:shuttlr/pages/register.dart';
import 'package:shuttlr/services/auth.dart';
import 'package:shuttlr/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:device_preview/device_preview.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
  // runApp(DevicePreview(enabled: !kReleaseMode, builder: (context) => MyApp()));
}

//we listen to auth changes and route accordingly
//using the StreamProvider.value from the provider class
//we select which stream we want to listen to in the value property
//since we are listening to this stream at the root widget, the data from the stream is accessible to the rest of its descendant widgets
class MyApp extends StatelessWidget {
  Future<void> _loadAssets(context) async {
    await precacheImage(AssetImage('assets/inside-bus.jpg'), context);
  }

  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    _loadAssets(context);
    return StreamProvider<User?>.value(
      value: AuthService().user,
      initialData: null,
      child: MaterialApp(
        // locale: DevicePreview.locale(context),
        // builder: DevicePreview.appBuilder,
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => LandingPage(),
          '/signin': (context) => SignIn(
                toggleView: () {
                  Navigator.popAndPushNamed(context, "/register");
                },
              ),
          '/register': (context) => Register(toggleView: () {
                Navigator.popAndPushNamed(context, "/signin");
              }),
        },
      ),
    );
  }
}
