import 'package:sqflite/sqflite.dart';
import 'package:yiapp/complex/const/const_string.dart';
import 'package:yiapp/model/login/login_table.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/11/4 16:15
// usage ：存储用户登录信息表
// ------------------------------------------------------

class LoginDao {
  Database db;

  LoginDao(this.db);

  /// 存储登陆信息到本地数据库
  Future<int> saveLogin(CusLoginRes table) async {
    int r = await db.insert(tb_login, table.toJson());
    debug("保存用户数据结果:", r);
    return r;
  }

  /// 获取全部数据
  Future<List<CusLoginRes>> findAll() async {
    List<Map<String, dynamic>> result = await db.query(tb_login);
    print(">>>数据库长度：${result.length}");
    return result.isNotEmpty
        ? result.map((e) {
            return CusLoginRes.fromJson(e);
          }).toList()
        : [];
  }

  // 根据条件查询，比如查询某个uid的用户
  Future<List<CusLoginRes>> find(int uid) async {
    List<Map<String, dynamic>> result =
        await db.query(tb_login, where: 'uid=?', whereArgs: [uid], limit: 1);
    return result.isNotEmpty
        ? result.map((e) {
            return CusLoginRes.fromJson(e);
          }).toList()
        : [];
  }

  // 根据 User id 更新数据
  Future<int> update(CusLoginRes table) async {
    return await db.update(tb_login, table.toJson(),
        where: 'uid = ?', whereArgs: [table.uid]);
  }

  // 根据 id 删除符合条件的数据
  Future<int> delete(int uid) async {
    return await db.delete(tb_login, where: 'uid = ?', whereArgs: [uid]);
  }

  /// 清空全部数据
  Future<int> deleteAll() async {
    return await db.delete(tb_login);
  }

  /// 查找是vip的
  Future<List<CusLoginRes>> findVip() async {
    List<Map<String, dynamic>> result =
        await db.rawQuery("SELECT * FROM login_res WHERE broker_id>0");
    return result.isNotEmpty
        ? result.map((e) {
            return CusLoginRes.fromJson(e);
          }).toList()
        : [];
  }

  /// 查找昵称中含有"长江"
  Future<List<CusLoginRes>> containsCJ() async {
    List<Map<String, dynamic>> result =
        await db.rawQuery("SELECT * FROM login_res WHERE nick LIKE '%长江%'");
    return result.isNotEmpty
        ? result.map((e) {
            return CusLoginRes.fromJson(e);
          }).toList()
        : [];
  }

  /// 修改 uid = 11中的nick
  Future<List<CusLoginRes>> setNick() async {
    List<Map<String, dynamic>> result =
        await db.rawQuery("UPDATE login_res SET nick='游客2号' WHERE uid=11");
    return result.isNotEmpty
        ? result.map((e) {
            return CusLoginRes.fromJson(e);
          }).toList()
        : [];
  }

  /// 根据 token 选择账号
  Future<List<CusLoginRes>> byJwt(String jwt) async {
    List<Map<String, dynamic>> result =
        await db.rawQuery("SELECT * FROM $tb_login WHERE jwt='$jwt'");
    return result.isNotEmpty
        ? result.map((e) {
            return CusLoginRes.fromJson(e);
          }).toList()
        : [];
  }

  void debug(String str, int res) {
    print(">>>$str：${res > 0 ? '成功' : "失败"}，res:$res");
  }
}
