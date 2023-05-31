import 'package:get/get.dart';
import 'package:pos_apps/data/api/promotion_data.dart';
import 'package:pos_apps/data/api/store_data.dart';
import 'package:pos_apps/data/model/index.dart';
import 'package:pos_apps/data/model/response/promotion.dart';
import 'package:pos_apps/data/model/response/session_detail_report.dart';
import 'package:pos_apps/data/model/response/session_details.dart';
import 'package:pos_apps/data/model/response/store.dart';
import 'package:pos_apps/view_model/index.dart';
import 'package:pos_apps/view_model/printer_view_model.dart';
import '../data/api/index.dart';
import '../data/api/report_data.dart';
import '../data/api/session_data.dart';
import '../data/model/response/sessions.dart';
import '../enums/order_enum.dart';
import '../enums/product_enum.dart';
import '../enums/view_status.dart';
import '../util/share_pref.dart';
import '../views/widgets/other_dialogs/dialog.dart';
import '../views/widgets/printer_dialogs/add_printer_dialog.dart';

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
  List<Promotion>? promotions = [];
  SessionAPI? sessionAPI;
  ReportData? reportData;

  Promotion? selectedPromotion;

  MenuViewModel() {
    menuData = MenuData();
    storeData = StoreData();
    currentMenu = Menu();
    sessionAPI = SessionAPI();
    reportData = ReportData();
  }

  Future<void> getMenuOfStore() async {
    try {
      setState(ViewStatus.Loading);
      await getStore();
      currentMenu = await menuData?.getMenuOfStore();
      // Get.find<OrderViewModel>().getListPayment();
      Get.find<CartViewModel>().getListPromotion();
      getListSession(DateTime.now());
      categories = currentMenu?.categories!
          .where((element) => element.type == CategoryTypeEnum.Normal)
          .toList();
      categories?.sort((a, b) => b.displayOrder!.compareTo(a.displayOrder!));
      normalProducts = currentMenu?.products!
          .where((element) =>
              element.type == ProductTypeEnum.SINGLE ||
              element.type == ProductTypeEnum.PARENT ||
              element.type == ProductTypeEnum.COMBO)
          .toList();
      extraProducts = currentMenu?.products!
          .where((element) => element.type == ProductTypeEnum.EXTRA)
          .toList();
      childProducts = currentMenu?.products!
          .where((element) => element.type == ProductTypeEnum.CHILD)
          .toList();
      productsFilter = normalProducts;
      productsFilter
          ?.sort((a, b) => b.displayOrder!.compareTo(a.displayOrder!));
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

  void getListSession(DateTime date) async {
    try {
      setState(ViewStatus.Loading);
      await sessionAPI?.getListSessionOfStore(date).then((value) {
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

  void handleChangeFilterProductByCategory(String? categoryId) {
    if (categoryId == null) {
      productsFilter = normalProducts;
      productsFilter
          ?.sort((a, b) => b.displayOrder!.compareTo(a.displayOrder!));
      notifyListeners();
    } else {
      productsFilter = normalProducts
          ?.where((element) => element.categoryId == categoryId)
          .toList();
      productsFilter
          ?.sort((a, b) => b.displayOrder!.compareTo(a.displayOrder!));
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

  List<GroupProducts>? getGroupProductByComboProduct(String productId) {
    List<GroupProducts> listGroupProducts = [];
    if (currentMenu?.groupProducts == null) {
      return [];
    } else {
      for (GroupProducts item in currentMenu!.groupProducts!) {
        if (item.comboProductId == productId) {
          listGroupProducts.add(item);
        }
      }
      listGroupProducts.sort((a, b) => b.priority!.compareTo(a.priority!));
      return listGroupProducts;
    }
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

  List<ProductsInGroup> getListProductInGroup(String? groupId) {
    List<ProductsInGroup> listProductInGroup = [];
    if (currentMenu!.productsInGroup == null) {
      return [];
    } else {
      for (ProductsInGroup item in currentMenu!.productsInGroup!) {
        if (item.groupProductId == groupId) {
          listProductInGroup.add(item);
        }
      }
      return listProductInGroup;
    }
  }

  Product getProductById(String id) {
    return currentMenu!.products!.firstWhere((element) => element.id == id);
  }

  Future getStoreEndDayReport(DateTime startDate, DateTime endDate) async {
    try {
      setState(ViewStatus.Loading);
      DayReport storeEndDayReport = DayReport();
      await reportData
          ?.getStoreEndDayReport(startDate, endDate)
          .then((value) => storeEndDayReport = value);
      setState(ViewStatus.Completed);
      return storeEndDayReport;
    } catch (e) {
      setState(ViewStatus.Error, e.toString());
    }
    return null;
  }
}
