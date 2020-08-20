import 'package:sqflite/sqflite.dart';

// ------------------------------------------------------
// author: whr    除本人外请勿更改，如果确有必要，请征得本人同意
// date  : 2020/5/27 12:21
// usage : 置顶信息缓存
//
// ------------------------------------------------------

class OnTopLocalDao {
  OnTopLocalDao(Database db) {
    this.db = db;
  }

  Database db;
  final _tb = "on_top_local";

  // ------------------------------------------------------
  // author: whr    除本人外请勿更改，如果确有必要，请征得本人同意
  // date  : 2020/5/27 14:53
  // usage : 在设置onTop时，需要同步调用此方法，改本地，優化性能
  //
  // ------------------------------------------------------
  Future<bool> cancelOnTop({
    int uid = 0,
    int gid = 0,
    int bid = 0,
  }) async {
    int id = bid;
    String attr = "bid";
    if (uid > 0) {
      attr = "uid";
      id = uid;
    } else if (gid > 0) {
      attr = "gid";
      id = gid;
    }
    return await rm(id, attr);
  }

  Future<bool> doOnTop({
    int uid = 0,
    int gid = 0,
    int bid = 0,
  }) async {
    int id = bid;
    String attr = "bid";
    if (uid > 0) {
      attr = "uid";
      id = uid;
    } else if (gid > 0) {
      attr = "gid";
      id = gid;
    }

    await rm(id, attr);

    //
    int i = await db.insert(_tb, {
      "id": id,
      "attr": attr,
      "on_top": 1,
    });
    return i > 0;
  }

  Future<bool> rm(int id, String attr) async {
    var i = await db
        .delete(_tb, where: "id= ? and attr = ?", whereArgs: [id, attr]);
    return i > 0;
  }

  //获取置顶状态
  Future<int> getOnTop({
    int uid = 0,
    int gid = 0,
    int bid = 0,
  }) async {
    int id = bid;
    String attr = "bid";
    if (uid > 0) {
      attr = "uid";
      id = uid;
    } else if (gid > 0) {
      attr = "gid";
      id = gid;
    }

    List<Map<String, dynamic>> l = await db.rawQuery(
        "select on_top from on_top_local where id = ? and attr = ?",
        [id, attr]);
    if (l != null && l.length > 0) {
      return Sqflite.firstIntValue(l);
    }

    //todo
    //--------------from http-------------

    //
    return 0;
  }
}
