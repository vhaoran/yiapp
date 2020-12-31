import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/const/con_string.dart';
import 'package:yiapp/ui/provider/master_state.dart';
import 'package:yiapp/ui/provider/user_state.dart';
import 'package:yiapp/cus/cus_role.dart';
import 'package:yiapp/model/dicts/master-info.dart';
import 'package:yiapp/model/login/cus_login_res.dart';
import 'package:yiapp/model/login/login_result.dart';
import 'package:yiapp/service/api/api-master.dart';
import 'package:yiapp/service/api/api_base.dart';
import 'package:yiapp/service/login/login_utils.dart';
import 'package:yiapp/service/storage_util/prefs/kv_storage.dart';
import 'package:yiapp/service/storage_util/sqlite/login_dao.dart';
import 'package:yiapp/service/storage_util/sqlite/sqlite_init.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/11/11 14:25
// usage ：获取到登录信息后，统一要执行的
// ------------------------------------------------------

class LoginVerify {
  static Future<void> init(LoginResult login, BuildContext context) async {
    await KV.remove(kv_shop); // 清除本地购物车数据
    Log.info("用户登录结果：${login.toJson()}");
    // 初始化全局信息和网络
    await setLoginInfo(login);
    initGlobal(login);
    // 更新本地存储的token
    await KV.setStr(kv_jwt, login.jwt);
    // 在状态管理中初始化用户登录信息
    context.read<UserInfoState>().init(login.user_info);
    // 如果本地数据库有，则更新登录结果
    if ((await LoginDao(glbDB).exists(login.user_info.id))) {
      Log.info("更新本地用户信息：${login.user_info.id}");
      await LoginDao(glbDB).update(CusLoginRes.from(login));
    }
    // 如果本地数据库没有，则存储登录结果
    else {
      Log.info("存储新的用户信息：${login.user_info.id}");
      await LoginDao(glbDB).insert(CusLoginRes.from(login));
    }
    if (CusRole.is_master) await _fetchMaster(context);
  }

  /// 初始化全局信息
  static void initGlobal(LoginResult r) {
    // 大师
    CusRole.is_master = r.is_master;
    // 管理员
    CusRole.is_admin = r.is_admin;
    // 运营商管理员
    CusRole.is_broker_admin = r.is_broker_admin;
    // 邀请码
    CusRole.broker_id = r.user_info.broker_id;
    // 会员
    CusRole.is_vip = r.user_info.broker_id > 0 ? true : false;
    // 游客，指的是指除了其它角色之外的身份
    CusRole.is_guest =
        !CusRole.is_vip && !CusRole.is_master && !CusRole.is_broker_admin;
    CusRole.isVie = false;
  }

  /// 如果是大师，获取大师基本资料
  static Future<void> _fetchMaster(BuildContext context) async {
    Log.info("大师登录");
    try {
      MasterInfo res = await ApiMaster.masterInfoGet(ApiBase.uid);
      if (res != null) {
        context.read<MasterInfoState>().init(res);
      }
    } catch (e) {
      Log.error("获取大师个人信息出现异常：$e");
    }
  }
}
