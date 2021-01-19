import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/const/gao_server.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/cus/cus_role.dart';
import 'package:yiapp/model/complex/update_res.dart';
import 'package:yiapp/util/screen_util.dart';
import 'package:yiapp/widget/cus_update.dart';
import 'package:yiapp/widget/small/cus_loading.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2021/1/14 下午2:23
// usage ：更新app
// ------------------------------------------------------

class UpdateUtil {
  /// 比较版本号
  static Future<bool> compareVersion(BuildContext context) async {
    // 如果是生产模式
    if (bool.fromEnvironment("dart.vm.product")) {
      Log.info("这是生产模式，检查更新");
      try {
        Response response = await Dio().get(GaoServer.checkVer);
        if (response != null) {
          var res = UpdateRes.fromJson(json.decode(response.data));
          if (res != null) {
            Log.info("服务器版本号：${res.version}");
            Log.info("本地版本号：${CusRole.packageInfo.version}");
            String serverVersion = res.version.replaceAll(".", "");
            String localVersion =
                CusRole.packageInfo.version.replaceAll(".", "");
            bool update = num.parse(serverVersion) > num.parse(localVersion);
//            bool update = 120000 > num.parse(localVersion);
            if (update) {
              _updateDialog(context, res);
              return true;
            }
          }
        }
        return false;
      } catch (e) {
        Log.error("获取版本号出现异常：$e");
      }
    } else {
      Log.info("这是Debug模式不需要更新");
      return false;
    }
  }

  /// 提示更新弹窗
  static void _updateDialog(BuildContext context, UpdateRes res) {
    CusUpdateDialog.showUpdate(context,
        topTitle: Text(
          "检测到新版本 ${res.version}",
          style: TextStyle(color: Colors.white, fontSize: S.sp(16)),
        ),
        updateTitle: Text(
          "当前版本 ${CusRole.packageInfo.version}",
          style: TextStyle(color: t_gray, fontSize: S.sp(15)),
        ), onUpdate: () async {
      try {
        if (await canLaunch(res.url)) {
          Navigator.pop(context); // 关闭更新弹框
          SpinKit.threeBounce(context, text: "正在打开浏览器");
          await Future.delayed(Duration(milliseconds: 1000));
          Log.info("apk下载地址有效，可以下载");
          bool ok = await launch(res.url, forceSafariVC: false);
          Log.info("打开浏览器结果:$ok");
          Navigator.pop(context); // 关闭loading框
        }
      } catch (e) {
        Navigator.pop(context);
        Log.error("下载apk出现异常：$e");
      }
    });
  }
}
