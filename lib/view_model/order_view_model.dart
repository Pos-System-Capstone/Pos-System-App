import 'dart:core';
import 'dart:math';
import 'package:get/get.dart';
import 'package:pos_apps/data/model/response/make_payment_response.dart';
import 'package:pos_apps/data/model/response/order_in_list.dart';
import 'package:pos_apps/data/model/response/order_response.dart';
import 'package:pos_apps/data/model/response/payment_provider.dart';
import 'package:pos_apps/enums/index.dart';
import 'package:pos_apps/util/share_pref.dart';
import 'package:pos_apps/view_model/index.dart';
import 'package:pos_apps/views/screens/home/cart/dialog/choose_table_dialog.dart';
import 'package:url_launcher/url_launcher.dart';
import '../data/api/order_api.dart';
import '../data/api/payment_data.dart';
import '../data/model/index.dart';
import '../views/screens/home/payment/payment_dialogs/payment_dialog.dart';
import '../views/widgets/other_dialogs/dialog.dart';
import '../views/widgets/printer_dialogs/add_printer_dialog.dart';

class OrderViewModel extends BaseViewModel {
  int selectedTable = 01;
  String deliveryType = DeliType().eatIn.type;
  Cart? currentCart;
  late OrderAPI api = OrderAPI();
  String? currentOrderId;
  num customerMoney = 0;
  num returnMoney = 0;
  OrderResponseModel? currentOrder;
  List<PaymentProvider?> listPayment = [];
  PaymentProvider? selectedPaymentMethod;
  PaymentData? paymentData;
  List<OrderInList> listOrder = [];
  PaymentStatusResponse? paymentStatus;
  String currentPaymentStatusMessage = "Chưa thanh toán";
  String paymentCheckingStatus = PaymentStatusEnum.CANCELED;
  String? qrCodeData;

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
          name: "Visa/Mastercard",
          type: PaymentTypeEnums.VISA,
          picUrl:
              'https://firebasestorage.googleapis.com/v0/b/pos-system-47f93.appspot.com/o/files%2Fvisa-credit-card.png?alt=media&token=1cfb48ab-b957-47db-8f52-89da33d0fb39'),
    ];
  }

  // void getListPayment() async {
  //   setState(ViewStatus.Loading);
  //   await paymentData!.getListPayment().then((value) {
  //     listPayment = value;
  //   });
  //   setState(ViewStatus.Completed);
  // }

  String getPaymentName(String paymentType) {
    for (var item in listPayment) {
      if (item!.type == paymentType) {
        return item.name!;
      }
    }
    return "Tiền mặt";
  }

  void selectPayment(PaymentProvider payment) {
    qrCodeData = null;
    selectedPaymentMethod = payment;
    currentPaymentStatusMessage = "Vui lòng tiến hành thanh toán";
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

  void setCustomerMoney(num money) {
    customerMoney = money;
    returnMoney = customerMoney - currentOrder!.finalAmount!;
    notifyListeners();
  }

  Future<bool> placeOrder(OrderModel order) async {
    showLoadingDialog();
    Account? userInfo = await getUserInfo();
    await api.placeOrder(order, userInfo!.storeId).then((value) => {
          hideDialog(),
          showPaymentBotomSheet(value),
        });
    return true;
  }

  void makePayment(PaymentProvider payment) async {
    paymentCheckingStatus = PaymentStatusEnum.PENDING;
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

  void updatePaymentStatus(String status) {
    paymentData
        ?.updatePayment(currentOrder!.orderId ?? '', status)
        .then((value) => {
              if (value != null)
                {
                  Get.snackbar("Cập nhật trạng thái thanh toán", value),
                }
              else
                {
                  Get.snackbar(
                      "Cập nhật trạng thái thanh toán", "Thanh toan that bai"),
                }
            });
  }

  void checkPaymentStatus(String orderId) async {
    paymentCheckingStatus = PaymentStatusEnum.PENDING;
    for (int i = 0; i < 30; i++) {
      await Future.delayed(Duration(seconds: 3));
      await paymentData?.checkPayment(orderId).then((value) => {
            paymentStatus = value,
          });
      if (paymentStatus != null) {
        if (paymentStatus!.transactionStatus == PaymentStatusEnum.PAID) {
          currentPaymentStatusMessage = "Thanh toán thành công";
          paymentCheckingStatus = PaymentStatusEnum.PAID;
          break;
        } else if (paymentStatus!.transactionStatus == PaymentStatusEnum.FAIL) {
          currentPaymentStatusMessage = "Thanh toán thất bại";
          paymentCheckingStatus = PaymentStatusEnum.FAIL;
          Get.snackbar("Thanh toán thất bại",
              "Đơn hàng thanh toán thanh toán thất bại, vui lòng thử lại");
          break;
        } else {
          currentPaymentStatusMessage = "Đang kiểm tra thanh toán";
          paymentCheckingStatus = PaymentStatusEnum.PENDING;
        }
      } else {
        currentPaymentStatusMessage = "Vui lòng kiểm tra lại";
        paymentCheckingStatus = PaymentStatusEnum.CANCELED;
      }
    }
    if (paymentCheckingStatus == PaymentStatusEnum.PAID) {
      await completeOrder(orderId);
    }
    notifyListeners();
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

  void getOrderByStore(String orderId) async {
    setState(ViewStatus.Loading);
    qrCodeData = null;
    customerMoney = 0;
    Account? userInfo = await getUserInfo();

    await api.getOrderOfStore(userInfo!.storeId, orderId).then((value) => {
          currentOrder = value,
          value.orderStatus == OrderStatusEnum.PENDING
              ? currentPaymentStatusMessage =
                  "Vui lòng chọn phương thức thanh toán"
              : "Chưa thanh toán",
          setState(ViewStatus.Completed)
        });
    // await paymentData?.getPaymentProviderOfOrder(orderId).then((value) => {
    //       currentOrder?.paymentMethod = value,
    //       // ignore: avoid_print
    //     });
    currentOrder!.discountProduct = 0;
    currentOrder!.productList?.forEach((element) {
      currentOrder!.discountProduct =
          currentOrder!.discountProduct! + element.discount!;
    });
    currentOrder!.discountPromotion = 0;
    currentOrder!.discountPromotion =
        currentOrder!.discount! - currentOrder!.discountProduct!;
    for (var element in listPayment) {
      if (element!.type! == currentOrder!.paymentType) {
        selectedPaymentMethod = element;
      }
    }
    paymentCheckingStatus = PaymentStatusEnum.CANCELED;
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
    if (paymentCheckingStatus != PaymentStatusEnum.PAID) {
      await showAlertDialog(
          title: "Thông báo", content: "Vui lòng kiểm tra lại thanh toán");
      return;
    }
    await api.updateOrder(userInfo!.storeId, orderId, OrderStatusEnum.PAID,
        selectedPaymentMethod!.type);
    Get.find<PrinterViewModel>().printBill(currentOrder!, selectedTable,
        selectedPaymentMethod!.name ?? "Tiền mặt");
    clearOrder();
    await showAlertDialog(
        title: "Thanh toán thành công",
        content: "Đơn hàng thanh toán thành công");
    Duration(seconds: 2);
    chooseTableDialog();
    // Duration(seconds: 2);
    // await launchStoreLogo();
  }

  clearOrder() {
    currentOrderId = null;
    currentOrder = null;
    selectedPaymentMethod = null;
    hideDialog();
  }

  Future<void> launchInWebViewOrVC() async {
    Uri url = Uri.parse('https://www.google.com/');
    if (!await launchUrl(
      url,
      mode: LaunchMode.inAppWebView,
      webViewConfiguration: const WebViewConfiguration(
          headers: <String, String>{'my_header_key': 'my_header_value'}),
    )) {
      throw Exception('Could not launch $url');
    }
  }

  Future<void> launchInBrowser(String value) async {
    Uri url = Uri.parse(value);
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $url');
    }
  }

  Future<void> launchQrCode(String qrCode) async {
    Uri url = Uri.parse(
        'https://quickchart.io/qr?text=$qrCode&ecLevel=H&margin=8&size=350');
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $url');
    }
  }

  Future<void> launchStoreLogo() async {
    String? url = Get.find<MenuViewModel>().storeDetails.brandPicUrl;
    Uri uri = Uri.parse(url ??
        "https://firebasestorage.googleapis.com/v0/b/pos-system-47f93.appspot.com/o/files%2Flogo.png?alt=media&token=423dceec-a73b-4313-83ed-9b56f8f3996c");
    if (!await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $url');
    }
  }
}
