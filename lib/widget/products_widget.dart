import 'package:e_com/constants.dart';
import 'package:e_com/pages/search_page.dart';
import 'package:e_com/screens/product_detail_screen.dart';
import 'package:e_com/widget/banner_widget.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductWidget extends StatefulWidget {
  const ProductWidget({super.key});

  @override
  State<ProductWidget> createState() => _ProductWidgetState();
}

class _ProductWidgetState extends State<ProductWidget> {
  CollectionReference products =
      FirebaseFirestore.instance.collection('products');
  TextEditingController controller = TextEditingController();
  void searchFromFirebase(String query) async {
    final result = await FirebaseFirestore.instance
        .collection('products')
        .where('name', isEqualTo: query)
        .get();
    setState(() {
      searchResult = result.docs.map((e) => e.data()).toList();
      print(searchResult[0]['name']);
    });
  }

  List searchResult = [];
  bool searchIsOn = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        Container(
          height: size.height * 0.08,
          child: Stack(children: <Widget>[
            Container(
              // child: Text(
              //   "ShopAR",
              //   style: Theme.of(context).textTheme.headline5!.copyWith(
              //       color: Colors.white, fontWeight: FontWeight.bold),
              // ),
              height: size.height * 0.1 - 27,
              decoration: BoxDecoration(
                  color: kPrimaryColor,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(36),
                      bottomRight: Radius.circular(36))),
            ),

            // onTapCancel: () {
            //   setState(() {
            //     searchIsOn = false;
            //   });
            // },
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                child: InkWell(
                    onTap: () {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) {
                        return SearchScreen();
                      }));
                    },
                    child: Text(
                      "Search",
                      style: TextStyle(color: kPrimaryColor),
                    )
                    // child: TextField(
                    //   decoration: InputDecoration(
                    //     enabledBorder: InputBorder.none,
                    //     focusedBorder: InputBorder.none,
                    //     hintText: "Search",
                    //     hintStyle:
                    //         TextStyle(color: kPrimaryColor.withOpacity(0.5)),
                    //   ),
                    // ),
                    ),
                height: 54,
                margin: EdgeInsets.symmetric(horizontal: kDefaultPadding),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                          offset: Offset(0, 10),
                          blurRadius: 50,
                          color: kPrimaryColor.withOpacity(0.23))
                    ]),
              ),
            ),
          ]),
        ),
        //SearchWidget(),
        SizedBox(
          height: 20,
        ),
        BannerWidget(),
        SizedBox(
          height: 20,
        ),
        Text(
          "RECOMMENDED",
          style: TextStyle(
              color: kPrimaryColor.withOpacity(0.34),
              fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 20,
        ),
        // searchIsOn
        //     ? GridView.builder(
        //         physics: const NeverScrollableScrollPhysics(),
        //         shrinkWrap: true,
        //         itemCount: searchResult.length,
        //         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        //             crossAxisCount: 2,
        //             crossAxisSpacing: 12,
        //             mainAxisExtent: 250,
        //             mainAxisSpacing: 12),
        //         itemBuilder: (context, index) {
        //           // final DocumentSnapshot prods =
        //           //     snapshot.data!.docs[index];
        //           // String desc = prods['desc'];
        //           // String name = prods['name'];
        //           // String img = prods['imageUrl'];
        //           // int price = prods['price'];

        //           //print(prods.id);
        //           return InkWell(
        //             onTap: () {
        //               Navigator.push(context,
        //                   MaterialPageRoute(builder: ((context) {
        //                 return ProductDetail(
        //                   name: searchResult[index]['name'],
        //                   desc: searchResult[index]['desc'],
        //                   img: searchResult[index]['imageUrl'],
        //                   price: searchResult[index]['price'],
        //                 );
        //               })));
        //             },
        //             child: Container(
        //                 height: 120,
        //                 margin: EdgeInsets.only(
        //                     left: kDefaultPadding,
        //                     top: kDefaultPadding / 2,
        //                     bottom: kDefaultPadding * 0.27),
        //                 decoration: BoxDecoration(
        //                     color: Colors.white,
        //                     boxShadow: [
        //                       BoxShadow(
        //                           offset: Offset(0, 10),
        //                           blurRadius: 50,
        //                           color: kPrimaryColor.withOpacity(0.23))
        //                     ],
        //                     //border: Border.all(color: Colors.black, width: 1.2),
        //                     borderRadius: BorderRadius.circular(12)),
        //                 child: Column(
        //                   children: [
        //                     ClipRRect(
        //                       borderRadius: BorderRadius.only(
        //                           topLeft: Radius.circular(16),
        //                           topRight: Radius.circular(16)),
        //                       child: Image.network(
        //                         searchResult[index]['imageUrl'],
        //                         height: 170,
        //                         width: MediaQuery.of(context).size.width,
        //                         fit: BoxFit.cover,
        //                         filterQuality: FilterQuality.high,
        //                       ),
        //                     ),
        //                     Padding(
        //                       padding: EdgeInsets.all(8),
        //                       child: Column(
        //                         children: [
        //                           RichText(
        //                               text: TextSpan(
        //                             text: searchResult[index]['name'],
        //                             style: Theme.of(context).textTheme.button,
        //                           )),
        //                           const SizedBox(
        //                             height: 8,
        //                           ),
        //                           Text(searchResult[index]['price'].toString(),
        //                               style: TextStyle(
        //                                   color:
        //                                       kPrimaryColor.withOpacity(0.5))),
        //                         ],
        //                       ),
        //                     )
        //                   ],
        //                 )),
        //           );
        //         }):
        StreamBuilder(
            stream: products.snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
                return GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: snapshot.data!.docs.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisExtent: 250,
                        mainAxisSpacing: 12),
                    itemBuilder: (context, index) {
                      final DocumentSnapshot prods = snapshot.data!.docs[index];
                      String desc = prods['desc'];
                      String name = prods['name'];
                      String img = prods['imageUrl'];
                      int price = prods['price'];

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
                                      color: kPrimaryColor.withOpacity(0.23))
                                ],
                                //border: Border.all(color: Colors.black, width: 1.2),
                                borderRadius: BorderRadius.circular(12)),
                            child: Column(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(16),
                                      topRight: Radius.circular(16)),
                                  child: Image.network(
                                    prods['imageUrl'],
                                    height: 170,
                                    width: MediaQuery.of(context).size.width,
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
                                        text: prods['name'],
                                        style:
                                            Theme.of(context).textTheme.button,
                                      )),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      Text(prods['price'].toString(),
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
              }
              return Text("...");
            }),
      ],
    );
  }
}
