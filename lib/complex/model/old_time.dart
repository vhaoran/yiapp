// ------------------------------------------------------
// author：suxing
// date  ：2020/9/11 17:12
// usage ：如午时，hour = 11，minute = 30
// ------------------------------------------------------

class OldTime {
  final int hour;
  final int minute;

  OldTime(this.hour, this.minute);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['hour'] = this.hour;
    data['minute'] = this.minute;
    return data;
  }

  /// 根据时辰，返回时分，如 time = "午时"，则 hour:11，minuter统一为30
  factory OldTime.from(String time) {
    int hour;
    switch (time) {
      case "早子":
        hour = 0;
        break;
      case "丑时":
        hour = 1;
        break;
      case "寅时":
        hour = 3;
        break;
      case "卯时":
        hour = 5;
        break;
      case "辰时":
        hour = 7;
        break;
      case "巳时":
        hour = 9;
        break;
      case "午时":
        hour = 11;
        break;
      case "未时":
        hour = 13;
        break;
      case "申时":
        hour = 15;
        break;
      case "酉时":
        hour = 17;
        break;
      case "戌时":
        hour = 19;
        break;
      case "亥时":
        hour = 21;
        break;
      case "晚子":
        hour = 23;
        break;
      default:
        hour = 11;
        break;
    }
    return OldTime(hour, 30);
  }
}
