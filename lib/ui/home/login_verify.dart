import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import 'package:yiapp/const/gao_server.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/const/con_string.dart';
import 'package:yiapp/cus/cus_route.dart';
import 'package:yiapp/demo/demo_plugin/plugin_main.dart';
import 'package:yiapp/model/complex/update_res.dart';
import 'package:yiapp/service/api/api-broker.dart';
import 'package:yiapp/ui/mine/personal_info/bind_usercode_pwd.dart';
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
import 'package:yiapp/widget/flutter/cus_dialog.dart';

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
    if (CusRole.is_guest) await _bindBrokerRes(context);
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
  static Future<void> _bindBrokerRes(BuildContext context) async {
    DeviceRes device = await _deviceRes(); // 获取设备信息
    Log.info("手机品牌：${device.model},系统版本：${device.version}");
    try {
      Response response = await Dio().post(
        GaoServer.inviteCode,
        data: {"model": device.model, "version": "android" + device.version},
      );
      if (response.statusCode == 200) {
        if (response != null &&
            response?.data != null &&
            response?.data != {} &&
            response.data['code'] != null &&
            response.data['broker_id'] != null) {
          String serviceCode = response.data['code']; // 取运营商服务码
          num brokerId = num.parse(response.data['broker_id']); // 取运营商id
          Log.info("运营商服务码:$serviceCode、运营商id:$brokerId");
          if (serviceCode != null) {
            // 根据服务码绑定运营商
            bool ok = await ApiBroker.serviceCodeBind(serviceCode);
            Log.info("游客通过无码邀请绑定运营商结果：$ok");
            if (ok) {
              if (brokerId != null && brokerId > 0) {
                var brokerInfo = await ApiBroker.brokerInfoGet(brokerId);
                // 修改用户状态信息broker_id的值
                // mine_view页面是据此显示的，所以这里需要更改
                ApiBase.loginInfo.user_info.broker_id = brokerId;
                CusRole.broker_id = brokerId;
                context.read<UserInfoState>()?.chBrokerId(brokerId);
                // 修改本地数据库中用户信息broker_id以及不同模块的值
                bool update =
                    await LoginDao(glbDB).updateGuestToVip(brokerInfo);
                Log.info("本地将游客转换为普通会员结果:$update");
              }
              CusDialog.normal(
                context,
                title: "已为你绑定运营商，绑定手机号后可享受更多服务",
                textAgree: "现在绑定",
                textCancel: "再想想",
                fnDataApproval: "",
                onThen: () => CusRoute.push(context, BindUserCodePwd()),
              );
            } else {
              CusDialog.tip(context, title: "未成功绑定运营商，可手动绑定");
            }
          }
        } else {
          Log.info("没有服务码的游客进入程序，不需要自动绑定运营商");
        }
      } else {
        Log.error("请求获取邀请码的状态码返回不是200");
      }
      Log.info("resp+++++:${response}");
    } catch (e) {
      Log.error("连接 gao server 出现异常：$e");
    }
  }

  /// 获取设备信息
  static Future<DeviceRes> _deviceRes() async {
    var deviceData = DeviceRes();
    String device = await KV.getStr(kv_device);
    // 没有获取过设备信息
    if (device == null) {
      Log.info("第一次获取设备信息");
      try {
        // android 系统
        if (Platform.isAndroid) {
          var androidInfo = await DemoPlugin.deviceInfoPlugin.androidInfo;
          deviceData = DeviceRes.fromJson({
            'model': androidInfo.model,
            'version.release': androidInfo.version.release,
          });
        }
        // ios 系统
        else if (Platform.isIOS) {
          Log.info("已经获取过设备信息");
          var iosInfo = await DemoPlugin.deviceInfoPlugin.iosInfo;
          // ios 版本需要验证下面两个字段的真实含义
          deviceData = DeviceRes.fromJson({
            'model': iosInfo.model,
            'version.release': iosInfo.systemVersion,
          });
        }
      } catch (e) {
        Log.error("获取手机设备信息出现异常：$e");
      }
    }
    // 已经获取过设备信息
    else {
      deviceData = DeviceRes.fromJson(json.decode(device));
    }

    return deviceData;
  }
}
