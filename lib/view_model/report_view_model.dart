import 'package:get/get.dart';
import 'package:pos_apps/data/api/report_data.dart';
import 'package:pos_apps/view_model/index.dart';

import '../data/model/index.dart';
import '../data/model/response/session_detail_report.dart';
import '../data/model/response/sessions.dart';
import '../data/model/response/store.dart';
import '../enums/order_enum.dart';
import '../enums/view_status.dart';
import '../util/share_pref.dart';
import '../views/widgets/other_dialogs/dialog.dart';
import '../views/widgets/printer_dialogs/add_printer_dialog.dart';
import 'base_view_model.dart';
import 'printer_view_model.dart';

class ReportViewModel extends BaseViewModel {
  ReportData? reportData;

  ReportViewModel() {
    reportData = ReportData();
  }

  Future<dynamic> getSessionDetailReport({required String sessionId}) async {
    try {
      setState(ViewStatus.Loading);
      var response = await reportData?.getSessionDetailReport(sessionId);
      setState(ViewStatus.Completed);
      return response;
    } catch (e) {
      printError(info: e.toString());
    }
  }

  void printCloseSessionInvoice(
      Session session, SessionDetailReport report) async {
    try {
      setState(ViewStatus.Loading);
      Account? userInfo = await getUserInfo();
      StoreModel? storeDetails = Get.find<MenuViewModel>().storeDetails;
      if (Get.find<PrinterViewModel>().selectedBillPrinter != null) {
        Get.find<PrinterViewModel>()
            .printCloseSessionInvoice(session, report, storeDetails, userInfo!);
        hideDialog();
        setState(ViewStatus.Completed);
        showAlertDialog(
            title: "Hoàn thành", content: "In biên lai thành công ");
      } else {
        bool result = await showConfirmDialog(
          title: "Lỗi in hóa đơn",
          content: "Vui lòng chọn máy in hóa đơn",
          cancelText: "Bỏ qua",
          confirmText: "Chọn máy in",
        );
        if (result) {
          showPrinterConfigDialog(PrinterTypeEnum.bill);
          setState(ViewStatus.Completed);
        }
        setState(ViewStatus.Completed);
        return;
      }
    } catch (e) {
      setState(ViewStatus.Error, e.toString());
    }
  }
}
