import 'package:json_annotation/json_annotation.dart';
part 'userInfo.g.dart';

// ------------------------------------------------------
// author: whr    除本人外请勿更改，如果确有必要，请征得本人同意
// date  : 2020/4/7 12:19
// usage : 用戶基本信息
//
// ------------------------------------------------------

@JsonSerializable()
class UserInfo {
  String addr_area;
  String addr_city;
  String addr_link_man;
  String addr_mobile;
  String addr_province;
  String addr_street;
  String area;
  num birth_day;
  num birth_month;
  num birth_year;
  String city;
  String country;
  String created_at;
  bool enabled;
  String icon;
  num id;
  String id_card;
  String mobile;
  bool mobile_login_default;
  String nick;
  String province;
  String pwd;
  num sex;
  String update_at;
  String user_code;
  String user_name;

  UserInfo(
      {this.addr_area,
      this.addr_city,
      this.addr_link_man,
      this.addr_mobile,
      this.addr_province,
      this.addr_street,
      this.area,
      this.birth_day,
      this.birth_month,
      this.birth_year,
      this.city,
      this.country,
      this.created_at,
      this.enabled,
      this.icon,
      this.id,
      this.id_card,
      this.mobile,
      this.mobile_login_default,
      this.nick,
      this.province,
      this.pwd,
      this.sex,
      this.update_at,
      this.user_code,
      this.user_name});

  factory UserInfo.fromJson(Map<String, dynamic> json) =>
      _$UserInfoFromJson(json);

  Map<String, dynamic> toJson() => _$UserInfoToJson(this);
}
