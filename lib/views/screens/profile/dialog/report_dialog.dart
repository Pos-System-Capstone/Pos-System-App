import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_apps/data/model/index.dart';
import 'package:pos_apps/util/share_pref.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../../../enums/index.dart';
import '../../../../util/format.dart';
import '../../../../view_model/index.dart';
import '../../../widgets/other_dialogs/dialog.dart';

void reportDetailsDialog(DateTime startDate, DateTime endDate) {
  MenuViewModel menuViewModel = Get.find<MenuViewModel>();
  DayReport? reportDetails;
  Account? account;
  menuViewModel.getStoreEndDayReport(startDate, endDate).then((value) {
    reportDetails = value;
  });
  getUserInfo().then((value) => account = value);
  Get.dialog(Dialog(
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8.0))),
    child: ScopedModel(
      model: menuViewModel,
      child: ScopedModelDescendant<MenuViewModel>(
          builder: (context, build, model) {
        if (model.status == ViewStatus.Loading) {
          return Container(
            width: Get.size.width * 0.4,
            height: Get.size.height * 0.9,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Get.theme.colorScheme.background,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Get.theme.colorScheme.shadow,
                  blurRadius: 10.0,
                  offset: Offset(0.0, 10.0),
                ),
              ],
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Đang tải...",
                    style: Get.textTheme.titleLarge,
                  ),
                ],
              ),
            ),
          );
        } else if (model.status == ViewStatus.Error && reportDetails == null) {
          return Container(
            width: Get.size.width * 0.4,
            height: Get.size.height * 0.9,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Get.theme.colorScheme.background,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Get.theme.colorScheme.shadow,
                  blurRadius: 10.0,
                  offset: Offset(0.0, 10.0),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Không tìm thấy thông tin báo cáo",
                  style: Get.textTheme.titleLarge,
                ),
              ],
            ),
          );
        }
        return Container(
          width: Get.size.width * 0.5,
          height: Get.size.height,
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Get.theme.colorScheme.background,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Get.theme.colorScheme.shadow,
                blurRadius: 10.0,
                offset: Offset(0.0, 10.0),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Báo cáo ngày ${formatOnlyDate(startDate.toIso8601String())}",
                      style: Get.textTheme.titleMedium,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      onPressed: () {
                        hideDialog();
                      },
                      icon: Icon(
                        Icons.close,
                        color: Get.theme.colorScheme.onBackground,
                        size: 32,
                      ),
                    ),
                  ),
                ],
              ),
              Divider(
                color: Get.theme.colorScheme.onBackground,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Container(
                      //   decoration: BoxDecoration(
                      //     borderRadius: BorderRadius.only(
                      //         topLeft: Radius.circular(8),
                      //         topRight: Radius.circular(8)),
                      //   ),
                      //   child: Column(
                      //     crossAxisAlignment: CrossAxisAlignment.center,
                      //     mainAxisAlignment: MainAxisAlignment.start,
                      //     children: [
                      //       Padding(
                      //         padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
                      //         child: Row(
                      //           mainAxisAlignment: MainAxisAlignment.center,
                      //           crossAxisAlignment: CrossAxisAlignment.center,
                      //           children: [
                      //             Expanded(
                      //               flex: 8,
                      //               child: Text(
                      //                 'Tên',
                      //                 style: Get.textTheme.bodyMedium,
                      //               ),
                      //             ),
                      //             Expanded(
                      //               flex: 1,
                      //               child: Text(
                      //                 'SL',
                      //                 style: Get.textTheme.bodyMedium,
                      //               ),
                      //             ),
                      //             Expanded(
                      //               flex: 2,
                      //               child: Align(
                      //                 alignment: Alignment.centerRight,
                      //                 child: Text(
                      //                   'Giảm giá',
                      //                   style: Get.textTheme.bodyMedium,
                      //                 ),
                      //               ),
                      //             ),
                      //             Expanded(
                      //               flex: 2,
                      //               child: Align(
                      //                 alignment: Alignment.centerRight,
                      //                 child: Text(
                      //                   'Tổng',
                      //                   style: Get.textTheme.bodyMedium,
                      //                 ),
                      //               ),
                      //             ),
                      //           ],
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      // Divider(
                      //   color: Get.theme.colorScheme.onSurface,
                      //   thickness: 1,
                      // ),
                      Text(
                        'Doanh thu bán hàng',
                        style: Get.textTheme.bodyLarge,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Doanh thu trước giảm giá (1)',
                            style: Get.textTheme.bodyMedium,
                          ),
                          Text(
                            formatPrice(reportDetails?.totalAmount ?? 0),
                            style: Get.textTheme.bodyMedium,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Giảm giá (2)=(2.1)+(2.2)',
                            style: Get.textTheme.bodyMedium,
                          ),
                          Text(
                            formatPrice(reportDetails?.totalDiscount ?? 0),
                            style: Get.textTheme.bodyMedium,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Chương trình khuyến mãi(2.1)',
                            style: Get.textTheme.bodyMedium,
                          ),
                          Text(
                            formatPrice(
                                reportDetails?.totalPromotionDiscount ?? 0),
                            style: Get.textTheme.bodyMedium,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Giảm giá sản phẩm(2.2)',
                            style: Get.textTheme.bodyMedium,
                          ),
                          Text(
                            formatPrice(
                                reportDetails?.totalProductDiscount ?? 0),
                            style: Get.textTheme.bodyMedium,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Doanh thu sau giảm giá(3)=(1)-(2)',
                            style: Get.textTheme.bodyMedium,
                          ),
                          Text(
                            formatPrice(reportDetails?.finalAmount ?? 0),
                            style: Get.textTheme.bodyMedium,
                          ),
                        ],
                      ),
                      Text(
                        'Hình thức mua hàng',
                        style: Get.textTheme.bodyLarge,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Đơn tại quán',
                            style: Get.textTheme.bodyMedium,
                          ),
                          Text(
                            "${reportDetails?.totalOrderInStore ?? 0}",
                            style: Get.textTheme.bodyMedium,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Đơn mang đi',
                            style: Get.textTheme.bodyMedium,
                          ),
                          Text(
                            "${reportDetails?.totalOrderTakeAway ?? 0}",
                            style: Get.textTheme.bodyMedium,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Đơn giao hàng',
                            style: Get.textTheme.bodyMedium,
                          ),
                          Text(
                            "${reportDetails?.totalOrderDeli ?? 0}",
                            style: Get.textTheme.bodyMedium,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Doanh thu Tại quán',
                            style: Get.textTheme.bodyMedium,
                          ),
                          Text(
                            formatPrice(reportDetails?.inStoreAmount ?? 0),
                            style: Get.textTheme.bodyMedium,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Doanh thu Mang đi',
                            style: Get.textTheme.bodyMedium,
                          ),
                          Text(
                            formatPrice(reportDetails?.takeAwayAmount ?? 0),
                            style: Get.textTheme.bodyMedium,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Doanh thu Giao hàng',
                            style: Get.textTheme.bodyMedium,
                          ),
                          Text(
                            formatPrice(reportDetails?.deliAmount ?? 0),
                            style: Get.textTheme.bodyMedium,
                          ),
                        ],
                      ),
                      Text(
                        'Hình thức thanh toán',
                        style: Get.textTheme.bodyLarge,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Đơn tiền mặt',
                            style: Get.textTheme.bodyMedium,
                          ),
                          Text(
                            "${reportDetails?.totalCash ?? 0}",
                            style: Get.textTheme.bodyMedium,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Đơn chyển khoản',
                            style: Get.textTheme.bodyMedium,
                          ),
                          Text(
                            "${reportDetails?.totalBanking ?? 0}",
                            style: Get.textTheme.bodyMedium,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Đơn Momo',
                            style: Get.textTheme.bodyMedium,
                          ),
                          Text(
                            "${reportDetails?.totalMomo ?? 0}",
                            style: Get.textTheme.bodyMedium,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Đơn Visa',
                            style: Get.textTheme.bodyMedium,
                          ),
                          Text(
                            "${reportDetails?.totalVisa ?? 0}",
                            style: Get.textTheme.bodyMedium,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Doanh thu Tiền mặt',
                            style: Get.textTheme.bodyMedium,
                          ),
                          Text(
                            formatPrice(reportDetails?.cashAmount ?? 0),
                            style: Get.textTheme.bodyMedium,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Doanh thu Chuyển khoản',
                            style: Get.textTheme.bodyMedium,
                          ),
                          Text(
                            formatPrice(reportDetails?.bankingAmount ?? 0),
                            style: Get.textTheme.bodyMedium,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Doanh thu Momo',
                            style: Get.textTheme.bodyMedium,
                          ),
                          Text(
                            formatPrice(reportDetails?.momoAmount ?? 0),
                            style: Get.textTheme.bodyMedium,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Doanh thu Visa',
                            style: Get.textTheme.bodyMedium,
                          ),
                          Text(
                            formatPrice(reportDetails?.visaAmount ?? 0),
                            style: Get.textTheme.bodyMedium,
                          ),
                        ],
                      ),
                      Text(
                        'Đơn hàng',
                        style: Get.textTheme.bodyLarge,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Tổng số sản phẩm',
                            style: Get.textTheme.bodyMedium,
                          ),
                          Text(
                            "${reportDetails?.totalProduct ?? 0}",
                            style: Get.textTheme.bodyMedium,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Tổng số đơn hoàn thành (6)',
                            style: Get.textTheme.bodyMedium,
                          ),
                          Text(
                            "${reportDetails?.totalOrder ?? 0}",
                            style: Get.textTheme.bodyMedium,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Tổng số khuyến mãi sử dụng',
                            style: Get.textTheme.bodyMedium,
                          ),
                          Text(
                            "${reportDetails?.totalPromotionUsed ?? 0}",
                            style: Get.textTheme.bodyMedium,
                          ),
                        ],
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Nguời lập phiếu',
                            style: Get.textTheme.bodyMedium,
                          ),
                          Text(
                            account?.name ?? "Staff",
                            style: Get.textTheme.bodyMedium,
                          ),
                        ],
                      ),
                      Text(
                        "Nguời lập phiếu: ${account?.name ?? "Staff"}",
                        style: Get.textTheme.titleSmall,
                      ),
                      Text(
                        "Ngày lập phiếu: ${formatOnlyDate(DateTime.now().toIso8601String())}",
                        style: Get.textTheme.titleSmall,
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      Get.find<PrinterViewModel>().printEndDayStoreReport(
                        reportDetails!,
                        "Báo cáo ngày ${formatOnlyDate(startDate.toIso8601String())}",
                      );
                    },
                    child: Text(
                      "In báo cáo",
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }),
    ),
  ));
}

