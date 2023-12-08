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
    cart.customerId = null;
    cart.promotionCode = null;
    cart.voucherCode = null;
  }

  Future getListPromotion() async {
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
    if (code.contains('-')) {
      List<String> parts = code.split("-");
      cart.promotionCode = parts[0];
      cart.voucherCode = parts[1];
    } else {
      cart.promotionCode = code;
      cart.voucherCode = null;
    }
    await prepareOrder();
    notifyListeners();
  }

  List<PaymentProvider?> getListPayment() {
    List<PaymentProvider?> listPayment = [];
    listPayment = Get.find<OrderViewModel>().listPayment;
    return listPayment;
  }

  Future<void> prepareOrder() async {
    showLoadingDialog();
    cart.orderType = Get.find<OrderViewModel>().deliveryType;
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
      return;
    }
    Account? userInfo = await getUserInfo();
    await api.prepareOrder(cart, userInfo!.storeId).then((value) => {
          cart = value,
        });
    hideDialog();
  }

  Future<void> createOrder() async {
    bool res = false;
    Get.find<OrderViewModel>().placeOrder(cart).then((value) => {
          res = value,
          if (res == true) {clearCartData()}
        });
  }
}
