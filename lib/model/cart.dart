import 'package:pos_apps/model/index.dart';

class Cart {
  List<CartItem> items;
  String payment;
  double totalAmount;
  double discountAmount;
  double finalAmount;

  Cart(
    this.items,
    this.payment,
    this.totalAmount,
    this.discountAmount,
    this.finalAmount,
  );

  void addItem(CartItem item) {
    for (CartItem cart in items) {
      if (item.product.id == cart.product.id) {
        cart.quantity += item.quantity;
        return;
      }
    }
    items.add(item);
  }

  void removeItem(CartItem item) {
    print("Quantity: ${item.quantity}");
    items.removeWhere((element) =>
        (element.product.id == item.product.id) &&
        (element.quantity == item.quantity));
  }

  void updateQuantity(CartItem item) {
    for (CartItem cart in items) {
      if (cart.product.id == item.product.id) {
        print("Found item");
        cart.quantity = item.quantity;
      }
    }
  }
}

class CartItem {
  Product product;
  int quantity = 0;
  String? note;
  List<Product>? extras;
  int totalAmount = 0;

  CartItem(this.product, this.quantity, this.totalAmount,
      {this.note, this.extras});
}
