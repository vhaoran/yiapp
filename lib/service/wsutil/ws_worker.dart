import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mobpush_plugin/mobpush_plugin.dart';
import 'package:web_socket_channel/io.dart';
import 'package:yiapp/model/msg/msg-notify-his.dart';
import 'package:yiapp/model/msg/msg-notify.dart';
import 'package:yiapp/model/msg/msg-yiorder.dart';
import 'package:yiapp/model/msg/msg_body.dart';
import 'package:yiapp/service/api/api-push.dart';
import 'package:yiapp/service/api/api_base.dart';
import 'package:yiapp/service/api/api_msg.dart';
import 'package:yiapp/service/bus/im-bus.dart';

//const String _url = "ws://192.168.0.99:8889/ws";
//const String _url = "ws://0755yicai.com:8083/ws";
const String _url = "ws://hy3699.com:8083/ws";
IOWebSocketChannel glbWSChan;
Timer glbTimerPing;
Timer glbTimerPushReg;

bool _init_doing = false;

/* 每次重新登录后调用，避免websocker原来的连接 working */
closeWSChan() async {
  //-----------chan-------------------------------------
  try {
    if (glbWSChan != null) {
      await glbWSChan.sink.close();
    }
  } catch (e) {
    print("***error,file: ${e.toString()}");
  }
  //-----------ping-------------------------------------
  try {
    if (glbTimerPing != null) {
      glbTimerPing.cancel();
    }
  } catch (e) {
    print("***error,file: ${e.toString()}");
  }
  //-----------push reg-------------------------------------
  try {
    if (glbTimerPushReg != null) {
      glbTimerPushReg.cancel();
    }
  } catch (e) {
    print("***error,file: ${e.toString()}");
  }
}

initWSChan() async {
  if (_init_doing) {
    return;
  }

  // await closeWSChan();

  try {
    initWSChanSingle();
  } catch (e) {
    _delayInit();
  } finally {
    _init_doing = false;
  }
}

initWSChanSingle() {
  print("-------initWSChan web socket ---------------");

  String jwt = ApiBase.jwt;
  //String jwt = "test/1";

  IOWebSocketChannel _chan = new IOWebSocketChannel.connect(_url, headers: {
    "Jwt": jwt,
  });

  //上线通知
  _notifyOnline();

  _chan.stream.listen((message) {
    print("-----------------------------------");
    print("--------------raw received: $message -----------");
    _pump(message);
  }, onError: (err) {
    print("-------error-----------");
    print("***error---initWSChan:" + err.toString());
    _delayInit();
  }, onDone: () {
    print("---websocket----done-----------");
    _delayInit();
  }, cancelOnError: true);

  glbTimerPing = Timer.periodic(Duration(seconds: 10), (timer) {
    try {
      _ping(_chan);
    } catch (e) {
      timer.cancel();
      _delayInit();
    }
  });

  glbTimerPushReg = Timer.periodic(Duration(seconds: 60), (timer) {
    try {
      _pushReg(_chan);
    } catch (e) {
      timer.cancel();
      _delayInit();
    }
  });

  glbWSChan = _chan;
}

void _delayInit() {
  Future.delayed(Duration(seconds: 5), () {
    initWSChan();
  });
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
  try {
    _pump_exec(text);
  } catch (e) {
    print("***error,_pump: ${e.oString()} ref msg: $text ");
  }
}

void _pump_exec(String text) {
  print('-----  ${DateTime.now()} ----------');

  //----pump to text listener only for debug--------------------------------------------
  // glbEventBus.fire(MessageEvent("common-msg-text", text));
  if (_isPong(text)) {
    return;
  }

  print("------------after pong---------");
  //------pump to MsgBody listener---------------------
  MsgBody src = MsgBody.fromJsonStr(text);
  if (src == null) {
    return;
  }

  //flush to local storage
  print("------after msg body---------------");
  print("-----------   ${src.toJson()}");

  //---notify msg--通知消息的解析-------------------------
  if (src.content_type == "notify") {
    parseNotify(src);
  }
  print("------after notify---------------");
  //----yi order--大师订单
  if (src.content_type == "yi-order") {
    parseYiOrder(src);
  }
  print("---------after yi order------------");

  //通知到首面（首頁不用時，將來去掉）
}

void parseYiOrder(MsgBody src) {
  try {
    MsgYiOrder dst = MsgYiOrder.fromJson(src.content as Map<String, dynamic>);
    if (dst != null) {
      glbEventBus.fire(dst);
      //ack
      ApiMsg.yiOrderMsgAckService(dst.id);
      print("-----解析 大师订单-消息 完成---------------");
      print("${dst.toJson()}");
    }
  } catch (e) {
    print("***error--WWWWWWWWW-parseYiOrder:" + e.toString());
  }
}

//通知消息的解析
void parseNotify(MsgBody src) {
  try {
    MsgNotifyHis dst =
        MsgNotifyHis.fromJson(src.content as Map<String, dynamic>);
    if (dst != null) {
      glbEventBus.fire(dst);
      ApiMsg.notifyMsgAckService(dst.id);
      print("-----解析通知消息完成---------------");
      print("${dst.toJson()}");
    }
  } catch (e) {
    print("***error-WWWWWWWWWWWWWW--parseNotify:" + e.toString());
  }
}

// Future<bool> _msgAck(MsgBody src) async {
//   var l = [
//     {"msg_type": src.msg_type, "id": src.id},
//   ];
//   return await ApiMsg.AckMsg(l);
// }

bool _isPong(String text) {
  if (text.trim().toLowerCase().startsWith("pong")) {
    return true;
  }
  return false;
}

_ping(IOWebSocketChannel c) {
  c.sink.add("ping");
}

_pushReg(IOWebSocketChannel c) {
  MobpushPlugin.getRegistrationId().then((data) {
    String regID = data["res"].toString();
    // print("  mod push id is $regID  ########### uid:  ${ApiBase.uid}");
    ApiPush.pushRegist(regID).then((ok) {
      print(
          "  mod push id  <$regID>  ------  reg ok-of -${ApiBase.uid}-(uid)-");
    });
  });
}
