import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:yiapp/func/debug_log.dart';
import 'package:yiapp/service/api/api_image.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/12/1 上午10:54
// usage ：文件工具类
// ------------------------------------------------------

class FileUtil {
  /// 单个文件的上传
  static Future<String> singleFile(File file) async {
    String url = "";
    try {
      String key = await ApiImage.uploadQiniu(file);
      url = await ApiImage.GetVisitURL(key);
    } catch (e) {
      Debug.logError("上传单个文件到七牛云出现异常：$e");
    }
    return url;
  }

  /// 多个文件的上传
  static Future<List<Map>> multipleFiles(List<Asset> assets) async {
    List<Map> res = [];
    try {
      for (var i = 0; i < assets.length; i++) {
        ByteData byteData = await assets[i].getByteData();
        Uint8List u = byteData.buffer.asUint8List();
        String key = await ApiImage.uploadQiniuData(u);
        String url = await ApiImage.GetVisitURL(key.trim());
        res.add({"key": key, "path": url});
      }
    } catch (e) {
      Debug.log("上传多个文件到七牛云出现异常：$e");
    }
    return res;
  }
}
