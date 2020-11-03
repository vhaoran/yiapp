import 'package:yiapp/complex/tools/cus_tool.dart';
import 'package:yiapp/model/login/userInfo.dart';
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
      modules:
          json['modules'] != null ? Modules.fromJson(json['modules']) : null,
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
}
