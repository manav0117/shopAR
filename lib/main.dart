import 'package:e_com/authentication/login_page.dart';
import 'package:e_com/authentication/signup_page.dart';
import 'package:e_com/constants.dart';
import 'package:e_com/mini_tv/video_player_screen.dart';
import 'package:e_com/pages/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:e_com/pages/main_screen.dart';
import 'package:e_com/screens/onboarding_screen.dart';
import 'package:e_com/screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:camera/camera.dart';
import 'mini_tv/movie_screen.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

List<CameraDescription> cameras = [];
Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    cameras = await availableCameras();
    if (kIsWeb) {
      await Firebase.initializeApp(
          options: const FirebaseOptions(
              apiKey: 'AIzaSyDncXrj2APKg-_2tVLwwM1GvK8aSNUAtA4',
              appId: '1:806013008184:web:57f287c8a7259db20da9cd',
              messagingSenderId: '806013008184',
              projectId: 'moviesplayer-e6eea',
              storageBucket: "moviesplayer-e6eea.appspot.com",
              authDomain: "moviesplayer-e6eea.firebaseapp.com",
              measurementId: "G-DCV8MXC3Y8"));
    } else
      await Firebase.initializeApp();
  } on CameraException catch (e) {
    print(e.description);
  }
  Stripe.publishableKey =
      'pk_test_51MjhKzSDsX0Um2d9MMkih5dMim9v8yGW5WCZ5F867NVEQM3oZVC5ytp9zocKhMZchJmAGNZrmyvlxe9Tym8fJx1j00UyvERirZ';

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    FirebaseAuth _auth = FirebaseAuth.instance;
    return GetMaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
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
            primaryColor: kPrimaryColor,
            scaffoldBackgroundColor: kBackgroundColor,
            textTheme: Theme.of(context).textTheme.apply(bodyColor: kTextColor),
            visualDensity: VisualDensity.adaptivePlatformDensity),
        routes: {
          SplashScreen.id: (context) => SplashScreen(),
          OnBoardingScreen.id: (context) => OnBoardingScreen(),
          HomePage.id: (context) => HomePage(),
          MainScreen.id: (context) => MainScreen(),
          LoginScreen.id: (context) => LoginScreen(),
          SignUpScreen.id: (context) => SignUpScreen(),
          MoviesScreen.id: ((context) => MoviesScreen()),
        },
        home: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                // User is signed in
                return SplashScreen();
              }
              return LoginScreen();
            }));
  }
}
