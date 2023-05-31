import 'package:pos_apps/data/model/response/session_detail_report.dart';

import '../../util/request.dart';
import '../../util/share_pref.dart';
import '../model/index.dart';

class ReportData {
  Future<DayReport> getStoreEndDayReport(
      DateTime startDate, DateTime endDate) async {
    Account? userInfo = await getUserInfo();
    var params = <String, dynamic>{
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String()
    };
    print(params);
    final res = await request.get('stores/${userInfo!.storeId}/day-report',
        queryParameters: params);
    var json = res.data;
    DayReport report = DayReport.fromJson(json);
    return report;
  }

  Future<SessionDetailReport> getSessionDetailReport(String sessionId) async {
    final res = await request.get('report/session-report/$sessionId');
    var json = res.data;
    SessionDetailReport report = SessionDetailReport.fromJson(json);
    return report;
  }
}
