import 'package:scoped_model/scoped_model.dart';

import '../enums/view_status.dart';

class BaseViewModel extends Model {
  ViewStatus _status = ViewStatus.Completed;
  late String _msg;
  ViewStatus get status => _status;
  String get msg => _msg;

  void setState(ViewStatus newState, [String? msg]) {
    _status = newState;
    _msg = msg!;
    notifyListeners();
  }
}
