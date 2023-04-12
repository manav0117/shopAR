import 'package:e_com/constants.dart';
import 'package:e_com/widget/banner_widget.dart';
import 'package:e_com/widget/products_widget.dart';
import 'package:flutter/material.dart';

import '../widget/search_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  static const String id = "home-screen";

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        children: [
          // Container(
          //   height: size.height * 0.08,
          //   child: Stack(children: <Widget>[
          //     Container(
          //       // child: Text(
          //       //   "ShopAR",
          //       //   style: Theme.of(context).textTheme.headline5!.copyWith(
          //       //       color: Colors.white, fontWeight: FontWeight.bold),
          //       // ),
          //       height: size.height * 0.1 - 27,
          //       decoration: BoxDecoration(
          //           color: kPrimaryColor,
          //           borderRadius: BorderRadius.only(
          //               bottomLeft: Radius.circular(36),
          //               bottomRight: Radius.circular(36))),
          //     ),
          //     Positioned(
          //         bottom: 0,
          //         left: 0,
          //         right: 0,
          //         child: Container(
          //           child: TextField(
          //             decoration: InputDecoration(
          //               enabledBorder: InputBorder.none,
          //               focusedBorder: InputBorder.none,
          //               hintText: "Search",
          //               hintStyle:
          //                   TextStyle(color: kPrimaryColor.withOpacity(0.5)),
          //             ),
          //           ),
          //           height: 54,
          //           margin: EdgeInsets.symmetric(horizontal: kDefaultPadding),
          //           decoration: BoxDecoration(
          //               color: Colors.white,
          //               borderRadius: BorderRadius.circular(20),
          //               boxShadow: [
          //                 BoxShadow(
          //                     offset: Offset(0, 10),
          //                     blurRadius: 50,
          //                     color: kPrimaryColor.withOpacity(0.23))
          //               ]),
          //         ))
          //   ]),
          // ),
          // //SearchWidget(),
          // SizedBox(
          //   height: 20,
          // ),
          // BannerWidget(),
          // SizedBox(
          //   height: 20,
          // ),
          // Text(
          //   "RECOMMENDED",
          //   style: TextStyle(
          //       color: kPrimaryColor.withOpacity(0.34),
          //       fontWeight: FontWeight.bold),
          // ),
          // SizedBox(
          //   height: 20,
          // ),
          ProductWidget(),
        ],
      ),
    ));
  }
}
