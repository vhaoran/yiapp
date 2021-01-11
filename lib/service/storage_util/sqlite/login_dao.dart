import 'package:sqflite/sqflite.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/const/con_string.dart';
import 'package:yiapp/model/login/cus_login_res.dart';
import 'package:yiapp/service/api/api_base.dart';
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
  Future<bool> insert(SqliteLoginRes login) async {
    int val = await db.insert(tb_login, login.toJson());
    Log.info("保存用户数据${val > 0 ? '成功' : "失败"}");
    return val > 0 ? true : false;
  }

  // ----------------------------- 删 -----------------------------
  /// 根据用户uid，删除符合条件的数据
  Future<bool> delete(num uid) async {
    int val = await db.delete(tb_login, where: 'uid = ?', whereArgs: [uid]);
    return val > 0 ? true : false;
  }

  /// 清空全部数据
  Future<bool> deleteAll() async {
    return await db.delete(tb_login) > 0 ? true : false;
  }

  // ----------------------------- 改 -----------------------------
  /// 根据 uid，整体更新用户数据
  Future<bool> update(SqliteLoginRes login) async {
    int val = await db.update(tb_login, login.toJson(),
        where: 'uid = ?', whereArgs: [login.uid]);
    return val > 0 ? true : false;
  }

  /// 根据 uid 修改昵称
  Future<bool> updateNick(String nick) async {
    String sql = "UPDATE $tb_login SET nick='$nick' WHERE uid=${ApiBase.uid}";
    int val = await db.rawUpdate(sql);
    return val > 0 ? true : false;
  }

  /// 根据 uid 修改密码
  Future<bool> updatePwd(String pwd) async {
    String sql = "UPDATE $tb_login SET pwd='$pwd' WHERE uid=${ApiBase.uid}";
    int val = await db.rawUpdate(sql);
    return val > 0 ? true : false;
  }

  /// 根据 uid 修改头像
  Future<bool> updateIcon(String icon) async {
    String sql = "UPDATE $tb_login SET icon='$icon' WHERE uid=${ApiBase.uid}";
    int val = await db.rawUpdate(sql);
    return val > 0 ? true : false;
  }

  /// 根据 uid 修改性别
  Future<bool> updateSex(num sex) async {
    String sql = "UPDATE $tb_login SET sex=$sex WHERE uid=${ApiBase.uid}";
    int val = await db.rawUpdate(sql);
    return val > 0 ? true : false;
  }

  /// 根据 uid 修改出生日期
  Future<bool> updateBirth(
      num birth_year, num birth_month, num birth_day) async {
    String sql =
        "UPDATE $tb_login SET birth_year=$birth_year,birth_month=$birth_month,"
        "birth_day=$birth_day WHERE uid=${ApiBase.uid}";
    int val = await db.rawUpdate(sql);
    return val > 0 ? true : false;
  }

  /// 根据 uid 绑定手机号
  Future<bool> updateUserCode(String user_code) async {
    String sql =
        "UPDATE $tb_login SET user_code=$user_code WHERE uid=${ApiBase.uid}";
    int val = await db.rawUpdate(sql);
    return val > 0 ? true : false;
  }

  // ----------------------------- 查 -----------------------------
  /// 游客登录(本地数据库的第一条信息)
  Future<SqliteLoginRes> readGuest() async {
    List<Map<String, dynamic>> l = await db.query(tb_login, limit: 1);
    if (l.isEmpty) return SqliteLoginRes();
    return SqliteLoginRes.fromJson(l.first);
  }

  /// 根据 token 选择账号
  Future<SqliteLoginRes> readUserByJwt() async {
    String jwt = await KV.getStr(kv_jwt);
    List<Map<String, dynamic>> l =
        await db.query(tb_login, where: "jwt=?", whereArgs: [jwt], limit: 1);
    if (l.isEmpty) return SqliteLoginRes();
    return SqliteLoginRes.fromJson(l.first);
  }

  /// 根据 uid 查找用户
  Future<SqliteLoginRes> readUserByUid() async {
    List<Map<String, dynamic>> l = await db.query(tb_login,
        where: 'uid=?', whereArgs: [ApiBase.uid], limit: 1);
    if (l.isEmpty) return SqliteLoginRes();
    return SqliteLoginRes.fromJson(l.first);
  }

  /// 根据 user_code 查找用户
  Future<SqliteLoginRes> readUserByCode(String user_code) async {
    List<Map<String, dynamic>> l = await db.query(tb_login,
        where: 'user_code=?', whereArgs: [user_code], limit: 1);
    if (l.isEmpty) return SqliteLoginRes();
    return SqliteLoginRes.fromJson(l.first);
  }

  /// 用户存在性
  Future<bool> exists(num uid) async {
    List<Map<String, dynamic>> l =
        await db.query(tb_login, where: 'uid=?', whereArgs: [uid]);
    if (l.isNotEmpty) return true;
    return false;
  }

  /// 获取所有登录信息
  Future<List<SqliteLoginRes>> readAll() async {
    List<Map<String, dynamic>> l = await db.query(tb_login);
    if (l.isEmpty) return [];
    return l.map((e) => SqliteLoginRes.fromJson(e)).toList();
  }
}
