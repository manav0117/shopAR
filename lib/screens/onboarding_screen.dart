import 'package:dots_indicator/dots_indicator.dart';
import 'package:e_com/constants.dart';
import 'package:e_com/pages/main_screen.dart';
import 'package:flutter/material.dart';

class OnBoardingScreen extends StatefulWidget {
  OnBoardingScreen({super.key});
  static const String id = "onboard-screen";

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  double scrollPosition = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        PageView(
          onPageChanged: (value) {
            setState(() {
              scrollPosition = value.toDouble();
            });
          },
          children: [
            OnBoardChange(
              boardColumn: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Welcome \n To the Shop",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
                  Container(
                    height: 300,
                    child: Image.asset(
                      "assets/images/1.png",
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            ),
            OnBoardChange(
              boardColumn: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("+10 Million Products \n +10 Categories \n +100 Brands",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20)),
                  Container(
                      height: 300,
                      child: Image.asset("assets/images/2.jfif",
                          fit: BoxFit.cover)),
                ],
              ),
            ),
            OnBoardChange(
              boardColumn: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Experience the Augmented Reality with us",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  Container(
                      height: 300,
                      child: Image.asset("assets/images/3.png",
                          fit: BoxFit.cover)),
                ],
              ),
            ),
          ],
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            DotsIndicator(
              dotsCount: 3,
              position: scrollPosition,
              decorator:
                  DotsDecorator(activeColor: Colors.white, color: Colors.black),
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, MainScreen.id);
                },
                child: scrollPosition == 2
                    ? Text("Contiue shopping")
                    : Text("Skip")),
            const SizedBox(
              height: 20,
            )
          ]),
        )
      ]),
    );
  }
}

class OnBoardChange extends StatelessWidget {
  const OnBoardChange({super.key, this.boardColumn});

  final Column? boardColumn;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: Colors.white,
          child: Center(
            child: boardColumn,
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 130,
            decoration: BoxDecoration(
                color: kPrimaryColor,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(100),
                    topRight: Radius.circular(100))),
          ),
        )
      ],
    );
  }
}
