import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import 'package:hire/pages/log_in.dart';
import 'package:hire/pages/map.dart';
import 'package:hire/pages/camera.dart';
import 'package:hire/pages/cards.dart';
import 'package:hire/pages/menu.dart';
import 'package:hire/pages/qr.dart';
import 'package:hire/pages/qr_scan.dart';

//var cameras;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
//  cameras = await availableCameras();
  runApp(MyApp());
}

class AppState {
  bool loading;
  FirebaseUser user;
  String avatar = '';
  AppState(loading, user) {
    this.loading = loading;
    if (user == null) {
      FirebaseAuth.instance.currentUser().then((user) {
        this.user = user;
        this.avatar = user.photoUrl;
      });
    }
  }
}

class Account with ChangeNotifier {
  AppState app = AppState(false, null);

  get loading => app.loading;

  get user => app.user;

  get avatar => app.avatar;

  void changeState(bool newState) {
    app.loading = newState;
    notifyListeners();
  }

  void setUser(FirebaseUser user) {
    app.user = user;
    app.avatar = user.photoUrl;
    notifyListeners();
  }
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [ChangeNotifierProvider<Account>(create: (_) => Account())],
        child: MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
              // This is the theme of your application.
              //
              // Try running your application with "flutter run". You'll see the
              // application has a blue toolbar. Then, without quitting the app, try
              // changing the primarySwatch below to Colors.green and then invoke
              // "hot reload" (press "r" in the console where you ran "flutter run",
              // or simply save your changes to "hot reload" in a Flutter IDE).
              // Notice that the counter didn't reset back to zero; the application
              // is not restarted.
              primarySwatch: Colors.blue,
              // This makes the visual density adapt to the platform that you run
              // the app on. For desktop platforms, the controls will be smaller and
              // closer together (more dense) than on mobile platforms.
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            initialRoute: "/",
            routes: <String, WidgetBuilder>{
              "/": (BuildContext context) => Menu(),
              "/login": (BuildContext context) => Login(),
              "/map": (BuildContext context) => Map(),
              "/camera": (BuildContext context) => Camera(),
              "/cards": (BuildContext context) => Cards(),
              "/qr": (BuildContext context) => QR(),
              "/qr_scan": (BuildContext context) => QRScan(),
            }));
  }
}
