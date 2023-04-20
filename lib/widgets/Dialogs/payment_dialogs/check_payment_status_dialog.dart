import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../../view_model/order_view_model.dart';

void paymentStatusDialog(String orderId, String paymentStatus) {
  Get.dialog(
    Dialog(
      child: ScopedModel(
        model: Get.find<OrderViewModel>(),
        child: ScopedModelDescendant<OrderViewModel>(
            builder: (context, build, model) {
          String status = '';
          if (model.paymentStatus == null) {
            status = 'Đang xử lý';
          }
          return StreamBuilder<String>(
              stream: Stream.periodic(Duration(seconds: 2))
                  .asyncMap((i) => model.checkPaymentStatus(orderId)),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return SizedBox(
                    height: Get.size.height * 0.6,
                    width: Get.size.width * 0.8,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          status,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          paymentStatus,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  return SizedBox(
                    height: Get.size.height * 0.6,
                    width: Get.size.width * 0.8,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Please wait...",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          paymentStatus,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  );
                }
              });
        }),
      ),
    ),
  );
}
