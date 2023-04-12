// import 'package:e_com/controller/cartcontroller.dart';
// import 'package:e_com/controller/wishlist_controller.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// import '../model/product_model.dart';

// class WishlistPage extends StatelessWidget {
//   final CartController controller = Get.put(CartController());
//   WishlistPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: SingleChildScrollView(
//       child: WishPage(),
//     ));
//   }
// }

// class WishPage extends StatelessWidget {
//   final CartController controller = Get.put(CartController());
//   final WishController wishController = Get.put(WishController());
//   WishPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Obx(
//       () => SizedBox(
//         height: 400,
//         child: ListView.builder(
//             shrinkWrap: true,
//             itemCount: wishController.wishlist.length,
//             itemBuilder: (context, index) {
//               return WishProductCard(
//                 controller: wishController,
//                 product: wishController.wishlist.keys.toList()[index],
//                 index: index,
//               );
//             }),
//       ),
//     );
//   }
// }

// class WishProductCard extends StatelessWidget {
//   final WishController controller;
//   final Product product;

//   final int index;
//   const WishProductCard(
//       {super.key,
//       required this.controller,
//       required this.product,
//       required this.index});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 20),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           CircleAvatar(
//             radius: 40,
//             backgroundImage: NetworkImage(product.img.toString()),
//           ),
//           SizedBox(
//             width: 20,
//           ),
//           Text(product.name.toString()),
//           IconButton(
//               onPressed: () {
//                 controller.removeProductFromWishList(product);
//               },
//               icon: Icon(Icons.remove_circle)),
//         ],
//       ),
//     );
//   }
// }
