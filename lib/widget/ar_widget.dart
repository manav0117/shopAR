import 'package:ar_core/ar_core.dart';
import 'package:flutter/material.dart';

import 'package:camera/camera.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

/// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: AugmentedReality(),
//     );
//   }

class AugmentedReality extends StatefulWidget {
  final String img;
  const AugmentedReality({Key? key, required this.img}) : super(key: key);

  @override
  _AugmentedRealityState createState() => _AugmentedRealityState();
}

class _AugmentedRealityState extends State<AugmentedReality> {
  @override
  Widget build(BuildContext context) {
    return Augmented(widget.img);
  }
}
