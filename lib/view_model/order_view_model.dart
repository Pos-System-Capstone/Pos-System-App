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
import 'package:pos_apps/view_model/printer_view_model.dart';
import 'package:pos_apps/widgets/Dialogs/other_dialogs/dialog.dart';
import 'package:pos_apps/widgets/cart/choose_table_dialog.dart';

import '../Widgets/Dialogs/printer_dialogs/add_printer_dialog.dart';
import '../data/api/order_api.dart';
import '../data/api/payment_data.dart';
import '../data/model/index.dart';
import '../data/model/payment.dart';
import '../routes/routes_constrants.dart';

class OrderViewModel extends BaseViewModel {
  int selectedTable = 01;
  String deliveryType = DeliType.EAT_IN;
  Cart? currentCart;
  late OrderAPI api = OrderAPI();
  String? orderResponseId;
  OrderResponseModel? orderResponseModel;
  OrderStateEnum orderState = OrderStateEnum.ORDER_PRODUCT;
  List<PaymentModel?> listPayment = [];
  PaymentModel? selectedPaymentMethod;
  PaymentData? paymentData;

  OrderViewModel() {
    api = OrderAPI();
    paymentData = PaymentData();
  }

  void getListPayment() {
    paymentData!.getListPayment().then((value) {
      listPayment = value;
      selectedPaymentMethod = listPayment[0];
      print(listPayment);
      notifyListeners();
    });
  }

  void selectPayment(PaymentModel payment) {
    selectedPaymentMethod = payment;
    notifyListeners();
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

  Future<bool> placeOrder(OrderModel order) async {
    try {
      setState(ViewStatus.Loading);
      Account? userInfo = await getUserInfo();
      order.paymentId = listPayment[0]!.id;
      var res = await api.placeOrder(order, userInfo!.storeId);
      orderResponseId = res.toString();
      if (orderResponseId != null) {
        Get.toNamed(RouteHandler.PAYMENT);
      }
      setState(ViewStatus.Completed);
      return true;
      // getOrderByStore(userInfo.storeId, res.toString());
    } catch (e) {
      setState(ViewStatus.Error, e.toString());
      orderResponseId = null;
      return false;
    }
  }

  Future<void> getOrderByStore() async {
    try {
      setState(ViewStatus.Loading);
      if (orderResponseId == null) return;
      Account? userInfo = await getUserInfo();
      OrderResponseModel orderRes =
          await api.getOrderOfStore(userInfo!.storeId, orderResponseId!);
      if (orderRes != null) {
        orderResponseModel = orderRes;
        selectedPaymentMethod = listPayment
            .firstWhere((element) => element!.id == orderRes.payment!.id!);
      } else {
        orderResponseModel = null;
      }
      setState(ViewStatus.Completed);
    } catch (e) {
      showAlertDialog(title: "Lỗi đơn hàng", content: e.toString());
      setState(ViewStatus.Error);
    }
  }

  Future<void> updatePayment() async {
    try {
      Account? userInfo = await getUserInfo();
      setState(ViewStatus.Loading);
      var orderRes = await api.updateOrder(
          userInfo!.storeId,
          orderResponseModel!.orderId!,
          orderResponseModel?.orderStatus,
          selectedPaymentMethod?.id);
      orderResponseId = orderRes;
      if (orderResponseId != null) {
        getOrderByStore();
        showAlertDialog(
            title: "Cập nhật thanh toán",
            content: "Cập nhật thanh toán thành công");
      } else {
        orderResponseModel = null;
      }
      setState(ViewStatus.Completed);
    } catch (e, stacktrace) {
      showAlertDialog(
          title: "Lỗi cập nhật đơn hàng",
          content: e.toString() + stacktrace.toString());
      setState(ViewStatus.Error);
    }
  }

  Future<void> completeOrder(
    String orderId,
  ) async {
    try {
      Account? userInfo = await getUserInfo();
      setState(ViewStatus.Loading);

      if (Get.find<PrinterViewModel>().selectedBillPrinter != null) {
        Get.find<PrinterViewModel>().printBill(orderResponseModel!);
        setState(ViewStatus.Completed);
        clearOrder();
        Get.offAndToNamed(RouteHandler.HOME);
        showAlertDialog(
            title: "Hoàn thành đơn hàng",
            content: "Hoàn thành đơn hàng thành công");
      } else {
        bool result = await showConfirmDialog(
          title: "Lỗi in hóa đơn",
          content: "Vui lòng chọn máy in hóa đơn",
          confirmText: "Tiếp tục hoàn thành đơn hàng",
          cancelText: "Chọn máy in",
        );
        if (!result) {
          showInputIpDialog();
          setState(ViewStatus.Completed);
          return;
        } else {
          api.updateOrder(userInfo!.storeId, orderId, OrderStatusEnum.PAID,
              selectedPaymentMethod!.id);
          setState(ViewStatus.Completed);
          clearOrder();
          Get.offAndToNamed(RouteHandler.HOME);
          showAlertDialog(
              title: "Hoàn thành đơn hàng",
              content: "Hoàn thành đơn hàng thành công");
        }
      }
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
      api.updateOrder(userInfo!.storeId, orderId, OrderStatusEnum.CANCELED,
          orderResponseModel?.payment!.id!);
      clearOrder();
      Get.offAndToNamed(RouteHandler.HOME);
      showAlertDialog(
          title: "Huỷ đơn hàng", content: "Huỷ đơn hàng thành công");
      setState(ViewStatus.Completed);
    } catch (e) {
      showAlertDialog(title: "Lỗi huỷ đơn hàng", content: e.toString());
      setState(ViewStatus.Error);
    }
  }

  void clearOrder() {
    orderResponseId = null;
    orderResponseModel = null;
    notifyListeners();
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
