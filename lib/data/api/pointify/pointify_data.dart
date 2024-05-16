import 'package:pos_apps/util/request.dart';
import 'package:pos_apps/util/request_pointify.dart';
import 'package:pos_apps/views/widgets/other_dialogs/dialog.dart';

import '../../../util/share_pref.dart';
import '../../model/account.dart';
import '../../model/customer.dart';
import '../../model/pointify/promotion_model.dart';

class PointifyData {
  Future<List<PromotionPointify>> getListPromotionOfStore() async {
    Account? userInfo = await getUserInfo();
    final res = await requestPointify.get('stores/promotions',
        queryParameters: {
          "storeCode": userInfo?.storeCode ?? '',
          "brandCode": userInfo?.brandCode ?? ''
        });
    var jsonList = res.data;
    List<PromotionPointify> listPromotion = [];
    for (var item in jsonList) {
      PromotionPointify res = PromotionPointify.fromJson(item);
      listPromotion.add(res);
    }
    return listPromotion;
  }

  Future<CustomerInfoModel?> scanCustomer(String phone) async {
    String modifilePhone = phone;
    if (phone.startsWith("0")) {
      modifilePhone = phone.replaceFirst('0', "+84");
    }
    Account? userInfo = await getUserInfo();
    final response = await requestPointify.get("stores/scan-membership",
        queryParameters: {
          "code": modifilePhone,
          "apiKey": userInfo?.brandId ?? ''
        });
    if (response.statusCode == 400) {
      showAlertDialog(
          title: "Lỗi", content: "không tìm thấy thông tin thành viên");
      return null;
    }
    if (response.statusCode == 200) {
      final customer = response.data;

      CustomerInfoModel customerInfoModel =
          CustomerInfoModel.fromJson(customer);
      return customerInfoModel;
    } else {
      return null;
    }
  }
}
