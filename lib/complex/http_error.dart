import 'package:dio/dio.dart';

class HttpError {
  /// 错误信息
  static ErrorEntity createErrorEntity(DioError error) {
    switch (error.type) {
      case DioErrorType.CANCEL:
        print(">>>请求取消");
        return ErrorEntity(code: -1, msg: "请求取消");
        break;
      case DioErrorType.CONNECT_TIMEOUT:
        print(">>>连接超时");
        return ErrorEntity(code: -1, msg: "连接超时");
        break;
      case DioErrorType.SEND_TIMEOUT:
        print(">>>请求超时");
        return ErrorEntity(code: -1, msg: "请求超时");
        break;
      case DioErrorType.RECEIVE_TIMEOUT:
        print(">>>响应超时");
        return ErrorEntity(code: -1, msg: "响应超时");
        break;
      case DioErrorType.RESPONSE:
        print(">>>未知错误");
        print(">>>err.${error.response.data}");
        return ErrorEntity(code: -1, msg: "未知错误");
        break;
      default:
        return ErrorEntity(code: -1, msg: error.message);
        break;
    }
  }
}

void interceptors(Dio dio) {
  dio.interceptors.add(InterceptorsWrapper(
// 接口请求前数据处理
    onRequest: (Options options) {
      return options;
    },
// 接口成功返回时的处理
    onResponse: (Response resp) {
      return resp;
    },
// 接口报错时处理
    onError: (DioError error) {
      return error;
    },
  ));
}

class ErrorEntity {
  int code;
  String msg;
  ErrorEntity({this.code, this.msg});
}
