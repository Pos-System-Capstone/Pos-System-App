import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scoped_model/scoped_model.dart';
import '../../../../../view_model/index.dart';
import '../../../../widgets/cart/membership.dart';
import '../../../../widgets/cart/promotion.dart';
import '../../../../widgets/other_dialogs/dialog.dart';

void selectPromotionDialog() {
  Get.dialog(
    PormotionDialog(),
  );
}

class PormotionDialog extends StatefulWidget {
  const PormotionDialog({super.key});

  @override
  State<PormotionDialog> createState() => _PormotionDialogState();
}

class _PormotionDialogState extends State<PormotionDialog> {
  CartViewModel cartViewModel = Get.find<CartViewModel>();
  OrderViewModel orderViewModel = Get.find<OrderViewModel>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 0,
      child: DefaultTabController(
          initialIndex: 0,
          length: 2,
          child: Scaffold(
            appBar: TabBar(
              tabs: const [
                Tab(
                  icon: Icon(Icons.discount),
                  text: "Khuyến mãi",
                ),
                // Tab(
                //   icon: Icon(Icons.payment),
                //   text: "Thanh toán",
                // ),
              ],
            ),
            body: TabBarView(
              children: [
                PromotionSelectWidget(),
                // MembershipWidget(),
                // ScopedModel<OrderViewModel>(
                //   model: orderViewModel,
                //   child: ScopedModelDescendant<OrderViewModel>(
                //       builder: (context, build, model) {
                //     return SingleChildScrollView(
                //       child: Center(
                //         child: Wrap(
                //           crossAxisAlignment: WrapCrossAlignment.center,
                //           alignment: WrapAlignment.center,
                //           children: model.listPayment
                //               .map(
                //                 (e) => Padding(
                //                   padding: const EdgeInsets.all(16),
                //                   child: InkWell(
                //                     onTap: () async {
                //                       model.selectPayment(e);
                //                     },
                //                     child: Card(
                //                       color: model.selectedPaymentMethod == e
                //                           ? Get.theme.colorScheme
                //                               .primaryContainer
                //                           : Get.theme.colorScheme.background,
                //                       child: Padding(
                //                         padding: const EdgeInsets.all(8.0),
                //                         child: Column(
                //                           children: [
                //                             Image.network(
                //                               e!.picUrl!,
                //                               width: 80,
                //                               height: 80,
                //                             ),
                //                             Padding(
                //                               padding: const EdgeInsets.all(4),
                //                               child: Text(
                //                                 e.name!,
                //                               ),
                //                             ),
                //                           ],
                //                         ),
                //                       ),
                //                     ),
                //                   ),
                //                 ),
                //               )
                //               .toList(),
                //         ),
                //       ),
                //     );
                //   }),
                // ),
              ],
            ),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      hideDialog();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text("Đóng"),
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
