import 'dart:ui';

import 'package:dots_indicator/dots_indicator.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'dots_indicator.dart';

class BannerWidget extends StatefulWidget {
  const BannerWidget({super.key});

  @override
  State<BannerWidget> createState() => _BannerWidgetState();
}

class _BannerWidgetState extends State<BannerWidget> {
  List<Map> files = [];

  Future<List<Map>> LoadImages() async {
    final ListResult result =
        await FirebaseStorage.instance.ref('banners').listAll();
    final List<Reference> allfiles = result.items;
    await Future.forEach(allfiles, (Reference file) async {
      final String fileUrl = await file.getDownloadURL();
      setState(() {
        files.add({"url": fileUrl, "path": file.fullPath});
      });
    });
    // print(files);
    return files;
  }

  List<String> bannerImages = [
    'https://firebasestorage.googleapis.com/v0/b/moviesplayer-e6eea.appspot.com/o/banners%2Fbanner1.webp?alt=media&token=742bf2a6-a697-47c0-b259-e3d45a288617',
    'https://firebasestorage.googleapis.com/v0/b/moviesplayer-e6eea.appspot.com/o/banners%2Fbanner2.webp?alt=media&token=a6bc3597-ec9f-4e6a-aa0e-08a3f01541af',
    'https://firebasestorage.googleapis.com/v0/b/moviesplayer-e6eea.appspot.com/o/banners%2Fbanner3.jpg?alt=media&token=7820ca4e-b256-4828-acae-52049059eeb3'
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    LoadImages();
  }

  double scrollPosition = 0;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: LoadImages(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return Stack(children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Container(
                    height: 140,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.red,
                    child: PageView(
                        onPageChanged: (value) {
                          setState(() {
                            scrollPosition = value.toDouble();
                          });
                        },
                        children: [
                          Image.network(snapshot.data[0]['url'],
                              fit: BoxFit.cover),
                          Image.network(snapshot.data[1]['url'],
                              fit: BoxFit.cover),
                          Image.network(snapshot.data[2]['url'],
                              fit: BoxFit.cover)
                        ]),
                  ),
                ),
              ),
              Dots(scrollPosition: scrollPosition)
            ]);
          }
          if (snapshot.hasData &&
              snapshot.connectionState == ConnectionState.waiting) {
            return Text('Loading');
          } else {
            return Text("...");
          }
        });
  }
}

    //     future: LoadImages(),
    //     builder: (context, AsyncSnapshot snapshot) {
    // if (snapshot.hasData &&
    //     snapshot.connectionState == ConnectionState.waiting) {
    //   return Text('Loading...');
    // }
    //   if (snapshot.hasData)
    //     return ListView.builder(
    //         itemCount: snapshot.data.length ?? 0,
    //         itemBuilder: (context, index) {
    //           print(snapshot.data[index]['url']);
    //           // final Map image = snapshot.data[index];
    //           // print(image['url']);
    //           return Column(
    //             children: [
    //               SizedBox(
    //                   height: 100,
    //                   child: Image.network(
    //                     snapshot.data[index]['url'],
    //                     fit: BoxFit.cover,
    //                   ))
    //             ],
    //           );
    //         });
    //   return Center(
    //     child: CircularProgressIndicator(),
    //   );
    // });
  

// Stack(
//       children: [
//         Padding(
//           padding: const EdgeInsets.all(10.0),
//           child: ClipRRect(
//             borderRadius: BorderRadius.circular(5),
//             child: Container(
//               height: 140,
//               width: MediaQuery.of(context).size.width,
//               color: Colors.red,
//               child: PageView(
//                   onPageChanged: (value) {
//                     setState(() {
//                       scrollPosition = value.toDouble();
//                     });
//                   },
//                   children: Image.network()),
//             ),
//           ),
//         ),
//         Dots(scrollPosition: scrollPosition)