import 'package:sqflite/sqflite.dart';

// ------------------------------------------------------
// author: whr    除本人外请勿更改，如果确有必要，请征得本人同意
// date  : 2020/5/27 12:22
// usage : 名打扰信息缓存
//
// ------------------------------------------------------
class NoDisturbLocalDao {
  NoDisturbLocalDao(Database db) {
    this.db = db;
  }

  Database db;
  final _tb = "no_disturb_local";

  Future<bool> cancel({
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

  // usage : 在设置名打扰时，需要同步调用此方法，改本地，優化性能
  Future<bool> push({
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
      "v": 1,
    });
    return i > 0;
  }

  Future<bool> rm(int id, String attr) async {
    var i = await db
        .delete(_tb, where: "id= ? and attr = ?", whereArgs: [id, attr]);
    return i > 0;
  }

  //获取置顶状态
  Future<int> getValue({
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
        "select v from no_disturb_local where id = ? and attr = ?", [id, attr]);
    if (l != null && l.length > 0) {
      return Sqflite.firstIntValue(l);
    }
    //-------------http---------------------
    // todo whr

    return 0;
  }
}
