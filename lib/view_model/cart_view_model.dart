import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:pos_apps/data/api/index.dart';
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
  }

  void getListPromotion() async {
    try {
      setState(ViewStatus.Loading);
      promotions = await promotionData?.getListPromotionOfStore();

      setState(ViewStatus.Completed);
    } catch (e) {
      setState(ViewStatus.Error, e.toString());
    }
  }

  void scanCustomer(String phone) async {
    try {
      setState(ViewStatus.Loading);
      customer = await accountData.scanCustomer(phone);
      prepareOrder();
      setState(ViewStatus.Completed);
    } catch (e) {
      setState(ViewStatus.Error, e.toString());
    }
  }

  void addToCart(ProductList cartModel) {
    cart.productList!.add(cartModel);
    countCartAmount();
    countCartQuantity();
    prepareOrder();
  }

  void updateCart(ProductList cartModel, int cartIndex) {
    cart.productList![cartIndex] = cartModel;
    countCartAmount();
    countCartQuantity();
    prepareOrder();
  }

  void countCartAmount() {
    cart.totalAmount = 0;
    cart.discountAmount = 0;
    for (ProductList item in cart.productList!) {
      cart.totalAmount = cart.totalAmount! + item.totalAmount!;
    }
    cart.finalAmount = cart.totalAmount! - cart.discountAmount!;
    notifyListeners();
  }

  countCartQuantity() {
    num quantity = 0;
    for (ProductList item in cart.productList!) {
      quantity = quantity + item.quantity!;
    }
    return quantity;
  }

  void removeFromCart(int idx) {
    cart.productList!.remove(cart.productList![idx]);
    countCartAmount();
    prepareOrder();
  }

  void removeCustomer() {
    customer = null;
    prepareOrder();
  }

  bool isPromotionApplied(String code) {
    return cart.promotionCode == code;
  }

  void clearCartData() {
    cart.productList = [];
    cart.finalAmount = 0;
    cart.totalAmount = 0;
    cart.discountAmount = 0;
    cart.promotionList = [];
    notifyListeners();
  }

  bool isPromotionExist(String code) {
    return cart.promotionCode == code;
  }

  void removePromotion() {
    cart.promotionCode = null;
    cart.voucherCode = null;
    prepareOrder();
  }

  void selectPromotion(String code) {
    cart.promotionCode = code;
    cart.voucherCode = null;
    prepareOrder();
  }

  void removeVoucher() {
    cart.voucherCode = null;
    cart.promotionCode = null;
    prepareOrder();
  }

  Future<void> selectVoucher(String code) async {
    if (code.contains('-')) {
      List<String> parts = code.split("-");
      cart.promotionCode = parts[0];
      cart.voucherCode = parts[1];
    } else {
      cart.promotionCode = code;
      cart.voucherCode = null;
    }
    prepareOrder();
  }

  List<PaymentProvider?> getListPayment() {
    List<PaymentProvider?> listPayment = [];
    listPayment = Get.find<OrderViewModel>().listPayment;
    return listPayment;
  }

  Future<bool> prepareOrder() async {
    cart.orderType = Get.find<OrderViewModel>().deliveryType;
    cart.paymentType = Get.find<OrderViewModel>().selectedPaymentMethod!.type!;
    cart.customerId = customer?.id;
    cart.customerName = customer?.fullName;
    cart.discountAmount = 0;
    cart.bonusPoint = 0;
    cart.finalAmount = cart.totalAmount;
    for (var element in cart.productList!) {
      element.discount = 0;
      element.finalAmount = element.totalAmount;
      element.promotionCodeApplied = null;
    }
    cart.promotionList!.clear();
    if (kDebugMode) {
      print(cart.voucherCode);
    }
    Account? userInfo = await getUserInfo();
    await api.prepareOrder(cart, userInfo!.storeId).then((value) => {
          cart = value,
        });
    notifyListeners();
    // Get.snackbar("Kiểm tra giỏ hàng", cart.message ?? '',
    //     duration: Duration(milliseconds: 1500));

    return true;
  }

  Future<void> createOrder() async {
    bool res = false;
    Get.find<OrderViewModel>().placeOrder(cart).then((value) => {
          res = value,
          if (res == true) {clearCartData()}
        });
  }
}
