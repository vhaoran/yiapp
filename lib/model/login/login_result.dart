import 'dart:convert';
import 'package:yiapp/model/friends/friend.dart';
import 'package:yiapp/model/group/group.dart';
import 'package:yiapp/model/user/userInfo.dart';

// ------------------------------------------------------
// author: whr    除本人外请勿更改，如果确有必要，请征得本人同意
// date  : 2020/4/3 11:38
// usage : 登录成功后的返回数据
//
// ------------------------------------------------------

class LoginResult {
  UserInfo user_info;
  List<Group> groups;
  List<Friend> friends;
  String jwt;

  LoginResult.fromJson(Map<String, dynamic> m)
      : jwt = m['jwt'],
        user_info = UserInfo.fromJson(m['user_info']),
        groups = (m['groups'] as List).map((x) => Group.fromJson(x)).toList(),
        friends =
            (m['friends'] as List).map((x) => Friend.fromJson(x)).toList();

  Map<String, dynamic> toJson() => {
        'user_info': jsonEncode(user_info),
        'groups': jsonEncode(groups),
        'friends': jsonEncode(friends),
      };
}
