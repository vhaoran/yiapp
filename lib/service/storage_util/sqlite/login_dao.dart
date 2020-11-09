import 'package:sqflite/sqflite.dart';
import 'package:yiapp/complex/class/debug_log.dart';
import 'package:yiapp/complex/const/const_string.dart';
import 'package:yiapp/model/login/login_table.dart';
import 'package:yiapp/service/storage_util/prefs/kv_storage.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/11/4 16:15
// usage ：存储用户登录信息表
// ------------------------------------------------------

class LoginDao {
  final Database db;

  LoginDao(this.db);

  // ----------------------------- 增 -----------------------------
  /// 存储登录信息
  Future<int> insert(CusLoginRes login) async {
    int val = await db.insert(tb_login, login.toJson());
    if (val > 0) {
      // 存储本地token
      await KV.setStr(kv_jwt, login.jwt);
    }
    Debug.log("保存用户数据${val > 0 ? '成功' : "失败"}");
    return val;
  }

  // ----------------------------- 删 -----------------------------
  /// 根据用户uid，删除符合条件的数据
  Future<int> delete(int uid) async {
    int val = await db.delete(tb_login, where: 'uid = ?', whereArgs: [uid]);
    return val;
  }

  // ----------------------------- 改 -----------------------------
  /// 根据 uid，整体更新用户数据
  Future<int> update(CusLoginRes login) async {
    int val = await db.update(tb_login, login.toJson(),
        where: 'uid = ?', whereArgs: [login.uid]);
    return val;
  }

  /// 根据 uid 修改昵称
  Future<List<CusLoginRes>> updateNick(int uid, String nick) async {
    String sql = "UPDATE $tb_login SET nick='$nick' WHERE uid=$uid";
    List<Map<String, dynamic>> l = await db.rawQuery(sql);
    if (l.isEmpty) return [];
    return l.map((e) => CusLoginRes.fromJson(e)).toList();
  }

  // ----------------------------- 查 -----------------------------
  /// 获取所有登录信息
  Future<List<CusLoginRes>> findAll() async {
    List<Map<String, dynamic>> l = await db.query(tb_login);
    Debug.log("数据库长度：${l.length}");
    if (l.isEmpty) return [];
    return l.map((e) => CusLoginRes.fromJson(e)).toList();
  }

  /// 根据 token 选择账号
  Future<CusLoginRes> verifyJwt(String jwt) async {
    List<Map<String, dynamic>> l =
        await db.query(tb_login, where: "jwt=?", whereArgs: [jwt], limit: 1);
    if (l.isEmpty) return CusLoginRes();
    return CusLoginRes.fromJson(l.first);
  }

  /// 根据 uid 查找用户
  Future<CusLoginRes> findUser(int uid) async {
    List<Map<String, dynamic>> l =
        await db.query(tb_login, where: 'uid=?', whereArgs: [uid], limit: 1);
    if (l.isEmpty) return CusLoginRes();
    return CusLoginRes.fromJson(l.first);
  }

  // ------------------------ 以下是未用到的 ------------------------

  /// 清空全部数据
  Future<int> deleteAll() async {
    return await db.delete(tb_login);
  }

  /// 查找是正式会员的
  Future<List<CusLoginRes>> findVip() async {
    String sql = "SELECT * FROM $tb_login WHERE broker_id>0";
    List<Map<String, dynamic>> l = await db.rawQuery(sql);
    if (l.isEmpty) return [];
    return l.map((e) => CusLoginRes.fromJson(e)).toList();
  }

  /// 查找昵称中含有"长江"
  Future<List<CusLoginRes>> containsCJ() async {
    String sql = "SELECT * FROM $tb_login WHERE nick LIKE '%长江%'";
    List<Map<String, dynamic>> l = await db.rawQuery(sql);
    if (l.isEmpty) return [];
    return l.map((e) => CusLoginRes.fromJson(e)).toList();
  }
}
