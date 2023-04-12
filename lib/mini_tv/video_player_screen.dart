// import 'dart:io';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:e_com/model/video_movie_model.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';

// class VideoPlayer extends StatefulWidget {
//   const VideoPlayer({super.key});
//   static const String id = 'video-screen';

//   @override
//   State<VideoPlayer> createState() => _VideoPlayerState();
// }

// class _VideoPlayerState extends State<VideoPlayer> {
//   PlatformFile? pickedImage;
//   PlatformFile? pickedVideo;
//   UploadTask? uploadTask1;
//   UploadTask? uploadTask2;
//   String name = "";
//   TextEditingController nameController = TextEditingController();
//   CollectionReference _movies = FirebaseFirestore.instance.collection('movies');
//   Future selectImage() async {
//     final result = await FilePicker.platform.pickFiles();
//     if (result == null) return;
//     setState(() {
//       pickedImage = result.files.first;
//     });
//   }

//   Future selectVideo() async {
//     final result = await FilePicker.platform.pickFiles();
//     if (result == null) return;
//     setState(() {
//       pickedVideo = result.files.first;
//     });
//   }

//   Future uploadFile() async {
//     final path1 = 'images/${pickedImage!.name}';
//     final file1 = File(pickedImage!.path!);
//     final path2 = 'videos/${pickedVideo!.name}';
//     final file2 = File(pickedVideo!.path!);
//     if (path1 == null || path2 == null) {
//       return;
//     }
//     final ref1 = FirebaseStorage.instance.ref().child(path1);
//     final ref2 = FirebaseStorage.instance.ref().child(path2);

//     uploadTask1 = ref1.putFile(file1);
//     uploadTask2 = ref2.putFile(file2);
//     final snapshot = await uploadTask1!.whenComplete(() {});
//     final snapshot2 = await uploadTask2!.whenComplete(() {});
//     final urlDownloadImage = await snapshot.ref.getDownloadURL(); // image url
//     final urlDownloadVideo = await snapshot.ref.getDownloadURL(); // video url

//     // add data to firestore

//     final Video video = Video(
//         name: name, imageUrl: urlDownloadImage, videoUrl: urlDownloadVideo);
//     final json = video.toJson();
//     _movies.add(json);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             if (pickedImage != null)
//               Expanded(
//                   child: Image.file(
//                 File(pickedImage!.path!),
//                 width: double.infinity,
//                 fit: BoxFit.cover,
//               )),
//             TextField(
//               controller: nameController,
//               onChanged: (value) {
//                 setState(() {
//                   name = nameController.text;
//                 });
//               },
//             ),
//             ElevatedButton(onPressed: selectImage, child: Text("Select Image")),
//             const SizedBox(
//               height: 30,
//             ),
//             ElevatedButton(onPressed: selectVideo, child: Text("Select Video")),
//             const SizedBox(
//               height: 30,
//             ),
//             ElevatedButton(onPressed: uploadFile, child: Text("Upload  File"))
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_com/constants.dart';
import 'package:e_com/widget/video_player_widget.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  final DocumentSnapshot data;
  static String id = 'video-screen';
  const VideoPlayerScreen({super.key, required this.data});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();

    // Create and store the VideoPlayerController. The VideoPlayerController
    // offers several different constructors to play videos from assets, files,
    // or the internet.
    _controller = VideoPlayerController.network(widget.data['videoUrl']);
    // Initialize the controller and store the Future for later use.
    _initializeVideoPlayerFuture = _controller.initialize();

    // Use the controller to loop the video.
    _controller.setLooping(true);
  }

  @override
  void dispose() {
    // Ensure disposing of the VideoPlayerController to free up resources.
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        title: Text(widget.data['name']),
        backgroundColor: kPrimaryColor,
      ),
      // Use a FutureBuilder to display a loading spinner while waiting for the
      // VideoPlayerController to finish initializing.
      body: FutureBuilder(
        future: _initializeVideoPlayerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the VideoPlayerController has finished initialization, use
            // the data it provides to limit the aspect ratio of the video.
            return AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              // Use the VideoPlayer widget to display the video.
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: <Widget>[
                  VideoPlayer(_controller),
                  _ControlsOverlay(controller: _controller),
                  VideoProgressIndicator(_controller, allowScrubbing: true),
                ],
              ),
            );
          } else {
            // If the VideoPlayerController is still initializing, show a
            // loading spinner.
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Wrap the play or pause in a call to `setState`. This ensures the
          // correct icon is shown.
          setState(() {
            // If the video is playing, pause it.
            if (_controller.value.isPlaying) {
              _controller.pause();
            } else {
              // If the video is paused, play it.
              _controller.play();
            }
          });
        },
        // Display the correct icon depending on the state of the player.
        child: Icon(
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ),
    );
  }
}

