import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

import '../data/model/account.dart';
import '../util/share_pref.dart';

FirebaseDatabase database = FirebaseDatabase.instance;

// FirebaseApp secondaryApp = Firebase.app('SecondaryApp');
// FirebaseDatabase database = FirebaseDatabase.instanceFor(app: secondaryApp);

// void writeData() async {
//   Account? userInfo = await getUserInfo();
//   DatabaseReference ref = database.ref("user/${userInfo!.id}");
//   await ref.update({
//     "data": "microsoft.com",
//   });
// }
