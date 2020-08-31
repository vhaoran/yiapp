// ------------------------------------------------------
// author：suxing
// date  ：2020/8/31 18:57
// usage ：数学运算工具
// ------------------------------------------------------

import 'dart:math';

class CusMath {
  /// 根据当前时间的毫秒数，随机生成该数，并取相应的模
  static int random({int mod = 200}) {
    int res = DateTime.now().millisecond % mod;
    if (res == 0) {
      Random r = Random();
      res = r.nextInt(mod);
    }
    return res;
  }
}
