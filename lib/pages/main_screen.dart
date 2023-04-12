import 'package:e_com/authentication/login_page.dart';
import 'package:e_com/constants.dart';
import 'package:e_com/mini_tv/video_player_screen.dart';
import 'package:e_com/pages/cart_page.dart';
import 'package:e_com/pages/wishlist_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import '../mini_tv/movie_screen.dart';
import 'home_page.dart';

class MainScreen extends StatefulWidget {
  MainScreen({
    super.key,
  });
  static const String id = "main-page";

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final list = [HomePage(), CartScreen()];
  final items = [
    GButton(
      icon: Icons.home,
      text: "Home",
    ),
    GButton(
      icon: Icons.shopping_cart,
      text: "Cart Screen",
    ),
  ];

  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          leading: Image.asset(
            "assets/images/logo_1.png",
            height: 55,
          ),
          backgroundColor: kPrimaryColor,
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, MoviesScreen.id);
                },
                icon: Icon(Icons.movie)),
            IconButton(
                onPressed: () {
                  // Navigator.pushNamed(context, LoginScreen.id);
                  FirebaseAuth.instance.signOut();
                  Navigator.pushNamed(context, LoginScreen.id);
                },
                icon: Icon(Icons.logout_outlined))
          ],
        ),
        body: list[index],
        bottomNavigationBar: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
              child: GNav(
                tabs: items,
                gap: 8,
                backgroundColor: Colors.white,
                color: Colors.black,
                activeColor: kPrimaryColor,
                tabBackgroundColor: Colors.grey.shade800,
                padding: EdgeInsets.all(16),
                onTabChange: (selectedIndex) {
                  setState(() {
                    index = selectedIndex;
                  });
                },
                // onTabChange: (index) {
                //   Navigator.push(context, MaterialPageRoute(builder: (context) {
                //     return list[index];
                //   }));
                // },
              ),
            )));
  }
}
