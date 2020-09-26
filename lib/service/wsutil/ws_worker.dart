import 'dart:async';
import 'dart:io';
import 'package:web_socket_channel/io.dart';
import 'package:yiapp/model/msg/msg-notify.dart';
import 'package:yiapp/model/msg/msg-yiorder.dart';
import 'package:yiapp/model/msg/msg_body.dart';
import 'package:yiapp/service/api/api_base.dart';
import 'package:yiapp/service/api/api_msg.dart';
import 'package:yiapp/service/bus/im-bus.dart';

//const String _url = "ws://192.168.0.99:8889/ws";
const String _url = "ws://0755yicai.com:8083/ws";
IOWebSocketChannel glbWSChan;
bool _init_doing = false;

initWSChan() async {
  if (_init_doing) {
    return;
  }
  try {
    print("-------initWSChan web socket ---------------");

    String jwt = ApiBase.jwt;
    //String jwt = "test/1";

    IOWebSocketChannel _chan = new IOWebSocketChannel.connect(_url, headers: {
      "Jwt": jwt,
    });

    //上线通知
    _notifyOnline();

    _chan.stream.listen((message) {
      print(message);
      _pump(message);
    }, onError: (err) {
      print("-------error-----------");
      print("***error---initWSChan:" + err.toString());

      //_chan.sink.close(-1, "on-error" + err.toString());

      _sleep();
      if (!_init_doing) {
        initWSChan();
      }
    }, onDone: () {
      print("---websocket----done-----------");

      _sleep();
      if (!_init_doing) {
        initWSChan();
      }
    }, cancelOnError: true);

    Timer.periodic(Duration(seconds: 10), (timer) {
      try {
        _ping(_chan);
      } catch (e) {
        timer.cancel();
        //glbWSChan.sink.close(-1, "on-error" + e.toString());

        _sleep();
        if (!_init_doing) {
          initWSChan();
        }
      }
    });

    glbWSChan = _chan;
  } finally {
    _init_doing = false;
  }
}

void _notifyOnline() {
  Future.delayed(Duration(seconds: 15), () {
    ApiMsg.OnLineNotify().then((e) {
      print("-------onLineNotify-----上线通知服务器-----------");
    });
  });
}

void _sleep() {
  sleep(Duration(
    seconds: 5,
  ));
}

void _pump(String text) {
  print('-----  ${DateTime.now()} ----------');

  //----pump to text listener only for debug--------------------------------------------
  glbEventBus.fire(MessageEvent("common-msg-text", text));
  if (_isPong(text)) {
    return;
  }

  //------pump to MsgBody listener---------------------
  MsgBody src = MsgBody.fromJsonStr(text);
  //flush to local storage

  //---notify msg--通知消息的解析-------------------------
  if (src.content_type == "notify") {
    parseNotify(src);
  }
  //----yi order--大师订单
  if (src.content_type == "yi-order") {
    parseYiOrder(src);
  }

  //通知到首面（首頁不用時，將來去掉）
}

void parseYiOrder(MsgBody src) {
  try {
    MsgYiOrder dst = MsgYiOrder.fromJson(src.content as Map<String, dynamic>);
    if (dst != null) {
      glbEventBus.fire(dst);
      print("-----解析 大师订单-消息 完成---------------");
      print("${dst.toJson()}");
    }
  } catch (e) {
    print("***error---parseYiOrder:" + e.toString());
  }
}

//通知消息的解析
void parseNotify(MsgBody src) {
  try {
    MsgNotify dst = MsgNotify.fromJson(src.content as Map<String, dynamic>);
    if (dst != null) {
      glbEventBus.fire(dst);
      print("-----解析通知消息完成---------------");
      print("${dst.toJson()}");
    }
  } catch (e) {
    print("***error---parseNotify:" + e.toString());
  }
}

// Future<bool> _msgAck(MsgBody src) async {
//   var l = [
//     {"msg_type": src.msg_type, "id": src.id},
//   ];
//   return await ApiMsg.AckMsg(l);
// }

bool _isPong(String text) {
  if (text.trim().toLowerCase() == "pong") {
    return true;
  }
  return false;
}

_ping(IOWebSocketChannel c) {
  c.sink.add("ping");
}
