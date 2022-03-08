import 'package:flutter/cupertino.dart';

class InCartGetModel {
  late bool status;
  String? message;
  late InCartData data;

  InCartGetModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = InCartData.fromJson(json['data']);
  }
}

class InCartData {
  List<CartItemsData> cartItems = [];
  late dynamic subTotal;
  late dynamic total;

  InCartData.fromJson(Map<String, dynamic> json) {
    json['cart_items'].forEach((e) {
      cartItems.add(CartItemsData.fromJson(e));
    });

    subTotal = json['sub_total'];
    total = json['total'];
  }
}

class CartItemsData {
  late int id;
  late int quantity;
  late ProductData product;

  CartItemsData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    quantity = json['quantity'];
    product = ProductData.fromJson(json['product']);
  }
}

class ProductData {
  late int id;
  late dynamic price;
  late dynamic oldPrice;
  late dynamic discount;
  late String image;
  late String name;

  ProductData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    price = json['price'];
    oldPrice = json['old_price'];
    discount = json['discount'];
    image = json['image'];
    name = json['name'];
  }
}
