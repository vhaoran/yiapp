import 'package:yiapp/model/complex/yi_date_time.dart';

/// 普通日历的回调
typedef FnDateChanged(DateTime time);

/// 点击确定按钮的回调
typedef FnOnConfirm(YiDateTime time);

/// 根据选择日期的索引显示时间
typedef String FnSelectStr(int index);
