import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';

class Dots extends StatelessWidget {
  const Dots({
    Key? key,
    required this.scrollPosition,
  }) : super(key: key);

  final double scrollPosition;

  @override
  Widget build(BuildContext context) {
    return Positioned(
        left: MediaQuery.of(context).size.width * 0.4,
        bottom: 10,
        child: DotsIndicator(
          dotsCount: 3,
          position: scrollPosition,
          decorator: DotsDecorator(
              size: Size.square(6),
              activeSize: Size(12, 6),
              activeShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4))),
        ));
  }
}
