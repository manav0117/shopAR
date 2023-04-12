import 'dart:convert';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:e_com/constants.dart';
import 'package:e_com/controller/cartcontroller.dart';
import 'package:e_com/model/product_model.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartScreen extends StatelessWidget {
  final CartController controller = Get.put(CartController());
  CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [CartPage(), CartTotal(), PaymentScreen()],
        ),
      )),
    );
  }
}

class CartPage extends StatelessWidget {
  final CartController controller = Get.put(CartController());
  CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SizedBox(
        height: 400,
        child: ListView.builder(
            shrinkWrap: true,
            itemCount: controller.products.length,
            itemBuilder: (context, index) {
              return CartProductCard(
                controller: controller,
                product: controller.products.keys.toList()[index],
                quantity: controller.products.values.toList()[index],
                index: index,
              );
            }),
      ),
    );
  }
}

class CartProductCard extends StatelessWidget {
  final CartController controller;
  final Product product;
  final int quantity;
  final int index;
  const CartProductCard(
      {super.key,
      required this.controller,
      required this.product,
      required this.quantity,
      required this.index});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CircleAvatar(
            radius: 40,
            backgroundImage: NetworkImage(product.img.toString()),
          ),
          SizedBox(
            width: 20,
          ),
          Text(product.name.toString()),
          IconButton(
              onPressed: () {
                controller.removeProduct(product);
                controller.myList();
                controller.save();
              },
              icon: Icon(Icons.remove_circle)),
          Text('${quantity}'),
          IconButton(
              onPressed: () {
                controller.addProduct(product);
                controller.myList();
                controller.save();
              },
              icon: Icon(Icons.add_circle))
        ],
      ),
    );
  }
}

class CartTotal extends StatelessWidget {
  final CartController controller = Get.put(CartController());
  CartTotal({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Total ',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            controller.count == 0
                ? Text('0',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold))
                : Text(controller.total,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold))
          ],
        ),
      ),
    );
  }
}

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    CartController controller = Get.put(CartController());
    Map<String, dynamic>? paymentIntent;
    Future<void> makePayment(String amount, String currency) async {
      try {
        paymentIntent = await createPaymentIntent(amount, currency);
        if (paymentIntent != null) {
          await Stripe.instance.initPaymentSheet(
              paymentSheetParameters: SetupPaymentSheetParameters(
                  //  applePay: PaymentSheetApplePay(merchantCountryCode: 'IN'),
                  googlePay: PaymentSheetGooglePay(merchantCountryCode: 'IN'),
                  merchantDisplayName: 'Manav',
                  customerId: paymentIntent!['customer'],
                  paymentIntentClientSecret: paymentIntent!['client_secret'],
                  customerEphemeralKeySecret: paymentIntent!['emphemeralkey']));
          displayPaymentSheet();
        }
      } catch (e, s) {
        print("EXCEPTION===$e$s");
      }
    }

    return ElevatedButton(
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(kPrimaryColor)),
      onPressed: () {
        makePayment(controller.total, 'INR');
      },
      child: Text(
        "Pay Now  ",
      ),
    );
  }

  createPaymentIntent(String amount, String currency) async {
    CartController controller = Get.put(CartController());
    try {
      Map<String, dynamic> body = {
        'amount': calculateMoney(controller.total.toString()),
        'currency': currency,
        'payment_method_types[]': 'card'
      };
      var response = await http.post(
          Uri.parse("https://api.stripe.com/v1/payment_intents"),
          body: body,
          headers: {
            'Authorization': "Bearer $key",
            'Content-Type': 'application/x-www-form-urlencoded'
          });
      return jsonDecode(response.body);
    } catch (err) {
      print("err charging user $err");
    }
  }

  calculateMoney(String amount) {
    final a = (int.parse(amount) * 100);
    return a.toString();
  }

  void displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet();
      Get.snackbar("Payment info", "pay successfull");
    } on Exception catch (e) {
      if (e is StripeException) {
        print("Error from stripe $e");
      } else {
        print('Unforeseen error $e');
      }
    } catch (e) {
      print(" exception ===$e");
    }
  }
}
// class MakePayment extends StatefulWidget {
//   const MakePayment({super.key});

//   @override
//   State<MakePayment> createState() => _MakePaymentState();
// }

// class _MakePaymentState extends State<MakePayment> {
//   Map<String, dynamic>? paymentIntent;
//   CartController cartController = Get.put(CartController());
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: InkWell(
//           child: Text("Make payment"),
//           onTap: () async {
//             await makePayment();
//           }),
//     );
//   }

//   Future<void> makePayment() async {
//     try {
//       paymentIntent =
//           await createPaymentIntent(cartController.total.toString(), 'USD');
//       await Stripe.instance
//           .initPaymentSheet(
//               paymentSheetParameters: SetupPaymentSheetParameters(
//                   paymentIntentClientSecret: paymentIntent!['client_secret'],
//                   applePay:
//                       const PaymentSheetApplePay(merchantCountryCode: '+91'),
//                   googlePay: const PaymentSheetGooglePay(
//                       testEnv: true,
//                       currencyCode: 'IN',
//                       merchantCountryCode: '+91'),
//                   style: ThemeMode.light,
//                   merchantDisplayName: 'Manav'))
//           .then((value) {});
//       displayPaymentSheet();
//     } catch (e, s) {
//       print('Exception :$e,$s');
//     }
//   }

//   displayPaymentSheet() async {
//     try {
//       await Stripe.instance.presentPaymentSheet().then((value) {
//         showDialog(
//             context: context,
//             builder: (_) => AlertDialog(
//                   content: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Row(
//                         children: const [
//                           Icon(Icons.check_circle, color: Colors.green),
//                           Text('Payment Successfull')
//                         ],
//                       )
//                     ],
//                   ),
//                 ));
//         paymentIntent = null;
//       }).onError((error, stackTrac) {
//         print("Error is $error$stackTrac");
//       });
//     } on StripeException catch (e) {
//       showDialog(
//           context: context,
//           builder: (_) => AlertDialog(
//                 content: Text("Cancelled"),
//               ));
//     } catch (e) {
//       print('$e');
//     }
//   }

//   createPaymentIntent(String amount, String currency) async {
//     try {
//       Map<String, dynamic> body = {
//         'amount': amount,
//         'currency': currency,
//         'payment_method_types[]': 'card'
//       };
//       var response = await http.post(
//           Uri.parse('https://api.stripe.com/v1/payment_intents'),
//           body: body,
//           headers: {
//             'Authorization': 'Bearer $key',
//             'Content-Type': 'application/x-www-form-urlencoded'
//           });
//       return jsonDecode(response.body);
//     } catch (err) {
//       print(err.toString());
//     }
//   }
// }
