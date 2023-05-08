import '../../util/request.dart';
import '../../util/share_pref.dart';
import '../model/index.dart';

class ReportData {
  Future<StoreEndDayReport> getStoreEndDayReport(
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
    StoreEndDayReport report = StoreEndDayReport.fromJson(json);
    return report;
  }
}
