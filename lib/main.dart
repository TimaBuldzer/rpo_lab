import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:rpo/screens/homepage/HomePageScreen.dart';
import 'package:rpo/state/settings.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

Future<void> main() async {
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _fbApp = Firebase.initializeApp();
  final controller = Get.put(Controller());

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetX<Controller>(
      builder: (_) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          textTheme: TextTheme(
            bodyText1: TextStyle(
                fontSize: controller.fontSize.value.toDouble(),
                color: controller.color.value),
            bodyText2: TextStyle(
                fontSize: controller.fontSize.value.toDouble(),
                color: controller.color.value),
          ),
          primarySwatch: Colors.red,
        ),
        home: FutureBuilder(
          future: _fbApp,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              print('Something gone wrong! ${snapshot.error.toString()}');
              return const Text('Something went wrong');
            } else if (snapshot.hasData) {
              return const HomePageScreen();
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
