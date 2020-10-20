import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:yiapp/complex/class/debug_log.dart';
import 'package:yiapp/complex/tools/cus_reg.dart';
import 'package:yiapp/model/login/userInfo.dart';
import 'package:yiapp/service/api/api_image.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/8/24 11:37
// usage ：自定义混合工具类
// ------------------------------------------------------

class CusTool {
  /// 处理性别
  static String sex(int sex) {
    switch (sex) {
      case 0:
        return '女';
      case 1:
        return '男';
      default:
        return "保密";
    }
  }

  /// 返回字符串中所有的大写字母
  static String AZ(String str) {
    List<String> l =
        str.trim().split('').where((e) => CusRegExp.upChar(e)).toList();
    String val = "";
    l.forEach((e) => val += e);
    return val;
  }

  // 返回字符串中的所有数字
  static List<String> retainNum(String str) {
    List<String> l = str.trim().split('');
    l.retainWhere((e) => CusRegExp.retainNum(e));
    print(">>>当前的l：$l");
    return l;
  }

  /// 不够两位数的补0，比如 8:4 to 08:04
  static String padLeft(dynamic data) {
    if (data is num) {
      return data.toString().padLeft(2, "0");
    } else if (data is String) {
      return data.padLeft(2, "0");
    }
    return "转换格式异常";
  }

  /// 单个 file 类型文件的上传
  static Future<String> fileUrl(File file) async {
    String url = "";
    try {
      String key = await ApiImage.uploadQiniu(file);
      url = await ApiImage.GetVisitURL(key);
    } catch (e) {
      print("<<<出现异常：$e");
    }
    return url;
  }

  /// 多个文件的上传
  static Future<List<Map>> assetsKeyPath(List<Asset> assets) async {
    List<Map> res = [];
    try {
      for (var i = 0; i < assets.length; i++) {
        ByteData byteData = await assets[i].getByteData();
        Uint8List u = byteData.buffer.asUint8List();
        String key = await ApiImage.uploadQiniuData(u);
        String url = await ApiImage.GetVisitURL(key.trim());
        res.add({"key": key, "path": url});
      }
      return res;
    } catch (e) {
      Debug.log("转换Asset时出现异常:$e");
      return [];
    }
  }
}

UserInfo defaultUser = UserInfo.fromJson({
  "area": "",
  "birth_day": 0,
  "birth_month": 0,
  "birth_year": 0,
  "broker_id": 0,
  "city": "",
  "country": "",
  "created_at": "2020-08-21 17:04:07",
  "enabled": true,
  "icon":
      "http://cli.oss.aliyuncs.com/2015/04/22/21f5deae6515c6c8a8834c5a65506971.jpg?e=1598256911&token=gEpp05gnISRQeLZ6d5GCnAryXSFDnMfl_G5iG5p5:szss9JHvlzM0ac7YYzc13-nABsg=",
  "id": 7,
  "id_card": "",
  "nick": "游客登录",
  "province": "",
  "pwd": "",
  "sex": 0,
  "update_at": "2020-08-24 14:58:43",
  "user_code": "",
  "user_name": "游客登录"
});
