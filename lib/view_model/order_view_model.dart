import 'dart:core';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
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
  List<OrderInList> listOrder = [];
  PaymentStatusResponse? paymentStatus;
  String currentPaymentStatusMessage = "Chưa thanh toán";
  String paymentCheckingStatus = PaymentStatusEnum.PENDING;
  String? qrCodeData;
  CustomerInfoModel? memberShipInfo;
  String topupPaymentType = PaymentTypeEnums.CASH;
  OrderViewModel() {
    api = OrderAPI();
    paymentData = PaymentData();
    listPayment = [
      PaymentProvider(
          name: "Tiền mặt",
          type: PaymentTypeEnums.CASH,
          picUrl:
              'https://firebasestorage.googleapis.com/v0/b/pos-system-47f93.appspot.com/o/files%2Fcash.png?alt=media&token=42566a9d-b092-4e80-90dd-9313aeee081d'),
      PaymentProvider(
          name: "Momo",
          type: PaymentTypeEnums.MOMO,
          picUrl:
              'https://firebasestorage.googleapis.com/v0/b/pos-system-47f93.appspot.com/o/files%2Fmomo.png?alt=media&token=d0d2e4f2-b035-4989-b04f-2ef55b9d0606'),
      PaymentProvider(
          name: "Ngân hàng",
          type: PaymentTypeEnums.BANKING,
          picUrl:
              'https://firebasestorage.googleapis.com/v0/b/pos-system-47f93.appspot.com/o/files%2Fbanking.png?alt=media&token=f4dba580-bd73-433d-9b8c-ed8a79958ed9'),
      PaymentProvider(
          name: "Visa/MasterCard",
          type: PaymentTypeEnums.VISA,
          picUrl:
              'https://firebasestorage.googleapis.com/v0/b/pos-system-47f93.appspot.com/o/files%2Fbanking.png?alt=media&token=f4dba580-bd73-433d-9b8c-ed8a79958ed9'),
      PaymentProvider(
          name: "Thẻ thành viên",
          type: PaymentTypeEnums.POINTIFY,
          picUrl:
              "https://firebasestorage.googleapis.com/v0/b/pos-system-47f93.appspot.com/o/files%2Fpointify.jpg?alt=media&token=c1953b7c-23d4-4fb6-b866-ac13ae639a00")
    ];
    selectedPaymentMethod = listPayment[0];
  }

  String getPaymentName(String paymentType) {
    for (var item in listPayment) {
      if (item!.type == paymentType) {
        return item.name!;
      }
    }
    return "Tiền mặt";
  }

  void scanMembership(String phone) async {
    try {
      setState(ViewStatus.Loading);
      memberShipInfo = await accountData.scanCustomer(phone);
      setState(ViewStatus.Completed);
      notifyListeners();
    } catch (e) {
      setState(ViewStatus.Error, e.toString());
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
        userId: memberShipInfo?.id ?? '',
        amount: amount,
        paymentType: topupPaymentType);
    await api.topupMemberWallet(request).then((value) => {
          if (value == null)
            {showAlertDialog(content: "Nạp tiền không thành công")}
          else
            {
              showAlertDialog(
                  title: value.status == "PAID" ? "Thành công" : "Thất bại",
                  content: value.message ?? '')
            }
        });
  }

  void selectPayment(PaymentProvider payment) {
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

  void makePayment(PaymentProvider payment) async {
    // if (listPayment.isEmpty) {
    paymentCheckingStatus = PaymentStatusEnum.PAID;
    await completeOrder(currentOrder!.orderId ?? '');
    // } else {
    //   qrCodeData = null;
    //   if (currentOrder == null) {
    //     showAlertDialog(
    //         title: "Lỗi đơn hàng", content: "Không tìm thấy đơn hàng");

    //     return;
    //   }
    //   MakePaymentResponse makePaymentResponse =
    //       await api.makePayment(currentOrder!, payment.id ?? '');
    //   if (makePaymentResponse.displayType == "Url") {
    //     currentPaymentStatusMessage =
    //         makePaymentResponse.message ?? "Đợi thanh toán";
    //     // qrCodeData = payment.type != "VNPAY" ? makePaymentResponse.url : null;
    //     await launchInBrowser(makePaymentResponse.url ?? '');
    //   } else if (makePaymentResponse.displayType == "Qr") {
    //     currentPaymentStatusMessage =
    //         makePaymentResponse.message ?? "Đợi thanh toán";
    //     qrCodeData = makePaymentResponse.url;
    //     await launchQrCode(makePaymentResponse.url ?? '');
    //   } else {
    //     currentPaymentStatusMessage =
    //         makePaymentResponse.message ?? "Đợi thanh toán";
    //   }
    //   checkPaymentStatus(currentOrder!.orderId ?? '');
    //   notifyListeners();
    // }
  }

  void getListOrder(
      {bool isToday = true,
      bool isYesterday = false,
      int page = 1,
      String? orderStatus,
      String? orderType}) async {
    try {
      setState(ViewStatus.Loading);
      Account? userInfo = await getUserInfo();
      listOrder = await api.getListOrderOfStore(userInfo!.storeId,
          isToday: isToday,
          isYesterday: isYesterday,
          page: page,
          orderStatus: orderStatus,
          orderType: orderType);
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
      } else {
        String? code = await scanPointifyWallet();
        if (code != null) {
          MakePaymentResponse? makePaymentResponse =
              await api.makePayment(orderId, code, selectedPaymentMethod?.type);
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
        } else {
          return;
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
      chooseTableDialog();
    }

    // Duration(seconds: 2);
    // await launchStoreLogo();
  }

  clearOrder() {
    currentOrderId = null;
    currentOrder = null;
    selectedPaymentMethod = listPayment[0];
    hideDialog();
  }
}
