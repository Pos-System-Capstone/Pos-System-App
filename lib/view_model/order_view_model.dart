import 'dart:core';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pos_apps/data/api/pointify/pointify_data.dart';
import 'package:pos_apps/data/model/response/order_in_list.dart';
import 'package:pos_apps/data/model/response/order_response.dart';
import 'package:pos_apps/data/model/response/payment_provider.dart';
import 'package:pos_apps/data/model/topup_wallet_request.dart';
import 'package:pos_apps/enums/index.dart';
import 'package:pos_apps/routes/routes_constraints.dart';
import 'package:pos_apps/util/share_pref.dart';
import 'package:pos_apps/view_model/index.dart';
import 'package:pos_apps/views/screens/home/cart/dialog/choose_table_dialog.dart';
import 'package:pos_apps/views/screens/home/payment/payment_dialogs/scan_membership_card_dialog.dart';
import '../data/api/account_data.dart';
import '../data/api/order_api.dart';
import '../data/api/payment_data.dart';
import '../data/model/cart_model.dart';
import '../data/model/customer.dart';
import '../data/model/index.dart';
import '../data/model/payment_response_model.dart';
import '../views/screens/home/payment/payment_dialogs/payment_dialog.dart';
import '../views/widgets/other_dialogs/dialog.dart';

class OrderViewModel extends BaseViewModel {
  late OrderAPI api = OrderAPI();
  String? currentOrderId;
  num customerMoney = 0;
  num returnMoney = 0;
  OrderResponseModel? currentOrder;
  List<PaymentProvider?> listPayment = [];
  PaymentProvider? selectedPaymentMethod;
  AccountData accountData = AccountData();
  PaymentData? paymentData;
  PointifyData? pointifyData;
  List<OrderInList> listOrder = [];
  String currentPaymentStatusMessage = "Chưa thanh toán";
  String paymentCheckingStatus = PaymentStatusEnum.PENDING;
  String? qrCodeData;
  CustomerInfoModel? memberShipInfo;
  String topupPaymentType = PaymentTypeEnums.CASH;
  OrderViewModel() {
    api = OrderAPI();
    paymentData = PaymentData();
    pointifyData = PointifyData();
  }
  Future getListPayment() async {
    try {
      listPayment = (await paymentData?.getListPayment())!;
      selectedPaymentMethod = listPayment
          .firstWhere((element) => element?.type == PaymentTypeEnums.CASH);
    } catch (e) {
      setState(ViewStatus.Error, e.toString());
    }
  }

  String getPaymentName(String paymentType) {
    for (var item in listPayment) {
      if (item!.type == paymentType) {
        return item.name;
      }
    }
    return "Tiền mặt";
  }

  void scanMembership(String phone) async {
    try {
      setState(ViewStatus.Loading);
      memberShipInfo = await pointifyData?.scanCustomer(phone);
      setState(ViewStatus.Completed);
      notifyListeners();
    } catch (e) {
      setState(ViewStatus.Completed);
    }
  }

  void removeMembership() {
    memberShipInfo = null;
    notifyListeners();
  }

  void setTopUpType(String type) {
    topupPaymentType = type;
    notifyListeners();
  }

  Future topupWallet(num amount) async {
    showLoadingDialog();
    Account? userInfo = await getUserInfo();
    TopUpWalletRequest request = TopUpWalletRequest(
        storeId: userInfo!.storeId,
        userId: memberShipInfo?.membershipId ?? '',
        amount: amount,
        paymentType: topupPaymentType);
    await api.topupMemberWallet(request).then((value) => {
          if (value == null)
            {showAlertDialog(content: "Nạp tiền không thành công")}
          else
            {
              showAlertDialog(
                  title: value.status == "SUCCESS" ? "Thành công" : "Thất bại",
                  content: value.message ?? '')
            }
        });
  }

  void selectPayment(PaymentProvider payment) {
    if (payment.type == PaymentTypeEnums.POINTIFY &&
        currentOrder?.customerInfo == null) {
      showAlertDialog(
          title: "Thông báo", content: "Phương thức thanh toán không hợp lệ");
    }
    selectedPaymentMethod = payment;
    currentPaymentStatusMessage = "Vui lòng tiến hành thanh toán";
    notifyListeners();
  }

  void setCustomerMoney(num money) {
    customerMoney = money;
    returnMoney = customerMoney - currentOrder!.finalAmount!;
    notifyListeners();
  }

  Future<bool> placeOrder(CartModel order) async {
    showLoadingDialog();
    Account? userInfo = await getUserInfo();
    await api.createOrder(order, userInfo!.storeId).then((value) => {
          hideDialog(),
          showPaymentBotomSheet(value),
        });
    return true;
  }

  Future<void> confirmOrder(String status, String orderId) async {
    await api.confirmOrder(orderId, status);
    getListOrder();
  }

  void makePayment(PaymentProvider payment) async {
    paymentCheckingStatus = PaymentStatusEnum.PAID;
    await completeOrder(currentOrder!.orderId ?? '');
    getListOrder();
  }

