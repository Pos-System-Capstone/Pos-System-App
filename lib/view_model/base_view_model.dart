import 'package:scoped_model/scoped_model.dart';

import '../enums/view_status.dart';

class BaseViewModel extends Model {
  ViewStatus status = ViewStatus.Completed;
  late String? msg;

  void setState(ViewStatus newState, [String? msg]) {
    status = newState;
    msg = msg;
    notifyListeners();
  }
}
