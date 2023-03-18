import 'dart:core';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_apps/data/model/response/order_response.dart';
import 'package:pos_apps/enums/index.dart';
import 'package:pos_apps/enums/order_enum.dart';
import 'package:pos_apps/routes/route_helper.dart';
import 'package:pos_apps/util/share_pref.dart';
import 'package:pos_apps/view_model/cart_view_model.dart';
import 'package:pos_apps/view_model/index.dart';
import 'package:pos_apps/widgets/Dialogs/other_dialogs/dialog.dart';
import 'package:pos_apps/widgets/cart/choose_table_dialog.dart';

import '../data/api/order_api.dart';
import '../data/model/index.dart';
import '../routes/routes_constrants.dart';

class OrderViewModel extends BaseViewModel {
  int selectedTable = 01;
  String deliveryType = DeliType.EAT_IN;
  Cart? currentCart;
  late OrderAPI api = OrderAPI();
  OrderResponseModel? orderResponseModel;
  OrderStateEnum orderState = OrderStateEnum.ORDER_PRODUCT;
  // List<Payment> paymentList = [
  //   Payment(
  //       id: "1",
  //       paymentTypeId: "1",
  //       paymentType: PaymentType.CASH,
  //       isSelected: false,
  //   Payment(
  //       paymentId: "2",
  //       paymentName: "Thẻ",
  //       paymentType: PaymentType.CARD,
  //       paymentStatus: PaymentStatus.PENDING),
  //   Payment(
  //       paymentId: "3",
  //       paymentName: "Momo",
  //       paymentType: PaymentType.MOMO,
  //       paymentStatus: PaymentStatus.PENDING),
  //   Payment(
  //       paymentId: "4",
  //       paymentName: "ZaloPay",
  //       paymentType: PaymentType.ZALOPAY,
  //       paymentStatus: PaymentStatus.PENDING),
  // ];

  OrderViewModel() {
    api = OrderAPI();
  }

  void chooseDeliveryType(String type) {
    deliveryType = type;
    hideDialog();

    notifyListeners();
  }

  void chooseTable(int table) {
    selectedTable = table;
    hideDialog();
    notifyListeners();
  }

  void changeState(OrderStateEnum state) {
    orderState = state;
    notifyListeners();
  }

  Future<void> placeOrder(OrderModel order) async {
    try {
      setState(ViewStatus.Loading);
      Account? userInfo = await getUserInfo();
      var res = await api.placeOrder(order, userInfo!.storeId);
      if (Get.isDialogOpen!) {
        Get.back();
      }
      setState(ViewStatus.Completed);
      getOrderByStore(userInfo.storeId, res.toString());
    } catch (e) {
      showAlertDialog(title: "Lỗi tạo đơn hàng", content: e.toString());
      setState(ViewStatus.Error, e.toString());
    }
  }

  Future<void> getOrderByStore(String storeId, String orderId) async {
    OrderResponseModel orderRes = await api.getOrderOfStore(storeId, orderId);
    print(orderRes.toString());
    if (orderRes != null) {
      orderResponseModel = orderRes;
      Get.toNamed(RouteHandler.PAYMENT);
    } else {
      orderResponseModel = null;
    }
    notifyListeners();
  }

  Future<void> updatePayment(
      String orderId, String status, String payment) async {
    try {
      Account? userInfo = await getUserInfo();
      setState(ViewStatus.Loading);
      print("update order");
      print(userInfo!.storeId);
      print(orderId);
      var res = api.updateOrder(userInfo!.storeId, orderId, status, payment);
      print(res.toString());
      getOrderByStore(userInfo.storeId, res.toString());
      showAlertDialog(
          title: "Cập nhật thanh toán",
          content: "Cập nhật thanh toán thành công");
      setState(ViewStatus.Completed);
    } catch (e) {
      showAlertDialog(title: "Lỗi cập nhật đơn hàng", content: e.toString());
      setState(ViewStatus.Error);
    }
  }

  Future<void> completeOrder(
    String orderId,
    String payment,
  ) async {
    try {
      Account? userInfo = await getUserInfo();
      setState(ViewStatus.Loading);
      print("update order");
      print(userInfo!.storeId);
      print(orderId);
      api.updateOrder(userInfo.storeId, orderId, OrderStatusEnum.PAID, payment);
      Get.offAndToNamed(RouteHandler.HOME);
      showAlertDialog(
          title: "Hoàn thành đơn hàng",
          content: "Hoàn thành đơn hàng thành công");

      setState(ViewStatus.Completed);
    } catch (e) {
      showAlertDialog(title: "Lỗi hoàn thành đơn hàng", content: e.toString());
      setState(ViewStatus.Error);
    }
  }

  Future<void> cancleOrder(
    String orderId,
    String payment,
  ) async {
    try {
      Account? userInfo = await getUserInfo();
      setState(ViewStatus.Loading);
      print("update order");
      print(userInfo!.storeId);
      print(orderId);
      api.updateOrder(
          userInfo.storeId, orderId, OrderStatusEnum.CANCELED, payment);
      Get.offAndToNamed(RouteHandler.HOME);
      showAlertDialog(
          title: "Huỷ đơn hàng", content: "Huỷ đơn hàng thành công");
      setState(ViewStatus.Completed);
    } catch (e) {
      showAlertDialog(title: "Lỗi huỷ đơn hàng", content: e.toString());
      setState(ViewStatus.Error);
    }
  }

  // void addProductToCart(Product product)  {
  //   List<ProductDTO> listChoices = [];
  //   if (master.type == ProductType.MASTER_PRODUCT) {
  //     Map choice = new Map();
  //     for (int i = 0; i < affectPriceContent.keys.toList().length; i++) {
  //       choice[affectPriceContent.keys.elementAt(i)] =
  //           selectedAttributes[affectPriceContent.keys.elementAt(i)];
  //     }

  //     ProductDTO dto = master.getChildByAttributes(choice);
  //     listChoices.add(dto);
  //   }

  //   if (this.extra != null) {
  //     for (int i = 0; i < extra.keys.length; i++) {
  //       if (extra[extra.keys.elementAt(i)]) {
  //         print(extra.keys.elementAt(i).type);
  //         listChoices.add(extra.keys.elementAt(i));
  //       }
  //     }
  //   }

  //   String description = "";
  //   CartItem item = new CartItem(master, listChoices, description, count);

  //   if (master.type == ProductType.GIFT_PRODUCT) {
  //     AccountViewModel account = Get.find<AccountViewModel>();
  //     if (account.currentUser == null) {
  //       await account.fetchUser();
  //     }

  //     double totalBean = account.currentUser.point;

  //     Cart cart = showOnHome ? await getCart() : await getMart();
  //     if (cart != null) {
  //       cart.items.forEach((element) {
  //         if (element.master.type == ProductType.GIFT_PRODUCT) {
  //           totalBean -= (element.master.price * element.quantity);
  //         }
  //       });
  //     }

  //     if (totalBean < (master.price * count)) {
  //       await showStatusDialog("assets/images/global_error.png",
  //           "Không đủ Bean", "Số bean hiện tại không đủ");
  //       return;
  //     }
  //   }

  //   print("Item: " + item.master.productInMenuId.toString());

  //   showOnHome ? await addItemToCart(item) : await addItemToMart(item);
  //   await AnalyticsService.getInstance()
  //       .logChangeCart(item.master, item.quantity, true);
  //   hideDialog();
  //   if (backToHome) {
  //     Get.find<OrderViewModel>().prepareOrder();
  //     Get.back(result: true);
  //   } else {
  //     Get.find<OrderViewModel>().prepareOrder();
  //   }
  // }
}
