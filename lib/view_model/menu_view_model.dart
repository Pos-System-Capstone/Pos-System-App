import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_apps/data/api/store_data.dart';
import 'package:pos_apps/data/model/index.dart';
import 'package:pos_apps/data/model/response/session_details.dart';
import 'package:pos_apps/data/model/response/store.dart';
import 'package:pos_apps/view_model/index.dart';
import 'package:pos_apps/view_model/printer_view_model.dart';

import '../Widgets/Dialogs/other_dialogs/dialog.dart';
import '../Widgets/Dialogs/printer_dialogs/add_printer_dialog.dart';
import '../data/api/index.dart';
import '../data/api/session_data.dart';
import '../data/model/response/sessions.dart';
import '../enums/order_enum.dart';
import '../enums/product_enum.dart';
import '../enums/view_status.dart';
import '../util/share_pref.dart';

class MenuViewModel extends BaseViewModel {
  late Menu? currentMenu;
  MenuData? menuData;
  StoreData? storeData;
  StoreModel storeDetails = StoreModel();
  List<Product>? normalProducts = [];
  List<Category>? categories = [];
  List<Product>? extraProducts = [];
  List<Product>? childProducts = [];
  List<Product>? productsFilter = [];
  List<Session>? sessions = [];
  SessionAPI? sessionAPI;

  MenuViewModel() {
    menuData = MenuData();
    storeData = StoreData();
    currentMenu = Menu();
    sessionAPI = SessionAPI();
  }

  Future<void> getMenuOfStore() async {
    try {
      setState(ViewStatus.Loading);
      getStore();
      getListSession();
      currentMenu = await menuData?.getMenuOfStore();
      Get.find<OrderViewModel>().getListPayment();
      await getStore();
      categories = currentMenu?.categories!
          .where((element) => element.type == CategoryTypeEnum.Normal)
          .toList();
      normalProducts = currentMenu?.products!
          .where((element) =>
              element.type == ProductTypeEnum.SINGLE ||
              element.type == ProductTypeEnum.PARENT)
          .toList();
      extraProducts = currentMenu?.products!
          .where((element) => element.type == ProductTypeEnum.EXTRA)
          .toList();
      childProducts = currentMenu?.products!
          .where((element) => element.type == ProductTypeEnum.CHILD)
          .toList();
      productsFilter = normalProducts;

      setState(ViewStatus.Completed);
    } catch (e) {
      setState(ViewStatus.Error, e.toString());
    }
  }

  Future<void> getStore() async {
    try {
      setState(ViewStatus.Loading);
      await storeData?.getStoreDetail().then((value) {
        storeDetails = value!;
      });
      setState(ViewStatus.Completed);
    } catch (e) {
      setState(ViewStatus.Error, e.toString());
    }
  }

  void getListSession() async {
    try {
      setState(ViewStatus.Loading);
      await sessionAPI?.getListSessionOfStore().then((value) {
        sessions = value;
      });
      setState(ViewStatus.Completed);
    } catch (e) {
      setState(ViewStatus.Error, e.toString());
    }
  }

  Future<SessionDetails?> getSessionDetail(String sessionId) async {
    try {
      setState(ViewStatus.Loading);
      SessionDetails? sessionDetails =
          await sessionAPI?.getSessionDetails(sessionId);
      setState(ViewStatus.Completed);
      return sessionDetails!;
    } catch (e) {
      setState(ViewStatus.Error, e.toString());
      return null;
    }
  }

  void printCloseSessionInvoice(SessionDetails session) async {
    try {
      setState(ViewStatus.Loading);
      Account? userInfo = await getUserInfo();
      if (Get.find<PrinterViewModel>().selectedBillPrinter != null) {
        Get.find<PrinterViewModel>()
            .printCloseSessionInvoice(session, storeDetails, userInfo!);
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

  void handleChangeFilterProductByCategory(String? categoryId) {
    if (categoryId == null) {
      productsFilter = normalProducts;
      notifyListeners();
    } else {
      productsFilter = normalProducts
          ?.where((element) => element.categoryId == categoryId)
          .toList();
      notifyListeners();
    }
  }

  List<Product>? getChildProductByParentProduct(String? productId) {
    List<Product> listChilds = childProducts!
        .where((element) => element.parentProductId == productId)
        .toList();

    List<Product> listChildsSorted = [];
    for (Product item in listChilds) {
      if (item.size == ProductSizeEnum.SMALL) {
        listChildsSorted.add(item);
      }
    }
    for (Product item in listChilds) {
      if (item.size == ProductSizeEnum.MEDIUM) {
        listChildsSorted.add(item);
      }
    }
    for (Product item in listChilds) {
      if (item.size == ProductSizeEnum.LARGE) {
        listChildsSorted.add(item);
      }
    }
    return listChildsSorted;
  }

  List<Product>? getExtraProductByNormalProduct(Product product) {
    return extraProducts
        ?.where(
            (element) => product.extraCategoryIds!.contains(element.categoryId))
        .toList();
  }

  List<Category>? getExtraCategoryByNormalProduct(Product product) {
    List<Category> listExtraCategory = [];
    for (Category item in currentMenu!.categories!) {
      if (product.extraCategoryIds!.contains(item.id)) {
        listExtraCategory.add(item);
      }
    }
    return listExtraCategory;
  }

  List<Product> getProductsByCategory(String? categoryId) {
    return extraProducts!
        .where((element) => element.categoryId == categoryId)
        .toList();
  }
}
