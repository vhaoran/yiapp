import 'package:sqflite/sqflite.dart';

Database glbDB;

// ------------------------------------------------------
// author: whr    除本人外请勿更改，如果确有必要，请征得本人同意
// date  : 2020/5/27 12:21
// usage :
//数据库初始化
// ------------------------------------------------------
Future<bool> initDB() async {
  try {
    var db = await _createDBAndTables();
    glbDB = db;
    return true;
  } catch (e) {
    print("***error:" + e.toString());
    return false;
  }
}

Future<Database> _createDBAndTables() async {
  String path = "a.db";
  // open the database
  Database db = await openDatabase(path, version: 1,
      onCreate: (Database conn, int version) async {
    // When creating the db, create the table
    await _create_msg_his(conn);
    await _create_msg_top(conn);
    await _create_onTopLocal(conn);
    await _create_no_disturb_Local(conn);
  });
  return db;
}

_create_msg_his(Database conn) async {
  return await conn.execute('CREATE TABLE msg_his ('
      'id Text PRIMARY KEY,'
      'msg_type  integer, '
      'from_icon text null, '
      'from_nick text  null, '
      'from_uid integer, '
      'from_user_code  text, '
      'to_uid integer, '
      'to_user_code  text, '
      'to_nick  text, '
      'to_icon text, '
      'to_gid integer,'
      'to_gicon   text , '
      'to_gname   text , '
      'body_type integer,'
      'body   text , '
      'not_read_count   integer,'
      'on_top   integer,'
      'created_at  text, '
      'created  integer '
      ')');
}

_create_msg_top(Database conn) async {
  return await conn.execute('CREATE TABLE msg_top ('
      'id Text PRIMARY KEY,'
      'msg_type  integer, '
      'from_icon text null, '
      'from_nick text  null, '
      'from_uid integer, '
      'from_user_code  text, '
      'to_uid integer, '
      'to_user_code  text, '
      'to_nick  text, '
      'to_icon text, '
      'to_gid integer,'
      'to_gicon   text , '
      'to_gname   text , '
      'body_type integer,'
      'body   text , '
      'not_read_count   integer,'
      'on_top   integer,'
      'no_disturb integer,'
      'created_at  text, '
      'created  integer '
      ')');
}

_create_onTopLocal(Database conn) async {
  return await conn.execute('CREATE TABLE on_top_local ('
      'id integer ,'
      'attr  text, '
      'on_top integer not null,'
      'PRIMARY KEY(id,attr) '
      ')');
}

_create_no_disturb_Local(Database conn) async {
  return await conn.execute('CREATE TABLE no_disturb_local ('
      'id integer ,'
      'attr  text, '
      'v integer not null,'
      'PRIMARY KEY(id,attr) '
      ')');
}
