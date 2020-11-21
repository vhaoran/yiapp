// ------------------------------------------------------
// author：suxing
// date  ：2020/8/31 18:57
// usage ：数学运算工具
// ------------------------------------------------------

class CusMath {
  /// [up] 默认为true，代表升序，false代表降序
  static List<num> listSort(List<num> l, {bool up = true}) {
    num temp = 0; // 临时变量，用来接收两元素中较大或者较小的元素
    // 外循环控制轮数
    for (num i = 0; i < l.length - 1; i++) {
      bool isSort = true;
      // 内循环两两元素比较
      if (up) {
        for (num j = 0; j < l.length - 1 - i; j++) {
          // 从左往右，依次递增
          if (l[j] > l[j + 1]) {
            temp = l[j];
            l[j] = l[j + 1];
            l[j + 1] = temp;
            isSort = false;
          }
        }
      } else {
        for (num j = 0; j < l.length - 1 - i; j++) {
          // 从左往右，依次递减
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
