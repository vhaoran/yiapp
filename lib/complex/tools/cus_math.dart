// ------------------------------------------------------
// author：suxing
// date  ：2020/8/6 17:27
// usage ：自定义数学运算
// ------------------------------------------------------

class CusMath {
  // 四舍五入保留小数(默认两位)
  static num asFixed(dynamic value, {int fixed = 2}) {
    if (value is double) {
      return num.parse(value.toStringAsFixed(fixed));
    } else if (value is String) {
      return num.parse(num.parse(value).toStringAsFixed(fixed));
    }
    return value; // 如果是int，不需要保留小数直接显示
  }
}