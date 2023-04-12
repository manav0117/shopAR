import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_com/constants.dart';
import 'package:e_com/pages/home_page.dart';
import 'package:e_com/pages/main_screen.dart';
import 'package:e_com/screens/product_detail_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({
    super.key,
  });

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<Map<String, dynamic>> searchList = [];
  Future<QuerySnapshot>? prodList;
  String? name;
  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    String searchData = ' ';
    void searchFromFirestore(String data) async {
      prodList = FirebaseFirestore.instance
          .collection('products')
          .where("name", isGreaterThanOrEqualTo: data.toString())
          .get();
      setState(() {
        prodList;
      });
    }

    TextEditingController controller = TextEditingController();

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: kPrimaryColor,
          leading: IconButton(
              onPressed: () {
                Navigator.pushNamed(context, MainScreen.id);
              },
              icon: Icon(Icons.arrow_back)),
          title: TextField(
            //readOnly: true,
            decoration: InputDecoration(
                hintText: "Search here",
                suffixIcon: IconButton(
                    onPressed: () {
                      searchFromFirestore(searchData);
                    },
                    icon: Icon(Icons.search))),
            onChanged: (value) {
              setState(() {
                searchData = value.toString();
                name = searchData;
              });
            },
          ),
        ),
        body: FutureBuilder(
          future: prodList,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data!.size,
                  itemBuilder: (context, index) {
                    //print();
                    print(name);
                    String searchName = snapshot.data!.docs[index]['name']
                        .toString()
                        .toLowerCase();
                    return !searchName.contains(name.toString().toLowerCase())
                        ? Container()
                        : GridView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: 1,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 12,
                                    mainAxisExtent: 250,
                                    mainAxisSpacing: 12),
                            itemBuilder: (context, sindex) {
                              final DocumentSnapshot prods =
                                  snapshot.data!.docs[index];
                              String desc = snapshot.data!.docs[index]['desc'];
                              String name = snapshot.data!.docs[index]['name'];
                              String img =
                                  snapshot.data!.docs[index]['imageUrl'];
                              int price = snapshot.data!.docs[index]['price'];

                              print(prods.id);
                              return InkWell(
                                onTap: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: ((context) {
                                    return ProductDetail(
                                      name: name,
                                      desc: desc,
                                      img: img,
                                      price: price,
                                    );
                                  })));
                                },
                                child: Container(
                                    height: 120,
                                    margin: EdgeInsets.only(
                                        left: kDefaultPadding,
                                        top: kDefaultPadding / 2,
                                        bottom: kDefaultPadding * 0.27),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                              offset: Offset(0, 10),
                                              blurRadius: 50,
                                              color: kPrimaryColor
                                                  .withOpacity(0.23))
                                        ],
                                        //border: Border.all(color: Colors.black, width: 1.2),
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    child: Column(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(16),
                                              topRight: Radius.circular(16)),
                                          child: Image.network(
                                            snapshot.data!.docs[index]
                                                ['imageUrl'],
                                            height: 170,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            fit: BoxFit.cover,
                                            filterQuality: FilterQuality.high,
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(8),
                                          child: Column(
                                            children: [
                                              RichText(
                                                  text: TextSpan(
                                                text: snapshot.data!.docs[index]
                                                    ['name'],
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .button,
                                              )),
                                              const SizedBox(
                                                height: 8,
                                              ),
                                              Text(
                                                  snapshot.data!
                                                      .docs[index]['price']
                                                      .toString(),
                                                  style: TextStyle(
                                                      color: kPrimaryColor
                                                          .withOpacity(0.5))),
                                            ],
                                          ),
                                        )
                                      ],
                                    )),
                              );
                            });
                  });
            }
            return Center(
              child: Container(
                height: MediaQuery.of(context).size.height,
                child: Image.asset("assets/images/no result.jpg"),
              ),
            );
          },
        )

        // return Container(
        //   height: 100,
        //   child: Text("Empty"),
        // );
        );
  }
}
