import 'package:flutter/material.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/8/12 16:25
// usage ：返回值为 bool 类型的功能函数
// ------------------------------------------------------

/// 数据是否加载完毕
bool snapDone(AsyncSnapshot snap) {
  if (snap.connectionState == ConnectionState.done) return true;
  return false;
}
