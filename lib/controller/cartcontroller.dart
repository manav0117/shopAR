import 'package:e_com/model/cart_model.dart';
import 'package:e_com/model/product_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CartController extends GetxController {
  var _products = {}.obs;
  // List<CartModel> data=products.obs.entries.map((entry)=>CartModel(name: entry.key.toString(), quantity:entry.value)).toList();
  void save() async {
    //  print(myList()[0]['name']);
    // SharedPreferences sp = await SharedPreferences.getInstance();
    // sp.setStringList(_auth.currentUser!.uid.toString(), myList());
    // sp.getStringList(_auth.currentUser!.uid)!.length;
    cartCollection.add(products);
  }

  myList() => _products.entries.map((e) => e.value).toList();
  get count => _products.length;
  final CollectionReference cartCollection =
      FirebaseFirestore.instance.collection('cartData');
  FirebaseAuth _auth = FirebaseAuth.instance;

  void addProduct(Product product) {
    if (_products.containsKey(product)) {
      _products[product] += 1;
      print(_products);
      //cartCollection.doc(_auth.currentUser!.uid).set(_products);
    } else {
      _products[product] = 1;
      print(_products);
      //  cartCollection.doc(_auth.currentUser!.uid).set(_products);
      Get.snackbar("Product Added", "You have added ${product.name} into cart",
          snackPosition: SnackPosition.BOTTOM, duration: Duration(seconds: 1));
    }
  }

  get products => _products;
  void removeProduct(Product product) {
    if (_products.containsKey(product) && _products[product] == 1) {
      _products.removeWhere((key, value) => key == product);
      print(_products);
      //    cartCollection.doc(_auth.currentUser!.uid).set(_products);
      Get.snackbar(
          "Product Removed", "You have removed ${product.name} from cart",
          snackPosition: SnackPosition.BOTTOM, duration: Duration(seconds: 1));
    } else {
      _products[product] -= 1;
      print(_products);
      //   cartCollection.doc(_auth.currentUser!.uid).set(_products);
    }
  }

  get productSubTotal => _products.entries
      .map((product) => product.key.prices * product.value)
      .toList();
  get total => _products.entries
      .map((product) => product.key.price * product.value)
      .toList()
      .reduce((value, element) => value + element)
      .toString();
}
