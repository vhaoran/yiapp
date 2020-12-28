import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:yiapp/model/login/login_result.dart';
import '../../model/pagebean.dart';

// ------------------------------------------------------
// author: whr    除本人外请勿更改，如果确有必要，请征得本人同意
// date  : 2020/4/3
// usage : 这是所有 API封装的基类
//
// ------------------------------------------------------
class ApiBase {
  static LoginResult loginInfo;

  //当前系统是否处理debug状态
  static bool isDebug = true;

  //dio的统一封闭
  static Dio dio = new Dio();

  //用户是否登录
  static bool login = false;

  //用户登录后的token
  static String jwt = "test/1";
  static int uid = 0;

  //用户访问的主机
  static String host = "0755yicai.com";

  //对于基本返回值是一个结构的类型
  static Future<PageBean> postPage<T>(
      String url, dynamic postData, dynamic tranFn(Map<String, dynamic> m),
      {bool enableJwt = true}) async {
    debug("----begin Fn postPage---");
    var m = await post(url, postData, enableJwt: enableJwt);
    //
    if (m["code"] as int >= 200) {
      debug('---- Fn->postPage--data-${m["data"]}');
      PageBean bean = PageBean.fromMap(m["data"]);
      //try {
      List items =
          ((m["data"] as Map)["data"] as List).map((x) => tranFn(x)).toList();
      bean.data = items;
//      } catch (e) {
//        bean.data = null;
//      }

      return bean;
    }

    throw m["msg"];
  }

  //对于基本返回值是一个结构Object的类型
  static Future<T> postObj<T>(
      String url, dynamic postData, T tranFn(Map<String, dynamic> m),
      {bool enableJwt = true}) async {
    debug("----begin Fn postObj---");
    var m = await post(url, postData, enableJwt: enableJwt);
    //
    if (m["code"] as int >= 200) {
      debug('---- Fn->postObj--data-${m["data"]}');
      return tranFn(m["data"]);
    }
    throw m["msg"];
  }

  //对于基本返回值是一个List类型
  static Future<T> postList<T>(String url, dynamic postData, T tranFn(List l),
      {bool enableJwt = true}) async {
    debug("----begin Fn postList---");
    var m = await post(url, postData, enableJwt: enableJwt);
    //
    if (m["code"] as int >= 200) {
      debug('---- Fn->postList--data-${m["data"]}');
      return tranFn(m["data"] as List);
    }
    throw m["msg"];
  }

  //对于基本返回值是一个简单类型(string,bool,int,num,float etc..)
  static Future<T> postValue<T>(String url, dynamic postData,
      {bool enableJwt = true}) async {
    var m = await post(url, postData, enableJwt: enableJwt);
    //
    if (m["code"] as int >= 200) {
      return m["data"] as T;
    }
    throw m["msg"];
  }

  //最基本的post类型，返回结果是response中的map<string,dynamic>
  static post(String url, dynamic postData, {bool enableJwt = true}) async {
    dynamic r;
    var host = "http://${ApiBase.host}";
    debug("---visit: ${host + url}-----");
    debug("---args: $postData-----");

    if (enableJwt) {
      r = await dio.post(
        host + url,
        data: postData,
        options: Options(headers: {
          'Jwt': jwt,
          'Content-Type': "application/json",
        }),
      );
    } else {
      r = await dio.post(
        host + url,
        data: postData,
        options: Options(headers: {
          'Content-Type': "application/json",
        }),
      );
    }

    //
    debug("-----$url--response-----\n ${r.cate.toString()} ");
    debug("------------------");

    var m = jsonDecode(r.cate);
    return m;
  }

  static Future getFullUrl(String fullUrl, {bool enableJwt = true}) async {
    debug(" ----visit url: $fullUrl");

    dynamic r;
    if (enableJwt) {
      r = await dio.get(
        fullUrl,
        options: Options(headers: {
          'Jwt': jwt,
//          'Content-Type': "application/json",
        }),
      );
    } else {
      r = await dio.get(
        fullUrl,
//        options: Options(headers: {
//          'Content-Type': "application/json",
//        }),
      );
    }

    //
    debug("-----$fullUrl--response-----\n ${r.cate.toString()} ");
    debug("------------------");

    var m = jsonDecode(r.cate);
    return m;
  }

  static Future<Response<T>> get<T>(String url, dynamic data,
      {bool enableJwt = true}) {
    if (enableJwt) {
      return dio.get(
        url,
        options: Options(headers: {'jwt': jwt}),
      );
    }
    return dio.post(
      url,
      data: data,
    );
  }
}

debug(String s) {
  print(s);
}
