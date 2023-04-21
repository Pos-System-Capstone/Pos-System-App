import 'dart:core';
import 'package:get/get.dart';
import 'package:pos_apps/data/model/response/make_payment_response.dart';
import 'package:pos_apps/data/model/response/order_in_list.dart';
import 'package:pos_apps/data/model/response/order_response.dart';
import 'package:pos_apps/data/model/response/payment_provider.dart';
import 'package:pos_apps/enums/index.dart';
import 'package:pos_apps/util/share_pref.dart';
import 'package:pos_apps/view_model/index.dart';
import 'package:pos_apps/view_model/printer_view_model.dart';
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
  OrderResponseModel? currentOrder;
  List<PaymentProvider?> listPayment = [];
  PaymentProvider? selectedPaymentMethod;
  PaymentData? paymentData;
  List<OrderInList> listOrder = [];
  PaymentStatusResponse? paymentStatus;
  String currentPaymentStatusMessage = "Chưa thanh toán";
  bool isCheckingPaymentStatus = false;

  OrderViewModel() {
    api = OrderAPI();
    paymentData = PaymentData();
  }

  void getListPayment() async {
    setState(ViewStatus.Loading);
    await paymentData!.getListPayment().then((value) {
      listPayment = value;
    });
    setState(ViewStatus.Completed);
  }

  void selectPayment(PaymentProvider payment) {
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

  Future<bool> placeOrder(OrderModel order) async {
    try {
      showLoadingDialog();
      Account? userInfo = await getUserInfo();
      order.paymentId = listPayment[0]!.id;
      await api.placeOrder(order, userInfo!.storeId).then((value) => {
            hideDialog(),
            showPaymentBotomSheet(value),
          });

      return true;
    } catch (e) {
      showAlertDialog(title: "Lỗi đặt hàng", content: e.toString());
      return false;
    }
  }

  void makePayment(PaymentProvider payment) async {
    isCheckingPaymentStatus = true;
    if (currentOrder == null) {
      showAlertDialog(
          title: "Lỗi đơn hàng", content: "Không tìm thấy đơn hàng");

      return;
    }
    MakePaymentResponse makePaymentResponse =
        await api.makePayment(currentOrder!, payment.id ?? '');
    if (makePaymentResponse.displayType == "Url") {
      currentPaymentStatusMessage =
          makePaymentResponse.message ?? "Đợi thanh toán";
      await launchInBrowser(makePaymentResponse.url ?? '');
      isCheckingPaymentStatus = false;
      notifyListeners();
    } else if (makePaymentResponse.displayType == "Qr") {
      currentPaymentStatusMessage =
          makePaymentResponse.message ?? "Đợi thanh toán";
      await launchQrCode(makePaymentResponse.url ?? '');

      isCheckingPaymentStatus = false;
      notifyListeners();
    } else {
      currentPaymentStatusMessage =
          makePaymentResponse.message ?? "Đợi thanh toán";
      isCheckingPaymentStatus = false;
      notifyListeners();
    }
  }

  void checkPaymentStatus(String orderId) async {
    isCheckingPaymentStatus = true;
    for (int i = 0; i < 10; i++) {
      await Future.delayed(Duration(seconds: 2));
      await api.checkPayment(orderId).then((value) => paymentStatus = value);
      if (paymentStatus != null) {
        if (paymentStatus!.message == "Paid") {
          currentPaymentStatusMessage = "Thanh toán thành công";
          isCheckingPaymentStatus = false;
          notifyListeners();
          showAlertDialog(
              title: "Thanh toán thành công",
              content: "Đơn hàng đã được thanh toán thành công");
          break;
        } else if (paymentStatus!.message == "Fail") {
          currentPaymentStatusMessage = "Thanh toán thất bại";
          isCheckingPaymentStatus = false;
          notifyListeners();
          showAlertDialog(
              title: "Thanh toán thất bại",
              content: "Đơn hàng thanh toán  thất bại");
          break;
        } else if (paymentStatus!.message == "Pending") {
          currentPaymentStatusMessage = "Đang kiểm tra thanh toán";
          notifyListeners();
        } else {
          isCheckingPaymentStatus = true;
          notifyListeners();
        }
      }
    }
    isCheckingPaymentStatus = false;
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
      setState(ViewStatus.Error, e.toString());
    }
  }

  void getOrderByStore(String orderId) async {
    try {
      setState(ViewStatus.Loading);
      Account? userInfo = await getUserInfo();

      await api.getOrderOfStore(userInfo!.storeId, orderId).then((value) => {
            currentOrder = value,
            value.orderStatus == OrderStatusEnum.PENDING
                ? currentPaymentStatusMessage =
                    "Vui lòng chọn phương thức thanh toán"
                : "Chưa thanh toán",
            setState(ViewStatus.Completed)
          });
    } catch (e) {
      showAlertDialog(title: "Lỗi đơn hàng", content: e.toString());
      setState(ViewStatus.Error);
    }
  }

  Future<void> completeOrder(
    String orderId,
  ) async {
    Account? userInfo = await getUserInfo();
    if (selectedPaymentMethod == null) {
      showAlertDialog(
          title: "Lỗi thanh toán",
          content: "Vui lòng chọn phương thức thanh toán");
      return;
    }

    if (Get.find<PrinterViewModel>().selectedBillPrinter != null) {
      await api.updateOrder(userInfo!.storeId, orderId, OrderStatusEnum.PAID,
          selectedPaymentMethod!.id);
      Get.find<PrinterViewModel>().printBill(currentOrder!, selectedTable,
          selectedPaymentMethod!.name ?? "Tiền mặt");
      clearOrder();
      await showAlertDialog(
          title: "Hoàn thành đơn hàng",
          content: "Hoàn thành đơn hàng thành công");
    } else {
      bool result = await showConfirmDialog(
        title: "Lỗi in hóa đơn",
        content: "Vui lòng chọn máy in hóa đơn",
        confirmText: "Bỏ qua",
        cancelText: "Chọn máy in",
      );
      if (!result) {
        showPrinterConfigDialog(PrinterTypeEnum.bill);
        return;
      } else {
        await api.updateOrder(userInfo!.storeId, orderId, OrderStatusEnum.PAID,
            selectedPaymentMethod!.id);
        clearOrder();
        await showAlertDialog(
            title: "Hoàn thành đơn hàng",
            content: "Hoàn thành đơn hàng thành công");
      }
    }
  }

  void clearOrder() {
    hideBottomSheet();
    currentOrderId = null;
    currentOrder = null;
    selectedPaymentMethod = null;
    getListOrder();
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
}
