import 'package:pos_apps/model/index.dart';
import 'package:pos_apps/view_model/index.dart';

import '../data/index.dart';
import '../enums/view_status.dart';

class MenuViewModel extends BaseViewModel {
  late Menu? _currentMenu;
  late List<Product> listProduct;
  late List<Category> listCategory;
  late List<Collection> listCollection;

  MenuData? menuData;

  MenuViewModel() {
    menuData = MenuData();
  }

  Future<void> getMenuOfStore() async {
    setState(ViewStatus.Loading);
    _currentMenu = await menuData?.getMenuOfStore();
    listProduct = _currentMenu!.products!;
    listCategory = _currentMenu!.categories!;
    listCollection = _currentMenu!.collections!;
    setState(ViewStatus.Completed);
  }
}
