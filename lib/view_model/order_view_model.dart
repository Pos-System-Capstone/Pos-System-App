import 'dart:core';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_apps/Widgets/Dialogs/other_dialogs/dialog.dart';
import 'package:pos_apps/Widgets/Dialogs/payment_dialogs/payment_dialog.dart';
import 'package:pos_apps/data/model/response/order_in_list.dart';
import 'package:pos_apps/data/model/response/order_response.dart';
import 'package:pos_apps/enums/index.dart';
import 'package:pos_apps/enums/order_enum.dart';
import 'package:pos_apps/routes/route_helper.dart';
import 'package:pos_apps/util/share_pref.dart';
import 'package:pos_apps/view_model/cart_view_model.dart';
import 'package:pos_apps/view_model/index.dart';
import 'package:pos_apps/view_model/login_view_model.dart';
import 'package:pos_apps/view_model/printer_view_model.dart';
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
  String? currentOrderId;
  OrderResponseModel? currentOrder;
  List<PaymentModel?> listPayment = [];
  PaymentModel? selectedPaymentMethod;
  PaymentData? paymentData;
  List<OrderInList> listOrder = [];

  OrderViewModel() {
    api = OrderAPI();
    paymentData = PaymentData();
  }

  void getListPayment() {
    setState(ViewStatus.Loading);
    paymentData!.getListPayment().then((value) {
      listPayment = value;
    });
    setState(ViewStatus.Completed);
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

  void placeOrder(OrderModel order) async {
    try {
      setState(ViewStatus.Loading);
      Account? userInfo = await getUserInfo();
      order.paymentId = listPayment[0]!.id;
      var res = api.placeOrder(order, userInfo!.storeId);

      res.then((value) =>
          {print(value.toString()), showPaymentBotomSheet(value.toString())});
      setState(ViewStatus.Completed);
    } catch (e) {
      setState(ViewStatus.Error, e.toString());
    }
  }

  void getListOrder() async {
    try {
      setState(ViewStatus.Loading);
      Account? userInfo = await getUserInfo();
      listOrder = await api.getListOrderOfStore(userInfo!.storeId);
      setState(ViewStatus.Completed);
    } catch (e) {
      setState(ViewStatus.Error, e.toString());
    }
  }

  void getOrderByStore(String orderId) async {
    try {
      setState(ViewStatus.Loading);
      Account? userInfo = await getUserInfo();
      // OrderResponseModel orderRes =
      //     await api.getOrderOfStore(userInfo!.storeId, orderId);
      api.getOrderOfStore(userInfo!.storeId, orderId).then((value) => {
            currentOrder = value,
            selectedPaymentMethod = currentOrder!.payment,
            setState(ViewStatus.Completed)
          });
    } catch (e) {
      showAlertDialog(title: "Lỗi đơn hàng", content: e.toString());
      setState(ViewStatus.Error);
    }
  }

  Future<void> updatePayment() async {
    try {
      Account? userInfo = await getUserInfo();
      setState(ViewStatus.Loading);
      api
          .updateOrder(userInfo!.storeId, currentOrder!.orderId!,
              currentOrder?.orderStatus, selectedPaymentMethod?.id)
          .then((value) => {
                currentOrderId = value,
              });
      if (currentOrderId != null) {
        showAlertDialog(
            title: "Cập nhật thanh toán",
            content: "Cập nhật thanh toán thành công");
        getOrderByStore(currentOrderId!);
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
        Get.find<PrinterViewModel>().printBill(currentOrder!);
        api.updateOrder(userInfo!.storeId, orderId, OrderStatusEnum.PAID,
            selectedPaymentMethod!.id);
        setState(ViewStatus.Completed);
        clearOrder();
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
          showPrinterConfigDialog(PrinterTypeEnum.bill);
          setState(ViewStatus.Completed);
          return;
        } else {
          api.updateOrder(userInfo!.storeId, orderId, OrderStatusEnum.PAID,
              selectedPaymentMethod!.id);
          setState(ViewStatus.Completed);
          clearOrder();
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
          currentOrder?.payment!.id!);
      clearOrder();
      showAlertDialog(
          title: "Huỷ đơn hàng", content: "Huỷ đơn hàng thành công");
      setState(ViewStatus.Completed);
    } catch (e) {
      showAlertDialog(title: "Lỗi huỷ đơn hàng", content: e.toString());
      setState(ViewStatus.Error);
    }
  }

  void clearOrder() {
    setState(ViewStatus.Loading);
    hideBottomSheet();
    currentOrderId = null;
    currentOrder = null;
    setState(ViewStatus.Completed);
    getListOrder();
  }
}
