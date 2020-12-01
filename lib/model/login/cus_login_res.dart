import 'package:yiapp/util/us_util.dart';
import 'login_result.dart';
import 'modules.dart';
import 'userInfo.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/11/6 14:30
// usage ：自定义本地数据库中存储的格式 28个字段
// ------------------------------------------------------

// 注：这里的 is_admin、is_broker_admin、is_master、enabled 原来都为 bool 类型
// 因为在 sqlite 中，会自动将 BLOB 类型转换为 INTEGER 类型，所以这里直接用 int 处理
// id 改成了 uid
class CusLoginRes {
  int id;
  num uid;
  int is_admin;
  int is_broker_admin;
  int is_master;
  String jwt;
  // modules
  int enable_mall;
  int enable_master;
  int enable_prize;
  int enable_vie;
  // user_info
  String area;
  num birth_day;
  num birth_month;
  num birth_year;
  num broker_id;
  String city;
  String country;
  String created_at;
  num enabled;
  String icon;
  String id_card;
  String nick;
  String province;
  String pwd;
  num sex;
  String update_at;
  String user_code;
  String user_name;
  num ver;

  CusLoginRes({
    this.id,
    this.uid,
    this.is_admin,
    this.is_broker_admin,
    this.is_master,
    this.jwt,
    // modules
    this.enable_mall,
    this.enable_master,
    this.enable_prize,
    this.enable_vie,
    // user_info
    this.area,
    this.birth_day,
    this.birth_month,
    this.birth_year,
    this.broker_id,
    this.city,
    this.country,
    this.created_at,
    this.enabled,
    this.icon,
    this.id_card,
    this.nick,
    this.province,
    this.pwd,
    this.sex,
    this.update_at,
    this.user_code,
    this.user_name,
    this.ver,
  });

  factory CusLoginRes.fromJson(Map<String, dynamic> json) {
    return CusLoginRes(
      uid: json['uid'],
      is_admin: json['is_admin'],
      is_broker_admin: json['is_broker_admin'],
      is_master: json['is_master'],
      jwt: json['jwt'],
      // modules
      enable_mall: json['enable_mall'],
      enable_master: json['enable_master'],
      enable_prize: json['enable_prize'],
      enable_vie: json['enable_vie'],
      // user_info
      area: json['area'],
      birth_day: json['birth_day'],
      birth_month: json['birth_month'],
      birth_year: json['birth_year'],
      broker_id: json['broker_id'],
      city: json['city'],
      country: json['country'],
      created_at: json['created_at'],
      enabled: json['enabled'],
      icon: json['icon'],
      id_card: json['id_card'],
      nick: json['nick'],
      province: json['province'],
      pwd: json['pwd'],
      sex: json['sex'],
      update_at: json['update_at'],
      user_code: json['user_code'],
      user_name: json['user_name'],
      ver: json['ver'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['uid'] = this.uid;
    data['is_admin'] = this.is_admin;
    data['is_broker_admin'] = this.is_broker_admin;
    data['is_master'] = this.is_master;
    data['jwt'] = this.jwt;
    // modules
    data['enable_mall'] = this.enable_mall;
    data['enable_master'] = this.enable_master;
    data['enable_prize'] = this.enable_prize;
    data['enable_vie'] = this.enable_vie;
    // user_info
    data['area'] = this.area;
    data['birth_day'] = this.birth_day;
    data['birth_month'] = this.birth_month;
    data['birth_year'] = this.birth_year;
    data['broker_id'] = this.broker_id;
    data['city'] = this.city;
    data['country'] = this.country;
    data['created_at'] = this.created_at;
    data['enabled'] = this.enabled;
    data['icon'] = this.icon;
    data['id_card'] = this.id_card;
    data['nick'] = this.nick;
    data['province'] = this.province;
    data['pwd'] = this.pwd;
    data['sex'] = this.sex;
    data['update_at'] = this.update_at;
    data['user_code'] = this.user_code;
    data['user_name'] = this.user_name;
    data['ver'] = this.ver;
    return data;
  }

  /// 将从服务器获取到的数据 LoginResult 转换为本地数据库 LoginTable
  static CusLoginRes from(LoginResult r) {
    Modules m = r.modules ??
        Modules(
          enable_mall: 0,
          enable_master: 0,
          enable_prize: 0,
          enable_vie: 0,
        );
    UserInfo u = r.user_info;
    return CusLoginRes(
      is_admin: UsUtil.toInt(r.is_admin),
      is_broker_admin: UsUtil.toInt(r.is_broker_admin),
      is_master: UsUtil.toInt(r.is_master),
      jwt: r.jwt,
      enable_mall: m.enable_mall,
      enable_master: m.enable_master,
      enable_prize: m.enable_prize,
      enable_vie: m.enable_vie,
      area: u.area,
      birth_day: u.birth_day,
      birth_month: u.birth_month,
      birth_year: u.birth_year,
      broker_id: u.broker_id,
      city: u.city,
      country: u.country,
      created_at: u.created_at,
      enabled: UsUtil.toInt(u.enabled),
      icon: u.icon,
      uid: u.id,
      id_card: u.id_card,
      nick: u.nick,
      province: u.province,
      pwd: u.pwd,
      sex: u.sex,
      update_at: u.update_at,
      user_code: u.user_code,
      user_name: u.user_name,
      ver: u.ver,
    );
  }
}
