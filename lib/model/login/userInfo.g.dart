// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'userInfo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserInfo _$UserInfoFromJson(Map<String, dynamic> json) {
  return UserInfo(
      addr_area: json['addr_area'] as String,
      addr_city: json['addr_city'] as String,
      addr_link_man: json['addr_link_man'] as String,
      addr_mobile: json['addr_mobile'] as String,
      addr_province: json['addr_province'] as String,
      addr_street: json['addr_street'] as String,
      area: json['area'] as String,
      birth_day: json['birth_day'] as num,
      birth_month: json['birth_month'] as num,
      birth_year: json['birth_year'] as num,
      city: json['city'] as String,
      country: json['country'] as String,
      created_at: json['created_at'] as String,
      enabled: json['enabled'] as bool,
      icon: json['icon'] as String,
      id: json['id'] as num,
      id_card: json['id_card'] as String,
      mobile: json['mobile'] as String,
      mobile_login_default: json['mobile_login_default'] as bool,
      nick: json['nick'] as String,
      province: json['province'] as String,
      pwd: json['pwd'] as String,
      sex: json['sex'] as num,
      update_at: json['update_at'] as String,
      user_code: json['user_code'] as String,
      user_name: json['user_name'] as String);
}

Map<String, dynamic> _$UserInfoToJson(UserInfo instance) => <String, dynamic>{
      'addr_area': instance.addr_area,
      'addr_city': instance.addr_city,
      'addr_link_man': instance.addr_link_man,
      'addr_mobile': instance.addr_mobile,
      'addr_province': instance.addr_province,
      'addr_street': instance.addr_street,
      'area': instance.area,
      'birth_day': instance.birth_day,
      'birth_month': instance.birth_month,
      'birth_year': instance.birth_year,
      'city': instance.city,
      'country': instance.country,
      'created_at': instance.created_at,
      'enabled': instance.enabled,
      'icon': instance.icon,
      'id': instance.id,
      'id_card': instance.id_card,
      'mobile': instance.mobile,
      'mobile_login_default': instance.mobile_login_default,
      'nick': instance.nick,
      'province': instance.province,
      'pwd': instance.pwd,
      'sex': instance.sex,
      'update_at': instance.update_at,
      'user_code': instance.user_code,
      'user_name': instance.user_name
    };