  void getListOrder(
      {bool isToday = true,
      bool isYesterday = false,
      int page = 1,
      String? orderStatus,
      String? orderType,
      String? paymentType,
      String? invoiceId}) async {
    try {
      setState(ViewStatus.Loading);
      Account? userInfo = await getUserInfo();
      listOrder = await api.getListOrderOfStore(userInfo!.storeId,
          isToday: isToday,
          isYesterday: isYesterday,
          page: page,
          orderStatus: orderStatus,
          orderType: orderType,
          paymentType: paymentType,
          invoiceId: invoiceId);
      setState(ViewStatus.Completed);
    } catch (e) {
      setState(ViewStatus.Completed);
      showAlertDialog(title: "Lỗi đơn hàng", content: e.toString());
    }
  }

  void findNewUserOrder() async {
    try {
      Account? userInfo = await getUserInfo();
      var res = await api.findNewUserOrder(userInfo?.storeId ?? '');
      if (res?.totalOrder != 0) {
        SystemSound.play(SystemSoundType.alert);
        Get.snackbar(onTap: (snack) {
          Get.toNamed(
            "${RouteHandler.HOME}?idx=${1}",
          );
        },
            duration: Duration(seconds: 1),
            "Có ${res?.totalOrder} đơn hàng mới",
            '${res?.totalOrderPickUp} đơn hàng nhận tại quán, ${res?.totalOrderDeli} đơn hàng giao hàng ');
      }
    } catch (e) {}
  }

  void getOrderByStore(String orderId) async {
    setState(ViewStatus.Loading);
    qrCodeData = null;
    customerMoney = 0;
    Account? userInfo = await getUserInfo();

    await api.getOrderOfStore(userInfo!.storeId, orderId).then((value) => {
          if (value == null)
            {setState(ViewStatus.Completed)}
          else
            {
              currentOrder = value,
              value.orderStatus == OrderStatusEnum.PENDING
                  ? currentPaymentStatusMessage =
                      "Vui lòng chọn phương thức thanh toán"
                  : "Chưa thanh toán",
              setState(ViewStatus.Completed)
            }
        });
    if (currentOrder?.customerInfo != null &&
        currentOrder?.customerInfo?.paymentStatus != null) {
      paymentCheckingStatus = currentOrder?.customerInfo?.paymentStatus ??
          PaymentStatusEnum.PENDING;
    } else {
      paymentCheckingStatus = PaymentStatusEnum.PENDING;
    }
    for (var element in listPayment) {
      if (element!.type! == currentOrder!.paymentType) {
        selectedPaymentMethod = element;
      }
    }
    setState(ViewStatus.Completed);
  }

  Future<void> completeOrder(
    String orderId,
  ) async {
    Account? userInfo = await getUserInfo();
    if (selectedPaymentMethod == null) {
      await showAlertDialog(
          title: "Thông báo", content: "Vui lòng chọn phương thức thanh toán");
      return;
    }
    if (selectedPaymentMethod?.type == PaymentTypeEnums.POINTIFY) {
      if (currentOrder?.customerInfo != null &&
          currentOrder?.customerInfo?.paymentStatus == PaymentStatusEnum.PAID) {
        await api.updateOrder(userInfo!.storeId, orderId, OrderStatusEnum.PAID,
            currentOrder?.paymentType);
        Get.find<PrinterViewModel>().printBill(
            currentOrder!, selectedPaymentMethod!.name ?? "Tiền mặt");
        clearOrder();
        await showAlertDialog(
            title: "Thanh toán thành công",
            content: "Đơn hàng thanh toán thành công");
        Duration(seconds: 2);
        chooseTableDialog();
      } else if (currentOrder?.customerInfo == null) {
        await showAlertDialog(
            title: "Lỗi thanh toán",
            content: "Đơn hàng không có thông tin thành viên");
      } else {
        MakePaymentResponse? makePaymentResponse =
            await api.makePayment(orderId, selectedPaymentMethod?.type);
        if (makePaymentResponse?.status == "FAIL") {
          await showAlertDialog(
              title: "Lỗi thanh toán",
              content: makePaymentResponse?.message ?? '');
        } else if (makePaymentResponse?.status == "SUCCESS") {
          await api.updateOrder(userInfo!.storeId, orderId,
              OrderStatusEnum.PAID, makePaymentResponse?.paymentType);
          Get.find<PrinterViewModel>().printBill(
              currentOrder!, selectedPaymentMethod!.name ?? "Tiền mặt");
          clearOrder();
          await showAlertDialog(
              title: "Thanh toán thành công",
              content: "Đơn hàng thanh toán thành công");
          Duration(seconds: 2);
          chooseTableDialog();
        }
      }
    } else {
      await api.updateOrder(userInfo!.storeId, orderId, OrderStatusEnum.PAID,
          selectedPaymentMethod!.type);
      Get.find<PrinterViewModel>()
          .printBill(currentOrder!, selectedPaymentMethod!.name ?? "Tiền mặt");
      clearOrder();
      await showAlertDialog(
          title: "Thanh toán thành công",
          content: "Đơn hàng thanh toán thành công");
      Duration(seconds: 2);
      getListOrder();
      chooseTableDialog();
    }

    // Duration(seconds: 2);
    // await launchStoreLogo();
  }

  clearOrder() {
    currentOrderId = null;
    currentOrder = null;
    if (listPayment.isNotEmpty) {
      selectedPaymentMethod = listPayment[0];
    }
    getListOrder();
    hideDialog();
  }
}
