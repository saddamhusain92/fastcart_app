import 'package:flutter/material.dart';

class CartProvider with ChangeNotifier {
  List<Map<String, dynamic>> _cart = [];
  List<Map<String, dynamic>> _cartItems = [];
  List<Map<String, dynamic>> get cart => _cart;
  List<Map<String, dynamic>> get cartItems => _cartItems;

// add products in post data api database
// String productId, double price, String title
  void addProducts(
    int productId,
    int price,
    String title,
    String image,
  ) {
    final existingItemIndex =
        _cart.indexWhere((item) => item["id"] == productId);

    if (existingItemIndex != -1) {
      _cart[existingItemIndex] = {
        "id": _cart[existingItemIndex]["id"],
        "title": _cart[existingItemIndex]["title"],
        "quantity": _cart[existingItemIndex]["quantity"] + 1,
        "price": _cart[existingItemIndex]["price"],
        "image": _cart[existingItemIndex]["image"],
      };
      _cartItems[existingItemIndex] = {
        "product_id": _cartItems[existingItemIndex]["product_id"],
        "quantity": _cartItems[existingItemIndex]["quantity"] + 1,
      };
    } else {
      _cart.add({
        "id": productId,
        "title": title,
        "quantity": 1,
        "price": price,
        "image": image
      });
      _cartItems.add({
        "product_id": productId,
        "quantity": 1,
      });
    }
print(cart);
    notifyListeners();
  }

  double get totalAmount {
    var total = 0.0;
    return _cart.fold(0.0,
        (total, cartItem) => total + cartItem["price"] * cartItem["quantity"]);
  }

  void increaseQuantity(int productId) {
      for (var product in cart) {
    if (product['id'] == productId) {
      product['quantity'] = product["quantity"]+1;
      break;
    }
  }
      for (var product in cartItems) {
    if (product['product_id'] == productId) {
      product['quantity'] = product["quantity"]+1;
      break;
    }
  }
    notifyListeners();
  }

  void decreaseQuantity(int productId) {
        for (var product in cart) {
    if (product['id'] == productId && product['quantity']!=1 ) {
      product['quantity'] = product["quantity"]-1;
      break;
    }
  }
      for (var product in cartItems) {
    if (product['id'] == productId && product['quantity']!=1) {
      product['quantity'] = product["quantity"]-1;
      break;
    }
  }
    notifyListeners();
  }

  void clearCart() {
    _cart.clear();
    _cartItems.clear();
    notifyListeners();
  }
  bool checkCart(productId){
     final existingItemIndex =
        _cart.indexWhere((item) => item["id"] == productId);
        return existingItemIndex!= 1?false:true;
  }
}
