import 'package:sqflite/sqflite.dart';
import 'package:yiapp/complex/class/debug_log.dart';
import 'package:yiapp/complex/const/const_string.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/11/6 14:34
// usage ：初始化数据库
// ------------------------------------------------------

Database glbDB; // 全局的 db 对象

Future<bool> initDB() async {
  try {
    var db = await _createDBAndTables();
    glbDB = db;
    return true;
  } catch (e) {
    Debug.log("返回数据库对象出现异常：$e");
    return false;
  }
}

Future<Database> _createDBAndTables() async {
  String path = "db_table.db";
  Database db = await openDatabase(path, version: 1,
      onCreate: (Database db, int version) async {
    await _create_tb_login(db);
  });
  return db;
}

/// 存储用户登录信息的表
_create_tb_login(Database db) async {
  String sql = '''
  CREATE TABLE $tb_login (
  uid INTEGER PRIMARY KEY,
  is_admin INTEGER,
  is_broker_admin INTEGER,
  is_master INTEGER,
  jwt TEXT,
  enable_mall INTEGER,
  enable_master INTEGER,
  enable_prize INTEGER,
  enable_vie INTEGER,
  area TEXT,
  birth_day INTEGER,
  birth_month INTEGER,
  birth_year INTEGER,
  broker_id INTEGER,
  city TEXT,
  country TEXT,
  created_at TEXT,
  enabled INTEGER,
  icon TEXT,
  id_card TEXT,
  nick TEXT,
  province TEXT,
  pwd TEXT,
  sex INTEGER,
  update_at TEXT,
  user_code TEXT,
  user_name TEXT,
  ver INTEGER )
  ''';
  return await db.execute(sql);
}
