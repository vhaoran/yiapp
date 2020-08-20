import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:yiapp/model/msg/msg_body.dart';
import 'package:yiapp/service/api/api_base.dart';
import 'package:yiapp/service/storage_util/sq_init.dart';

import 'no_disturb_local_dao.dart';
import 'on_top_local_dao.dart';

const int MsgType_Common = 1;
const int MsgType_bulletin = 2;
const int MsgType_circle = 3;
const int MsgType_sys = 4;

class MsgTopDao {
  MsgTopDao(Database db) {
    this.db = db;
  }

  Database db;
  final _tb = "msg_top";

  //uid或gid只取其一，
  //分别对应群消息和私聊消息
  Future<bool> doRead(int fromOrTo_uid, {int to_gid = 0, int bid = 0}) async {
//    * 发给我的消息：
//    *    to_uid = <me_id> and from_uid = from
//    * 我发的消息：
//    *    from_uid = <me_id> and to_uid = to

    int me_id = ApiBase.uid;

    if (fromOrTo_uid > 0) {
      await db.update(
        _tb,
        {
          "not_read_count": 0,
        },
        where: " (to_uid = ? and from_uid = ?) or "
            " (from_uid = ? and to_uid = ?)",
        whereArgs: [me_id, fromOrTo_uid, me_id, fromOrTo_uid],
      );
      return true;
    }

    if (to_gid > 0) {
      await db.update(
        _tb,
        {
          "not_read_count": 1,
        },
        where: " to_gid = ?",
        whereArgs: [to_gid],
      );
      return true;
    }
  }

  Future<bool> push(MsgBody bean) async {
    //only for debug
    //new MsgHisDao(glbDB).showRecentN(3);

    //
//    var xx = await list(0);
//    for (var each in xx) {
//      print("#{each.toJson().toString()}");
//    }

    print("------------all------------------");
    var z = Sqflite.firstIntValue(
        await db.rawQuery("select count(*) from msg_top "));
    print("###########   msg_top count: $z            #########              ");
    //---for debug-------end--------------------------------------

    if (bean.msg_type != MsgType_Common && bean.msg_type != MsgType_bulletin) {
      print("这类消息不需要保存msg_top本地表中");
      return true;
    }

    //-----remvoe old------------------------------
    await remove_old(bean);

    bean.on_top = await getOnTop(bean);
    bean.no_disturb = await get_no_disturb(bean);

    int count = await getNotReadCount(bean.from_uid, bean.to_uid, bean.to_gid);
    bean.not_read_count = count + 1;
    print('   ####  有  <${count + 1}>  条未读消息#######  ');

    //------flush------------------------------------
    Map<String, dynamic> m = toMap(bean);
    bool b = await existsOfID(bean.id);
    if (b) {
      return true;
    }

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

  Future<bool> existsOfID(String id) async {
    List<Map> l = await db.query(_tb, where: "id=?", whereArgs: [id], limit: 1);
    return l.length > 0;
  }

  Future<bool> remove_old(MsgBody src) async {
    //传入内容：
    // from,to
    //
    /*    设置某id为N
    * 发给我的消息：
    *    to_uid = <me_id> and from_uid = from
    * 我发的消息：
    *    from_uid = <me_id> and to_uid = to
    * */
    int from = src.from_uid;
    int to = src.to_uid;
    int me_id = ApiBase.uid;

    String where_str = "";
    List<dynamic> args;

    if (src.to_gid > 0) {
      where_str = "to_gid =?";
      args = [src.to_gid];
    } else if (from > 0 || to > 0) {
      //     发给我的消息：
      //        to_uid = <me_id> and from_uid = from
      //     我发的消息：
      //        from_uid = <me_id> and to_uid = to
      where_str = "(to_uid=? and from_uid =?) or "
          "(from_uid = ? and to_uid = ?) ";
      args = [me_id, from, me_id, to];
    } else {
      //

    }

    try {
      var i = await db.delete(_tb, where: where_str, whereArgs: args);
      print(" ##### del count: $i  ############");
      return i > 0;
    } catch (e) {
      print("****** db.delete err: ${e.toString()}");
      return false;
    }
  }

  Future<int> getNotReadCount(int from, int to, int to_gid) async {
//    * 发给我的消息：
//    *    to_uid = <me_id> and from_uid = from
//    * 我发的消息：
//    *    from_uid = <me_id> and to_uid = to
//    * */
    int me_id = ApiBase.uid;

    if (from > 0 || to > 0) {
      var i = Sqflite.firstIntValue(await db.rawQuery(
          "select count(*) from msg_his "
          " where ((to_uid = ? and from_uid = ?)or"
          " (from_uid = ? and to_uid = ?)) "
          " and (not_read_count >= 0 or not_read_count is null)",
          [me_id, from, me_id, to]));
      return i;
    }

    try {
      var i = Sqflite.firstIntValue(await db.rawQuery(
          "select count(*) from msg_his "
          " where to_gid = ? "
          "and not_read_count = 1",
          [to_gid]));
      return i;
    } catch (e) {
      print("****** msg_his->count err: ${e.toString()}");
    }
    return 0;
  }

  //action = 0,所有
  //action = 1,所有私聊
  //action = 2,所有群聊
  Future<List<MsgBody>> list(int action) async {
    List<Map<String, dynamic>> l;
    //action = 0,所有
    if (action == 0) {
      l = await db.query(
        _tb,
        orderBy: "on_top desc,created desc",
        limit: 10000,
      );
    }
    //action = 1,群聊
    if (action == 1) {
      l = await db.query(
        _tb,
        where: "to_gid > 0",
        orderBy: "on_top desc,created desc",
        limit: 10000,
      );
    }
    //action = 2,所有群聊
    if (action == 2) {
      l = await db.query(
        _tb,
        where: "to_uid > 0",
        orderBy: "on_top desc,created desc",
        limit: 10000,
      );
    }
    //------------------------------------------------
    List<MsgBody> result = l.map((each) {
      print(" ## msg_top of MsgBody.fromJson  ${each.toString()}");
      return MsgBody.fromJson(each);
    }).toList();
    return result;
  }

  Future<int> getOnTop(MsgBody src) async {
    int me_id = ApiBase.uid;
    int uid = (src.from_uid == me_id ? src.to_uid : src.from_uid);
    int bid = 0;
    return await new OnTopLocalDao(glbDB)
        .getOnTop(uid: uid, gid: src.to_gid, bid: bid);
  }

  Future<int> get_no_disturb(MsgBody src) async {
    int me_id = ApiBase.uid;
    int uid = (src.from_uid == me_id ? src.to_uid : src.from_uid);
    int bid = 0;
    return await new NoDisturbLocalDao(glbDB)
        .getValue(uid: uid, gid: src.to_gid, bid: bid);
  }
}
