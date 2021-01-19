// ------------------------------------------------------
// author：suxing
// date  ：2020/9/14 17:45
// usage ：用户身份状态
// ------------------------------------------------------

import 'package:package_info/package_info.dart';

class CusRole {
  // 是否游客登录(非会员、大师、运营商、系统管理员)
  static bool is_guest = true;

  // 是否大师
  static bool is_master = false;

  // 是否系统管理员
  static bool is_admin = false;

  // 是否运营商、或者运营商管理员
  static bool is_broker_admin = false;

  // 是否已经绑定过邀请码，绑定过邀请码的被称为会员
  static bool is_vip = false;

  // 运营商的 broker_id
  static num broker_id = 0;

  // 是否闪断帖
  static bool isVie = false;

  // 运营商服务码
  static String service_code = "";

  // app 信息
  static PackageInfo packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
  );
}
