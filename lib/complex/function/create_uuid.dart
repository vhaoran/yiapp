import 'package:uuid/uuid.dart';

// ------------------------------------------------------
// author：魏工
// date  ：2020/8/20 10:43
// usage ：
// ------------------------------------------------------

String newUUID(){
  var uuid = new Uuid();
  return uuid.v4();
}