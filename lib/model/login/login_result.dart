import 'package:yiapp/complex/function/def_obj.dart';
import 'package:yiapp/complex/function/type_change.dart';
import 'package:yiapp/model/login/userInfo.dart';
import 'login_table.dart';
import 'modules.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/9/7 16:06
// usage ：登录结果
// ------------------------------------------------------

class LoginResult {
  bool is_admin;
  bool is_broker_admin;
  bool is_master;
  String jwt;
  UserInfo user_info;
  Modules modules;

  LoginResult({
    this.is_admin,
    this.is_broker_admin,
    this.is_master,
    this.jwt,
    this.user_info,
    this.modules,
  });

  factory LoginResult.fromJson(Map<String, dynamic> json) {
    return LoginResult(
      is_admin: json['is_admin'],
      is_broker_admin: json['is_broker_admin'],
      is_master: json['is_master'],
      jwt: json['jwt'],
      user_info: json['user_info'] != null
          ? UserInfo.fromJson(json['user_info'])
          : defaultUser,
      modules: json['modules'] != null
          ? Modules.fromJson(json['modules'])
          : defaultModules,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['is_admin'] = this.is_admin;
    data['is_broker_admin'] = this.is_broker_admin;
    data['is_master'] = this.is_master;
    data['jwt'] = this.jwt;
    if (this.user_info != null) {
      data['user_info'] = this.user_info.toJson();
    }
    if (this.modules != null) {
      data['modules'] = this.modules.toJson();
    }
    return data;
  }

  /// 将本地数据库 LoginTable 转换为服务器接收的格式 LoginResult
  static LoginResult from(CusLoginRes t) {
    Modules m = Modules(
      enable_mall: t.enable_mall,
      enable_master: t.enable_master,
      enable_prize: t.enable_prize,
      enable_vie: t.enable_vie,
    );
    UserInfo u = UserInfo(
      area: t.area,
      birth_day: t.birth_day,
      birth_month: t.birth_month,
      birth_year: t.birth_year,
      broker_id: t.broker_id,
      city: t.city,
      country: t.country,
      created_at: t.created_at,
      enabled: toBool(t.enabled),
      icon: t.icon,
      id: t.uid,
      id_card: t.id_card,
      nick: t.nick,
      province: t.province,
      pwd: t.pwd,
      sex: t.sex,
      update_at: t.update_at,
      user_code: t.user_code,
      user_name: t.user_name,
      ver: t.ver,
    );
    return LoginResult(
      is_admin: toBool(t.is_admin),
      is_broker_admin: toBool(t.is_broker_admin),
      is_master: toBool(t.is_master),
      jwt: t.jwt,
      modules: m,
      user_info: u,
    );
  }
}
