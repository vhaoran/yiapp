import 'dart:io';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/widget/flutter/cus_appbar.dart';
import 'package:yiapp/widget/flutter/cus_dialog.dart';
import 'package:yiapp/widget/small/cus_box.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/11/28 下午4:53
// usage ：关于第三方插件的测试
// ------------------------------------------------------

class DemoPlugin extends StatefulWidget {
  DemoPlugin({Key key}) : super(key: key);

  @override
  _DemoPluginState createState() => _DemoPluginState();

  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
}

class _DemoPluginState extends State<DemoPlugin> {
  Map<String, dynamic> _deviceData = Map<String, dynamic>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CusAppBar(text: "关于第三方插件"),
      body: _lv(context),
      backgroundColor: primary,
    );
  }

  Widget _lv(context) {
    return ListView(
      children: <Widget>[
        NormalBox(
          title: "01 获取手机信息",
          onTap: _initPlatformState,
        ),
      ],
    );
  }

  /// 获取手机信息
  Future<void> _initPlatformState() async {
    Map<String, dynamic> deviceData;

    try {
      if (Platform.isAndroid) {
        Log.info("安卓系统");
        deviceData = _readAndroidBuildData(
            await DemoPlugin.deviceInfoPlugin.androidInfo);
      } else if (Platform.isIOS) {
        Log.info("ios系统");
        deviceData =
            _readIosDeviceInfo(await DemoPlugin.deviceInfoPlugin.iosInfo);
      }
      Log.info("手机信息：${deviceData.toString()}");
      CusDialog.tip(
        context,
        title: "版本：${deviceData['version.release']},\n"
            "牌子：${deviceData['model']}",
      );
    } on PlatformException {
      deviceData = <String, dynamic>{
        'Error:': 'Failed to get platform version.'
      };
    }

    if (!mounted) return;

    setState(() {
      _deviceData = deviceData;
    });
  }

  Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
    return <String, dynamic>{
      'version.securityPatch': build.version.securityPatch,
      'version.sdkInt': build.version.sdkInt,
      'version.release': build.version.release,
      'version.previewSdkInt': build.version.previewSdkInt,
      'version.incremental': build.version.incremental,
      'version.codename': build.version.codename,
      'version.baseOS': build.version.baseOS,
      'board': build.board,
      'bootloader': build.bootloader,
      'brand': build.brand,
      'device': build.device,
      'display': build.display,
      'fingerprint': build.fingerprint,
      'hardware': build.hardware,
      'host': build.host,
      'id': build.id,
      'manufacturer': build.manufacturer,
      'model': build.model,
      'product': build.product,
      'supported32BitAbis': build.supported32BitAbis,
      'supported64BitAbis': build.supported64BitAbis,
      'supportedAbis': build.supportedAbis,
      'tags': build.tags,
      'type': build.type,
      'isPhysicalDevice': build.isPhysicalDevice,
      'androidId': build.androidId,
      'systemFeatures': build.systemFeatures,
    };
  }

  Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo data) {
    return <String, dynamic>{
      'name': data.name,
      'systemName': data.systemName,
      'systemVersion': data.systemVersion,
      'model': data.model,
      'localizedModel': data.localizedModel,
      'identifierForVendor': data.identifierForVendor,
      'isPhysicalDevice': data.isPhysicalDevice,
      'utsname.sysname:': data.utsname.sysname,
      'utsname.nodename:': data.utsname.nodename,
      'utsname.release:': data.utsname.release,
      'utsname.version:': data.utsname.version,
      'utsname.machine:': data.utsname.machine,
    };
  }
}
