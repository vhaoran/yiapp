import 'package:yiapp/complex/widgets/cus_time_picker/picker_mode.dart';

/// 值发生变化时的回调
typedef FnDateChanged(dynamic time);
//typedef FnDateChanged(DateTime time);

/// 根据选择日期的索引显示时间
typedef String FnSelectStr(int index);

/// 根据模式返回 String 或者 int[] 类型
dynamic dateRes(List<int> l, PickerMode mode, bool isString) {
  dynamic ls;
  switch (mode) {
    case PickerMode.year:
      isString ? ls = "${l.first}年" : ls.add(l.first);
      break;
    case PickerMode.year_month:
      isString ? ls = "${l.first}年${l[1]}月" : ls.addAll([l.first, l[1]]);
      break;
    case PickerMode.month_day:
      isString ? ls = "${l[1]}月${l[2]}日" : ls.addAll([l[1], l[2]]);
      break;
    case PickerMode.date:
      isString
          ? ls = "${l.first}年${l[1]}月${l[2]}日"
          : ls.addAll([l.first, l[1], l[2]]);
      break;
    case PickerMode.hour_minute:
      isString ? ls = "${l[3]}时${l[4]}分" : ls.addAll([l[3], l[4]]);
      break;
    case PickerMode.full:
      isString
          ? ls = "${l.first}年${l[1]}月${l[2]}日${l[3]}时${l[4]}分"
          : ls.addAll([l.first, l[1], l[2], l[3], l[4]]);
      break;
    default:
      break;
  }
  return ls;
}
