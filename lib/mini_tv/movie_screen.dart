import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_com/constants.dart';
import 'package:e_com/mini_tv/video_player_screen.dart';
import 'package:flutter/material.dart';

class MoviesScreen extends StatelessWidget {
  static String id = "movie-screen";
  const MoviesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final CollectionReference movies =
        FirebaseFirestore.instance.collection('movies');
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: Text("Movies"),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: movies.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final DocumentSnapshot documentSnapshot =
                      snapshot.data!.docs[index];

                  return InkWell(
                      onTap: () {
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) {
                          return VideoPlayerScreen(
                              data: snapshot.data!.docs[index]);
                        }));
                      },
                      child: Container(
                        height: 300,
                        width: MediaQuery.of(context).size.width * 1.0,
                        margin: EdgeInsets.only(
                            left: kDefaultPadding,
                            top: kDefaultPadding / 2,
                            bottom: kDefaultPadding * 0.05),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                  offset: Offset(0, 10),
                                  blurRadius: 50,
                                  color: kPrimaryColor.withOpacity(0.23))
                            ],
                            //border: Border.all(color: Colors.black, width: 1.2),
                            borderRadius: BorderRadius.circular(12)),
                        child: Column(
                          children: [
                            Image.network(
                              documentSnapshot['imageUrl'],
                              height: MediaQuery.of(context).size.height * 0.30,
                            ),
                            Text(
                              documentSnapshot['name'],
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                            SizedBox(
                              height: 20,
                            )
                          ],
                        ),
                      ));
                });
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Center(
              child: Text("No data"),
            );
          }
        },
      ),
    );
  }
}
