// ------------------------------------------------------
// author：suxing
// date  ：2020/8/31 18:57
// usage ：数学运算工具
// ------------------------------------------------------

class MathUtil {
  /// up 默认升序
  static List<num> listSort(List<num> l, {bool up = true}) {
    num temp = 0; // 临时变量，用来接收两元素中较大或者较小的元素
    // 外循环控制轮数，内循环两两元素比较
    for (num i = 0; i < l.length - 1; i++) {
      bool isSort = true;
      // 升序
      if (up) {
        for (num j = 0; j < l.length - 1 - i; j++) {
          if (l[j] > l[j + 1]) {
            temp = l[j];
            l[j] = l[j + 1];
            l[j + 1] = temp;
            isSort = false;
          }
        }
      }
      // 降序
      else {
        for (num j = 0; j < l.length - 1 - i; j++) {
          if (l[j] < l[j + 1]) {
            temp = l[j];
            l[j] = l[j + 1];
            l[j + 1] = temp;
            isSort = false;
          }
        }
      }
      if (isSort) break;
    }
    return l;
  }
}
