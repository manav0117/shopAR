import 'package:e_com/model/product_model.dart';
import 'package:get/get.dart';

class WishController extends GetxController {
  var _wish = {}.obs;
  void addProducttoWishList(Product product) {
    if (!_wish.containsKey(product)) {
      _wish[product] = 1;
    }
    Get.snackbar("Product Added", "You have added ${product.name} into cart",
        snackPosition: SnackPosition.BOTTOM, duration: Duration(seconds: 2));
  }

  get wishlist => _wish;
  void removeProductFromWishList(Product product) {
    if (_wish.containsKey(product) && _wish[product] == 1) {
      _wish.removeWhere((key, value) => key == product);
    }
  }
}
