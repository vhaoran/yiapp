import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import 'package:yiapp/const/gao_server.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/const/con_string.dart';
import 'package:yiapp/demo/demo_plugin/plugin_main.dart';
import 'package:yiapp/service/api/api-broker.dart';
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
import 'package:yiapp/util/us_util.dart';
import 'package:yiapp/widget/flutter/cus_toast.dart';
import 'package:yiapp/widget/small/cus_loading.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/11/11 14:25
// usage ：登录后需要处理的
// ------------------------------------------------------

class LoginVerify {
  static Future<void> init(LoginResult login, BuildContext context) async {
    // 清除上次的本地购物车数据
    await KV.remove(kv_shop);
    await UsUtil.checkLocalY(); // 为避免意外退出未清理本地求测大师数据
    Log.info("用户登录结果：${login.toJson()}");
    // 初始化全局信息和网络
    await setLoginInfo(login);
    await _initGlobal(login);
    // 更新本地存储的token
    await KV.setStr(kv_jwt, login.jwt);
    // 在状态管理中初始化用户登录信息
    context.read<UserInfoState>().init(login.user_info);
    // 如果本地数据库有，则更新登录结果
    if ((await LoginDao(glbDB).exists(login.user_info.id))) {
      Log.info("更新本地用户信息：${login.user_info.id}");
      await LoginDao(glbDB).update(SqliteLoginRes.from(login));
    }
    // 如果本地数据库没有，则存储登录结果
    else {
      Log.info("存储新的用户信息：${login.user_info.id}");
      await LoginDao(glbDB).insert(SqliteLoginRes.from(login));
    }
    // 获取大师信息
    if (CusRole.is_master) await _fetchMaster(context);
    // 运营商或者运营商管理员获取服务码
    if (CusRole.is_broker_admin) await _fetchServiceCode();
    // 如果是游客，则请求绑定运营商
//    if (CusRole.is_guest) await _bindBroker(context);
    await _initPackageInfo(); // 获取版本信息
  }

  /// 初始化全局信息
  static Future<void> _initGlobal(LoginResult r) async {
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
    CusRole.is_guest = !CusRole.is_vip &&
        !CusRole.is_master &&
        !CusRole.is_broker_admin &&
        !CusRole.is_admin;
    // 重置是否闪断帖
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

  /// 运营商或者运营商管理员，获取服务码
  static Future<void> _fetchServiceCode() async {
    num id = ApiBase.loginInfo.user_info.broker_id;
    try {
      var res = await ApiBroker.brokerInfoGet(id);
      if (res != null) CusRole.service_code = res.service_code;
    } catch (e) {
      Log.error("获取运营商服务码出现异常：$e");
    }
  }

  /// 获取版本信息
  static Future<void> _initPackageInfo() async {
    try {
      final PackageInfo info = await PackageInfo.fromPlatform();
      if (info != null) {
        CusRole.packageInfo = info;
      }
    } catch (e) {
      Log.error("获取app包信息出现异常：$e");
    }
  }

  /// 无码邀请时，游客绑定运营商
  static Future<void> _bindBroker(BuildContext context) async {
    var deviceData = Map<String, dynamic>();
    try {
      // 获取手机信息
      if (Platform.isAndroid) {
        var androidInfo = await DemoPlugin.deviceInfoPlugin.androidInfo;
        deviceData = {
          'version.release': androidInfo.version.release,
          'model': androidInfo.model,
        };
        String model = deviceData['model'];
        String version = "android" + deviceData['version.release'];
        Log.info("手机品牌：$model,手机版本：$version");
        Response response = await Dio().post(
          GaoServer.inviteCode,
          data: {"version": version, "model": model},
        );
        if (response != null) {
          String serviceCode = response.data['code'];
          Log.info("无码邀请的服务码:$serviceCode");
          bool ok = await ApiBroker.serviceCodeBind(serviceCode);
          Log.info("无码邀请的游客绑定运营商结果：$ok");
          if (ok) {
            CusToast.toast(context,
                text: "已自动绑定运营商，即将为你重新登录", milliseconds: 2000);
            SpinKit.threeBounce(context);
            await Future.delayed(Duration(milliseconds: 2000));
//            var m = {"user_code": user_code, "pwd": pwd};
//            LoginResult login = await ApiLogin.login(m);
//            if (login != null) {
//              await LoginVerify.init(login, context);
//              Navigator.pop(context); // 退出loading页面
//              CusRoute.pushReplacement(context, HomePage());
//            }
          }
        }
      } else if (Platform.isIOS) {
        var iosInfo = await DemoPlugin.deviceInfoPlugin.iosInfo;
        // ios 版本需要验证下面两个字段的真实含义
        deviceData = {
          'systemVersion': iosInfo.systemVersion,
          'model': iosInfo.model,
        };
      }
    } catch (e) {
      Log.error("获取手机设备信息出现异常：$e");
    }
  }
}