class _ControlsOverlay extends StatelessWidget {
  const _ControlsOverlay({required this.controller});

  static const List<Duration> _exampleCaptionOffsets = <Duration>[
    Duration(seconds: -10),
    Duration(seconds: -3),
    Duration(seconds: -1, milliseconds: -500),
    Duration(milliseconds: -250),
    Duration.zero,
    Duration(milliseconds: 250),
    Duration(seconds: 1, milliseconds: 500),
    Duration(seconds: 3),
    Duration(seconds: 10),
  ];
  static const List<double> _examplePlaybackRates = <double>[
    0.25,
    0.5,
    1.0,
    1.5,
    2.0,
    3.0,
    5.0,
    10.0,
  ];

  final VideoPlayerController controller;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 50),
          reverseDuration: const Duration(milliseconds: 200),
          child: controller.value.isPlaying
              ? const SizedBox.shrink()
              : Container(
                  color: Colors.black26,
                  child: const Center(
                    child: Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 100.0,
                      semanticLabel: 'Play',
                    ),
                  ),
                ),
        ),
        GestureDetector(
          onTap: () {
            controller.value.isPlaying ? controller.pause() : controller.play();
          },
        ),
        Align(
          alignment: Alignment.topLeft,
          child: PopupMenuButton<Duration>(
            initialValue: controller.value.captionOffset,
            tooltip: 'Caption Offset',
            onSelected: (Duration delay) {
              controller.setCaptionOffset(delay);
            },
            itemBuilder: (BuildContext context) {
              return <PopupMenuItem<Duration>>[
                for (final Duration offsetDuration in _exampleCaptionOffsets)
                  PopupMenuItem<Duration>(
                    value: offsetDuration,
                    child: Text('${offsetDuration.inMilliseconds}ms'),
                  )
              ];
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                // Using less vertical padding as the text is also longer
                // horizontally, so it feels like it would need more spacing
                // horizontally (matching the aspect ratio of the video).
                vertical: 12,
                horizontal: 16,
              ),
              child: Text('${controller.value.captionOffset.inMilliseconds}ms'),
            ),
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: PopupMenuButton<double>(
            initialValue: controller.value.playbackSpeed,
            tooltip: 'Playback speed',
            onSelected: (double speed) {
              controller.setPlaybackSpeed(speed);
            },
            itemBuilder: (BuildContext context) {
              return <PopupMenuItem<double>>[
                for (final double speed in _examplePlaybackRates)
                  PopupMenuItem<double>(
                    value: speed,
                    child: Text('${speed}x'),
                  )
              ];
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                // Using less vertical padding as the text is also longer
                // horizontally, so it feels like it would need more spacing
                // horizontally (matching the aspect ratio of the video).
                vertical: 12,
                horizontal: 16,
              ),
              child: Text('${controller.value.playbackSpeed}x'),
            ),
          ),
        ),
      ],
    );
  }
}



// final DocumentSnapshot data;
//  static String id = 'video-screen';
/*

class VideoScreen extends StatefulWidget {
  const VideoScreen({super.key, required this.data});

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  late VideoPlayerController controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = VideoPlayerController.network(widget.data['videoUrl'])
      ..addListener(() => setState(() {}))
      ..setLooping(true)
      ..initialize().then((_) => controller.play());
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMuted = controller.value.volume == 0;
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        title: Text(widget.data['name']),
        backgroundColor: kPrimaryColor,
      ),
      body: Column(
        children: [
          VideoPlayerWidget(controller: controller),
          const SizedBox(
            height: 32,
          ),
          if (controller != null && controller.value.isInitialized)
            CircleAvatar(
                radius: 30,
                child: IconButton(
                  onPressed: () => controller.setVolume(isMuted ? 1 : 0),
                  icon: Icon(
                    isMuted ? Icons.volume_mute : Icons.volume_up,
                    color: Colors.white,
                  ),
                ))
        ],
      ),
    );
  }*/