// Widget categoryReportItem(CategoryReports item) {
//   return Padding(
//     padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
//     child: Column(
//       children: [
//         Divider(
//           color: Get.theme.colorScheme.onSurface,
//           thickness: 0.5,
//         ),
//         Row(
//           textDirection: TextDirection.ltr,
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Expanded(
//               flex: 8,
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     item.name!,
//                     style: Get.textTheme.bodyLarge,
//                     maxLines: 2,
//                     overflow: TextOverflow.clip,
//                   ),
//                 ],
//               ),
//             ),
//             Expanded(
//               flex: 1,
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Text(
//                     "${item.totalProduct}",
//                     style: Get.textTheme.bodyLarge,
//                   ),
//                 ],
//               ),
//             ),
//             Expanded(
//               flex: 2,
//               child: Align(
//                 alignment: AlignmentDirectional.centerEnd,
//                 child: Text(
//                   formatPrice(item.totalDiscount!),
//                   style: Get.textTheme.bodyLarge,
//                 ),
//               ),
//             ),
//             Expanded(
//               flex: 2,
//               child: Align(
//                 alignment: AlignmentDirectional.centerEnd,
//                 child: Text(
//                   formatPrice(item.totalAmount!),
//                   style: Get.textTheme.bodyLarge,
//                 ),
//               ),
//             ),
//           ],
//         ),
//         ListView.builder(
//           shrinkWrap: true,
//           itemCount: item.productReports?.length,
//           physics: ScrollPhysics(),
//           itemBuilder: (context, i) {
//             return Padding(
//               padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Expanded(
//                     flex: 8,
//                     child: Text(
//                       "- ${item.productReports![i].name}",
//                       style: Get.textTheme.bodyMedium,
//                     ),
//                   ),
//                   Expanded(
//                     flex: 1,
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         Text(
//                           "${item.productReports![i].quantity}",
//                           style: Get.textTheme.bodyLarge,
//                         ),
//                       ],
//                     ),
//                   ),
//                   Expanded(
//                     flex: 2,
//                     child: Align(
//                       alignment: AlignmentDirectional.centerEnd,
//                       child: Text(
//                         formatPrice(item.productReports![i].totalDiscount ?? 0),
//                         style: Get.textTheme.bodyLarge,
//                       ),
//                     ),
//                   ),
//                   Expanded(
//                     flex: 2,
//                     child: Align(
//                       alignment: AlignmentDirectional.centerEnd,
//                       child: Text(
//                         formatPrice(item.productReports![i].totalAmount!),
//                         style: Get.textTheme.bodyMedium,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           },
//         ),
//       ],
//     ),
//   );
// }
