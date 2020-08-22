import 'dart:async';
import 'dart:io';
import 'package:web_socket_channel/io.dart';
import 'package:yiapp/model/msg/info_recent.dart';
import 'package:yiapp/model/msg/msg_body.dart';
import 'package:yiapp/service/api/api_base.dart';
import 'package:yiapp/service/api/api_msg.dart';
import 'package:yiapp/service/bus/im-bus.dart';
import 'package:yiapp/service/storage_util/msg_his_dao.dart';
import 'package:yiapp/service/storage_util/msg_top_dao.dart';
import 'package:yiapp/service/storage_util/sq_init.dart';

//const String _url = "ws://192.168.0.99:8889/ws";
const String _url = "ws://0755yicai.com:8083/ws";
IOWebSocketChannel glbWSChan;

initWSChan() {
  String jwt = ApiBase.jwt;
  //String jwt = "test/1";

  IOWebSocketChannel _chan = new IOWebSocketChannel.connect(_url, headers: {
    "Jwt": jwt,
  });

  // TODO 隐藏掉上线通知
  // _notifyOnline();

  _chan.stream.listen((message) {
    print(message);
    _pump(message);
  }, onError: (err) {
    print("-------error-----------");
    print(err.toString());

    //_chan.sink.close(-1, "on-error" + err.toString());

    _sleep();
    initWSChan();
  }, onDone: () {
    print("---websocket----done-----------");

    _sleep();
    initWSChan();
  });

  Timer.periodic(Duration(seconds: 10), (timer) {
    try {
      _ping(_chan);
    } catch (e) {
      timer.cancel();
      //glbWSChan.sink.close(-1, "on-error" + e.toString());

      _sleep();
      initWSChan();
    }
  });

  glbWSChan = _chan;
}

void _notifyOnline() {
  Future.delayed(Duration(seconds: 5), () {
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
  MsgBody bean = MsgBody.fromJsonStr(text);
  //flush to local storage

  if (bean != null) {
    _pushLocalStorageAck(bean);

    _pushLocalStorage_top(bean);
    //通知到首面（首頁不用時，將來去掉）
    glbEventBus.fire(bean);

    //通知到首页
    var infoRecent = InfoRecent.from(bean);
    if (infoRecent != null) {
      glbEventBus.fire(infoRecent);
    }
  }
}

Future<bool> _msgAck(MsgBody src) async {
  var l = [
    {"msg_type": src.msg_type, "id": src.id},
  ];
  return await ApiMsg.AckMsg(l);
}

_pushLocalStorageAck(MsgBody bean) {
  MsgHisDao dao = new MsgHisDao(glbDB);
  bean.not_read_count = 1;
  dao.push(bean).whenComplete(() {
    print(
        "------msgBody to local sqflite---${DateTime.now().toString()}--------------");
    print("${bean.toJson()}");
    _msgAck(bean).then((ok) {
      print(
          "------msgBody ack ok---${DateTime.now().toString()}-------${bean.id}-------");
    });
  }).catchError((e) {
    print(
        "*****************msgTop to local sqflite---${DateTime.now().toString()}--------------");
    print("${bean.toJson()}");
    print("************ ${e.toString()}");
  });
}

_pushLocalStorage_top(MsgBody bean) {
  MsgTopDao dao = new MsgTopDao(glbDB);
  dao.push(bean).whenComplete(() {
    print(
        "------msgTop to local sqflite---${DateTime.now().toString()}--------------");
    print("${bean.toJson()}");
  }).catchError((e) {
    print(
        "*****************msgTop to local sqflite---${DateTime.now().toString()}--------------");
    print("${bean.toJson()}");
    print("************ ${e.toString()}");
  });
}

bool _isPong(String text) {
  if (text.trim().toLowerCase() == "pong") {
    return true;
  }
  return false;
}

_ping(IOWebSocketChannel c) {
  c.sink.add("ping");
}
