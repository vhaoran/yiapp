import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_qiniu/flutter_qiniu.dart';
import '../../complex/function/create_uuid.dart';
import 'api_base.dart';

class ApiImage {
  static Future<String> GetVisitURL(String key) async {
    return await _VisitURL(key, 24 * 365 * 10);
  }

  //上传文件到七牛云,30天过期的,适用于聊天中图片及视频
  //30天保存期
  static Future<String> uploadQiniu(File file) async {
    //获取token
    String token = await ApiImage.UploadToken(100);
    //设置key
    String key = newUUID();
    //这是返回的结果，上伟成功后会返回一个结果
    String r = await _doUpload_qiniu(file, key, token);
    if (r == null || r.length == 0) {
      throw "未知原因，上传文件失败";
    }

    return r;
  }

  static Future<String> uploadQiniuData(Uint8List data) async {
    //获取token
    String token = await ApiImage.UploadToken(100);
    //设置key
    String key = newUUID();
    //这是返回的结果，上伟成功后会返回一个结果
    String r = await _doUpload_qiniu_data(data, key, token);
    if (r == null || r.length == 0) {
      throw "未知原因，上传文件失败";
    }

    return r;
  }

  //上传文件到七牛云,记不过期的,适用于朋友圈、公众号、收藏等，
  //永久保存
  static Future<String> _uploadQiniu_forEver(File file) async {
    //获取token
    String token = await ApiImage.UploadToken(20);
    //设置key
    String key = newUUID();
    //这是返回的结果，上伟成功后会返回一个结果
    String r = await _doUpload_qiniu(file, key, token);
    if (r == null || r.length == 0) {
      throw "未知原因，上传文件失败";
    }

    //---永久访问的图片url,适用于用户头像或收藏夹---
    String url = await ApiImage._VisitURL_forever(r);
    print("----- 0k,url is : #r -----------");
    return url;
  }

  //转化url为缩略图（只针对图片url）
  static String thumbnail(String url, {int width = 50, int height = 50}) {
    if (url == null) {
      return "";
    }
    String pat = "?imageView2/0/w/$width/h/$height/q/70";
    if (url.indexOf('?') != -1) {
      pat = "&imageView2/0/w/$width/h/$height/q/100";
    }

    return url.trim() + pat;
  }

  /// 单个文件上传
  ///
  /// [file] 文件
  /// [key] 保存在服务器上的资源唯一标识
  /// [token] 服务器分配的 token
  static Future<String> _doUpload_qiniu(
      File file, String key, String token) async {
    final qiniu = FlutterQiniu(zone: QNFixedZone.zone1);
    qiniu.onProgressChanged().listen((dynamic percent) {
      // 上传进度
      double p = percent;
      print("进度： #p");
    });

    String resultKey = await qiniu.uploadFile(file.path, key, token);
    return resultKey;
  }

  /// 单个文件上传
  ///
  /// [data] 文件
  /// [key] 保存在服务器上的资源唯一标识
  /// [token] 服务器分配的 token
  static Future<String> _doUpload_qiniu_data(
      Uint8List data, String key, String token) async {
    final qiniu = FlutterQiniu(zone: QNFixedZone.zone1);
    qiniu.onProgressChanged().listen((dynamic percent) {
      // 上传进度
      double p = percent;
      print("进度： #p");
    });

    String resultKey = await qiniu.uploadData(data, key, token);
    return resultKey;
  }

  // util/UploadToken
  static Future<String> UploadToken(int expired_hours) async {
    var url = "/yi/util/UploadToken";
    var data = {"expired": expired_hours};
    return await ApiBase.postValue<String>(url, data, enableJwt: true);
  }

  // VisitURL
  static Future<String> _VisitURL(String key, int expired_hours) async {
    var url = "/yi/util/VisitURL";
    var data = {
      "key": key,
      "expired": expired_hours,
    };
    return await ApiBase.postValue<String>(url, data, enableJwt: true);
  }

  //永久url,适用于 需要永久保存的如：用户头像，用户收藏夹内容等
  static Future<String> _VisitURL_forever(String key) async {
    int expired_hours = 24 * 365 * 50;
    return await _VisitURL(key, expired_hours);
  }

  //VisitURL,返回一个30天的访问url,
  //适用于朋友圈图片
  static Future<String> VisitURL_30day(String key) async {
    int expired_hours = 24 * 30;
    return await _VisitURL(key, expired_hours);
  }

  static String avatarDefaultAssert({bool isDarkMode = false}) {
    return isDarkMode ? "assets/images/bg_blue.png" : "assets/images/gw.png";
  }
}
