import 'package:yiapp/model/login/modules.dart';
import 'package:yiapp/model/login/userInfo.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/11/6 14:23
// usage ：默认设置项
// ------------------------------------------------------

/// 默认 UserInfo
UserInfo defaultUser = UserInfo.fromJson({
  "area": "",
  "birth_day": 0,
  "birth_month": 0,
  "birth_year": 0,
  "broker_id": 0,
  "city": "",
  "country": "",
  "created_at": "",
  "enabled": true,
  "icon": "",
  "id": 0,
  "id_card": "",
  "nick": "游客",
  "province": "",
  "pwd": "",
  "sex": 0,
  "update_at": "",
  "user_code": "",
  "user_name": "游客"
});

/// 默认服务模块
Modules defaultModules = Modules.fromJson(
  {
    "enable_mall": 0,
    "enable_master": 0,
    "enable_prize": 0,
    "enable_vie": 0,
  },
);
