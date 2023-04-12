import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_com/constants.dart';
import 'package:e_com/controller/cartcontroller.dart';
import 'package:e_com/controller/wishlist_controller.dart';
import 'package:e_com/model/product_model.dart';
import 'package:e_com/widget/ar_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductDetail extends StatefulWidget {
  final String name;
  final String desc;
  final String img;
  final int price;
  ProductDetail(
      {super.key,
      required this.name,
      required this.desc,
      required this.img,
      required this.price});

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  final CollectionReference products =
      FirebaseFirestore.instance.collection('products');
  bool wishAdded = false;
  final cartController = Get.put(CartController());
  final WishController wishController = Get.put(WishController());

  //logic for cart and add to cart
  bool isInCart = false;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        title: Text(widget.name),
        backgroundColor: kPrimaryColor,
      ),
      body: Column(
        children: [
          SizedBox(
            height: 30,
          ),
          Stack(children: [
            Container(
              margin: EdgeInsets.all(5),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.40,
              child: Image.network(
                widget.img,
                fit: BoxFit.cover,
              ),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20))),
            ),
          ]),
          Container(
              margin: EdgeInsets.all(5),
              child: Text(
                widget.desc.toString(),
                style: TextStyle(
                    fontSize: 14, letterSpacing: 1.5, wordSpacing: 1.8),
              )),
          Container(
              margin: EdgeInsets.all(5),
              child: Text(
                "₹ " + widget.price.toString(),
                style:
                    TextStyle(fontSize: 14, letterSpacing: 1.5, wordSpacing: 1),
              )),
          Container(
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Positioned(
                  width: size.width * 0.5,
                  bottom: 0,
                  child: isInCart
                      ? Container()
                      : ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(kPrimaryColor)),
                          onPressed: () {
                            cartController.addProduct(Product(
                                name: widget.name,
                                desc: widget.desc,
                                img: widget.img,
                                price: widget.price));
                          },
                          child: Text("Add to cart")),
                ),
                SizedBox(
                  width: 20,
                ),
                Positioned(
                    width: size.width * 0.5,
                    child: ElevatedButton(
                      child: Text("Try AR"),
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(kPrimaryColor)),
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: ((context) {
                          return AugmentedReality(
                            img: widget.img,
                          );
                        })));
                      },
                    ))
              ],
            ),
          )
        ],
      ),
    );
  }
}
// }
//  Positioned(
//                 bottom: 2,
//                 right: 5,
//                 child: ElevatedButton(
//                   child: Text("Try AR"),
//                   onPressed: () {
//                     Navigator.push(context,
//                         MaterialPageRoute(builder: ((context) {
//                       return AugmentedReality(
//                         img: widget.img,
//                       );
//                     })));
//                   },
//                 ))