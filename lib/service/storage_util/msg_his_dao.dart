import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:yiapp/model/msg/msg_body.dart';

class MsgHisDao {
  MsgHisDao(Database db) {
    this.db = db;
  }

  Database db;
  final _tb = "msg_his";

  //uid或gid只取其一，
  //分别对应群消息和私聊消息
  Future<bool> doRead(int to_uid, int to_gid) async {
    if (to_uid > 0) {
      await db.update(
        _tb,
        {
          "not_read_count": 0,
        },
        where: " to_uid = ? or from_uid = ?",
        whereArgs: [to_uid, to_uid],
      );
      return true;
    }
    if (to_gid > 0) {
      await db.update(
        _tb,
        {
          "read": 1,
        },
        where: " to_gid ",
        whereArgs: [to_gid],
      );
      return true;
    }
  }

  Future<bool> push(MsgBody bean) async {
    Map<String, dynamic> m = toMap(bean);
    bool b = await exists(bean.id);
    if (b) {
      return true;
    }

    bean.not_read_count = 1;
    var i = await db.insert(_tb, m);
    if (i > 0) {
      return true;
    }

    return false;
  }

  Map<String, dynamic> toMap(MsgBody bean) {
    Map<String, dynamic> data = bean.toJson();

    //
    data["body"] = jsonEncode(bean.body);
    return data;
  }

  Future<bool> exists(String id) async {
    List<Map> l = await db.query(_tb, where: "id=?", whereArgs: [id], limit: 1);
    return l.length > 0;
  }

  //only for test purpose
  void showRecentN(int n) async {
    List<MsgBody> l = await listRecentN(n);
    for (var each in l) {
      print(" msg_body: #{each.toJson().tostring()}");
    }
  }

  Future<List<MsgBody>> listRecentN(int n) async {
    List<Map<String, dynamic>> src = await db.query(
      _tb,
      //where: where,
      //whereArgs: args,
      orderBy: "created desc",
      //offset: offset,
      limit: n,
    );

    //
    List<MsgBody> l = src.map((each) {
      print(" ## MsgBody.fromJson  ${each.toString()}");
      return MsgBody.fromJson(each);
    }).toList();

    return l;
  }

  Future<List<MsgBody>> page(
      {String where,
      List<dynamic> args,
      int offset = 0,
      int limit = 10}) async {
    List<Map<String, dynamic>> src = await db.query(
      _tb,
      where: where,
      whereArgs: args,
      orderBy: "created desc",
      offset: offset,
      limit: limit,
    );

    //
    List<MsgBody> l = src.map((each) {
      print(" ## MsgBody.fromJson  ${each.toString()}");
      return MsgBody.fromJson(each);
    }).toList();
    return l;
  }
}
