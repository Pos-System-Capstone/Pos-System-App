import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_apps/enums/order_enum.dart';
import 'package:pos_apps/view_model/order_view_model.dart';
import 'package:pos_apps/widgets/order_process/booking_table.dart';
import 'package:scoped_model/scoped_model.dart';

import '../widgets/order_process/choose_delivery_type.dart';
import '../widgets/order_process/orders.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late int _activeCurrentStep;
  late OrderViewModel _orderViewModel;
  @override
  initState() {
    super.initState();
    _activeCurrentStep = 0;
    _orderViewModel = Get.find<OrderViewModel>();
  }

  @override
  Widget build(BuildContext context) {
    List<Step> steps = [
      Step(
        state: _activeCurrentStep <= 0 ? StepState.editing : StepState.complete,
        title: const Text('Hình thức giao hàng'),
        content: ChooseDeliveryTypeScreen(),
        isActive: _orderViewModel.deliveryType != DeliTypeEnum.NONE,
      ),
      Step(
        state: _activeCurrentStep <= 1 ? StepState.editing : StepState.complete,
        title: const Text('Chọn bàn'),
        content: BookingTableScreen(),
        isActive: _orderViewModel.selectedTable != 0,
      ),
      Step(
        state: _activeCurrentStep <= 2 ? StepState.editing : StepState.complete,
        title: Text('Chọn món'),
        content: OrderScreen(),
        isActive: _activeCurrentStep >= 2,
      ),
      Step(
        state: _activeCurrentStep <= 3 ? StepState.editing : StepState.complete,
        title: const Text('Thanh toán'),
        content: Container(),
        isActive: _activeCurrentStep >= 3,
      ),
    ];

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ScopedModel(
            model: Get.find<OrderViewModel>(),
            // child: Stepper(
            //   physics: ScrollPhysics(),
            //   controlsBuilder: (BuildContext context, ControlsDetails details) {
            //     return Padding(
            //       padding: const EdgeInsets.only(top: 8.0),
            //       child: Row(
            //         crossAxisAlignment: CrossAxisAlignment.end,
            //         mainAxisAlignment: MainAxisAlignment.start,
            //         children: <Widget>[
            //           ElevatedButton(
            //             style: ElevatedButton.styleFrom(
            //               // Foreground color
            //               // ignore: deprecated_member_use
            //               onPrimary: Get.theme.colorScheme.onPrimary,
            //               // Background color
            //               // ignore: deprecated_member_use
            //               primary: Get.theme.colorScheme.error,
            //             ),
            //             onPressed: details.onStepCancel,
            //             child: Text(
            //               'Quay lại',
            //               style: TextStyle(fontSize: 20),
            //             ),
            //           ),
            //           SizedBox(width: 16),
            //           ElevatedButton(
            //             style: ElevatedButton.styleFrom(
            //               // Foreground color
            //               // ignore: deprecated_member_use
            //               onPrimary: Get.theme.colorScheme.onPrimary,

            //               // Background color
            //               // ignore: deprecated_member_use
            //               primary: Get.theme.colorScheme.primary,
            //             ).copyWith(elevation: ButtonStyleButton.allOrNull(0.0)),
            //             onPressed: details.onStepContinue,
            //             child: Text(
            //               'Tiếp tục',
            //               style: TextStyle(fontSize: 20),
            //             ),
            //           ),
            //         ],
            //       ),
            //     );
            //   },
            //   margin: EdgeInsets.only(top: -20),
            //   steps: steps,
            //   currentStep: _activeCurrentStep,
            //   type: StepperType.horizontal,
            //   onStepContinue: () {
            //     if (_activeCurrentStep < (steps.length - 1)) {
            //       setState(() {
            //         _activeCurrentStep += 1;
            //       });
            //     }
            //   },
            //   onStepCancel: () {
            //     if (_activeCurrentStep == 0) {
            //       return;
            //     }
            //     setState(() {
            //       _activeCurrentStep -= 1;
            //       // _orderViewModel.clearOrderState();
            //     });
            //   },
            //   onStepTapped: (int index) {
            //     setState(() {
            //       _activeCurrentStep = index;
            //     });
            //   },
            // )

            child: ScopedModelDescendant<OrderViewModel>(
              builder: (context, child, model) {
                return model.currentState == OrderStateEnum.CHOOSE_ORDER_TYPE
                    ? ChooseDeliveryTypeScreen()
                    : model.currentState == OrderStateEnum.BOOKING_TABLE
                        ? BookingTableScreen()
                        : model.currentState == OrderStateEnum.ORDER_PRODUCT
                            ? OrderScreen()
                            : model.currentState == OrderStateEnum.PAYMENT
                                ? Container()
                                : Container();
              },
            )),
      ),
    );
  }
}
