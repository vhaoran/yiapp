// ------------------------------------------------------
// author：suxing
// date  ：2020/11/6 14:15
// usage ：数据类型转换
// ------------------------------------------------------

/// bool 转 num
num toInt(bool val) {
  return val ? 1 : 0;
}

/// num 转 bool
bool toBool(num val) {
  return val == 1 ? true : false;
}
