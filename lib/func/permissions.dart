import 'package:permission_handler/permission_handler.dart';
import 'package:yiapp/cus/cus_log.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/8/20 10:21
// usage ：获取系统权限
// ------------------------------------------------------

class Permissions {
  static requestAll() async {
    try {
      Map<Permission, PermissionStatus> status = await [
        Permission.locationAlways,
        Permission.storage,
        Permission.camera,
        Permission.contacts,
        Permission.photos,
        Permission.phone,
        Permission.notification,
        Permission.activityRecognition,
      ].request();
//      status.forEach((key, value) {
//        Log.info("权限 key:$key、权限 value:${value == PermissionStatus.granted}");
//      });
    } catch (e) {
      Log.error("获取系统权限出现异常");
    }
  }
}
