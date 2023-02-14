import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Get.theme.colorScheme.background,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8), topRight: Radius.circular(8)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                  child: Row(
                    textDirection: TextDirection.ltr,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          'Mã đơn: ABCXYZ',
                          style: Get.textTheme.bodyMedium,
                        ),
                      ),
                      VerticalDivider(),
                      Expanded(
                        flex: 1,
                        child: Text(
                          'Bàn: 01',
                          style: Get.textTheme.bodyMedium,
                        ),
                      ),
                      VerticalDivider(),
                      Expanded(
                        flex: 1,
                        child: Text(
                          'Tại quầy',
                          style: Get.textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(
                  color: Get.theme.colorScheme.onSurface,
                  thickness: 2,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                  child: Row(
                    textDirection: TextDirection.ltr,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Text(
                          'SL',
                          style: Get.textTheme.bodyMedium,
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: Text(
                          'Tên',
                          style: Get.textTheme.bodyMedium,
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          'Size',
                          style: Get.textTheme.bodyMedium,
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                          'Tổng',
                          style: Get.textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(
                  color: Get.theme.colorScheme.onSurface,
                  thickness: 2,
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  productCard(),
                  productCard(),
                  productCard(),
                  productCard(),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(8),
                    bottomRight: Radius.circular(8)),
                color: Get.theme.colorScheme.onInverseSurface,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Số lượng', style: Get.textTheme.titleMedium),
                        Text('10', style: Get.textTheme.titleMedium),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Tổng tiền', style: Get.textTheme.titleLarge),
                        Text('100.000.000d', style: Get.textTheme.titleLarge),
                      ],
                    ),
                  ),
                  Divider(
                    color: Get.theme.colorScheme.onSurface,
                    thickness: 2,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 1,
                          child: IconButton(
                              onPressed: null,
                              icon: Icon(
                                Icons.delete_outlined,
                                size: 48,
                              )),
                        ),
                        Expanded(
                          flex: 3,
                          child: ElevatedButton.icon(
                            onPressed: null,
                            icon: Icon(Icons.print),
                            label: Text('IN HOÁ ĐƠN',
                                style: Get.textTheme.titleLarge),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Get.theme.colorScheme.primary),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget productCard() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
      child: Column(
        children: [
          Row(
            textDirection: TextDirection.ltr,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                child: Text(
                  '10x',
                  style: Get.textTheme.bodyMedium,
                ),
              ),
              Expanded(
                flex: 4,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Milk Coffee',
                      style: Get.textTheme.bodyMedium,
                      maxLines: 2,
                      overflow: TextOverflow.clip,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '35.000d',
                          style: Get.textTheme.bodyMedium,
                        ),
                        Text(
                          "Xóa",
                          style: Get.textTheme.bodyMedium,
                          textAlign: TextAlign.right,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  'M',
                  style: Get.textTheme.bodyMedium,
                ),
              ),
              Expanded(
                flex: 3,
                child: Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: Text(
                    '10.000.000 d',
                    style: Get.textTheme.bodyMedium,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 0, 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: Text(
                    '10x',
                    style: Get.textTheme.bodySmall,
                  ),
                ),
                Expanded(
                  flex: 6,
                  child: Text(
                    'Topping abcxyz',
                    style: Get.textTheme.bodySmall,
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: Text(
                      '1.000.000 d',
                      style: Get.textTheme.bodySmall,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 0, 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: Text(
                    '10x',
                    style: Get.textTheme.bodySmall,
                  ),
                ),
                Expanded(
                  flex: 6,
                  child: Text(
                    'Topping abcxyz',
                    style: Get.textTheme.bodySmall,
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: Text(
                      '1.000.000 d',
                      style: Get.textTheme.bodySmall,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(
            color: Get.theme.colorScheme.onSurface,
            thickness: 1,
          )
        ],
      ),
    );
  }
}
