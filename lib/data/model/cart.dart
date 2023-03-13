import 'package:pos_apps/data/model/index.dart';

class Cart {
  List<CartItem> items;
  String payment;
  num totalAmount;
  num discountAmount;
  num finalAmount;

  Cart(
    this.items,
    this.payment,
    this.totalAmount,
    this.discountAmount,
    this.finalAmount,
  );
}

class CartItem {
  Product product;
  int quantity = 0;
  String? note;
  List<Product>? extras;
  num totalAmount = 0;

  CartItem(this.product, this.quantity, this.totalAmount,
      {this.note, this.extras});
}
