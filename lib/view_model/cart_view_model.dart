import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:pos_apps/data/api/index.dart';
import 'package:pos_apps/data/api/pointify/pointify_data.dart';
import 'package:pos_apps/data/model/cart_model.dart';
import 'package:pos_apps/data/model/customer.dart';
import 'package:pos_apps/data/model/response/payment_provider.dart';
import 'package:pos_apps/enums/index.dart';
import 'package:pos_apps/views/widgets/other_dialogs/dialog.dart';
import '../data/api/order_api.dart';
import '../data/api/promotion_data.dart';
import '../data/model/index.dart';
import '../data/model/pointify/promotion_model.dart';
import '../util/share_pref.dart';
import 'index.dart';

class CartViewModel extends BaseViewModel {
  CartModel cart = CartModel();
  int? peopleNumber;
  late OrderAPI api = OrderAPI();
  PointifyData pointifyData = PointifyData();
  PromotionData? promotionData = PromotionData();
  AccountData accountData = AccountData();
  List<PromotionPointify>? promotions = [];
  CustomerInfoModel? customer;

  CartViewModel() {
    cart.productList = [];
    cart.promotionList = [];
    cart.paymentType = PaymentTypeEnums.CASH;
    cart.totalAmount = 0;
    cart.finalAmount = 0;
    cart.bonusPoint = 0;
    cart.shippingFee = 0;
    cart.customerId = null;
    cart.promotionCode = null;
    cart.voucherCode = null;
    cart.orderType = DeliType().eatIn.type;
    cart.customerNumber = 1;
  }

  Future getListPromotion() async {
    try {
      promotions = await pointifyData.getListPromotionOfStore();
    } catch (e) {
      setState(ViewStatus.Error, e.toString());
    }
  }

  Future scanCustomer(String phone) async {
    try {
      setState(ViewStatus.Loading);
      customer = await accountData.scanCustomer(phone);
      await prepareOrder();
      notifyListeners();
      setState(ViewStatus.Completed);
    } catch (e) {
      setState(ViewStatus.Error, e.toString());
    }
  }

  Future<void> addToCart(ProductList cartModel) async {
    cart.productList!.add(cartModel);
    countCartAmount();
    countCartQuantity();
    await prepareOrder();
    notifyListeners();
  }

  Future<void> updateCart(ProductList cartModel, int cartIndex) async {
    cart.productList![cartIndex] = cartModel;
    countCartAmount();
    countCartQuantity();
    await prepareOrder();
    notifyListeners();
  }

  void countCartAmount() {
    cart.totalAmount = 0;
    cart.discountAmount = 0;
    for (ProductList item in cart.productList!) {
      cart.totalAmount = cart.totalAmount! + item.totalAmount!;
    }
    cart.finalAmount = cart.totalAmount! - cart.discountAmount!;
  }

  countCartQuantity() {
    num quantity = 0;
    for (ProductList item in cart.productList!) {
      quantity = quantity + item.quantity!;
    }
    return quantity;
  }

  Future<void> removeFromCart(int idx) async {
    cart.productList!.remove(cart.productList![idx]);
    countCartAmount();
    await prepareOrder();
    notifyListeners();
  }

  Future<void> removeCustomer() async {
    customer = null;
    await prepareOrder();
    notifyListeners();
  }

  bool isPromotionApplied(String code) {
    return cart.promotionCode == code;
  }

  void clearCartData() {
    customer = null;
    cart.paymentType = PaymentTypeEnums.CASH;
    cart.orderType = DeliType().eatIn.type;
    cart.customerNumber = 1;
    cart.productList = [];
    cart.finalAmount = 0;
    cart.totalAmount = 0;
    cart.discountAmount = 0;
    cart.promotionList = [];
    cart.voucherCode = null;
    cart.promotionCode = null;
    cart.bonusPoint = 0;
    cart.shippingFee = 0;
    cart.customerId = null;
    cart.customerName = null;
    notifyListeners();
  }

  bool isPromotionExist(String code) {
    return cart.promotionCode == code;
  }

  Future<void> removePromotion() async {
    cart.promotionCode = null;
    cart.voucherCode = null;
    await prepareOrder();
    notifyListeners();
  }

  Future<void> selectPromotion(String code) async {
    cart.promotionCode = code;
    cart.voucherCode = null;
    await prepareOrder();
    notifyListeners();
  }

  Future<void> removeVoucher() async {
    cart.voucherCode = null;
    cart.promotionCode = null;
    await prepareOrder();
    notifyListeners();
  }

  Future<void> selectVoucher(String code) async {
    String? phoneNumber;
    if (code.contains('_')) {
      List<String> parts = code.split("_");
      if (parts.length > 2) {
        phoneNumber = parts[0];
        cart.promotionCode = parts[1];
        cart.voucherCode = parts[2];
      } else {
        phoneNumber = parts[0];
        cart.promotionCode = parts[1];
        cart.voucherCode = null;
      }
    }
    if (phoneNumber != null) {
      await scanCustomer(phoneNumber);
    }
    await prepareOrder();
    notifyListeners();
  }

  List<PaymentProvider?> getListPayment() {
    List<PaymentProvider?> listPayment = [];
    listPayment = Get.find<OrderViewModel>().listPayment;
    return listPayment;
  }

  void chooseOrderType(String type) {
    cart.orderType = type;
    hideDialog();
    notifyListeners();
  }

  void chooseTable(num table) {
    cart.customerNumber = table;
    hideDialog();
    notifyListeners();
  }

  void setCartNote(String note) {
    cart.notes = note;
    notifyListeners();
  }

  Future<void> prepareOrder() async {
    cart.paymentType = Get.find<OrderViewModel>().selectedPaymentMethod!.type!;
    cart.discountAmount = 0;
    cart.bonusPoint = 0;
    cart.customerId = customer?.id;
    cart.customerName = customer?.fullName;
    cart.finalAmount = cart.totalAmount;
    for (var element in cart.productList!) {
      element.discount = 0;
      element.finalAmount = element.totalAmount;
      element.promotionCodeApplied = null;
    }
    cart.promotionList!.clear();
    if (cart.promotionCode == null &&
        cart.voucherCode == null &&
        cart.customerId == null) {
      hideDialog();
      return;
    }
    Account? userInfo = await getUserInfo();
    await api.prepareOrder(cart, userInfo!.storeId ?? '').then((value) => {
          cart = value,
        });
    hideDialog();
  }

  Future<void> createOrder() async {
    bool res = false;
    for (var item in cart.productList!) {
      if (item.attributes != null) {
        for (var attribute in item.attributes!) {
          item.note = (attribute.value != null && attribute.value!.isNotEmpty)
              ? "${attribute.name} ${attribute.value}, ${item.note}"
              : item.note;
        }
      }
    }
    await Get.find<OrderViewModel>().placeOrder(cart).then((value) => {
          res = value,
          if (res == true) {clearCartData()}
        });
  }
}
