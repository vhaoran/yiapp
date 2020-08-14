// ------------------------------------------------------
// author：suxing
// date  ：2020/8/13 16:25
// usage ：黄历中不变的数据
// ------------------------------------------------------

class CalendarConst {
  static const int single_mode = 1; // 单选或者
  static const int multiple_mode = 2; // 多选模式

  // 展示模式
  static const int only_month = 1; // 仅支持月视图
  static const int only_week = 2; // 仅支持星期视图
  static const int week_month = 3; // 支持两种视图，先显示周视图
  static const int month_week = 4; // 支持两种视图，先显示月视图

  // 一周
  static const List<String> weeks = [
    "周一",
    "周二",
    "周三",
    "周四",
    "周五",
    "周六",
    "周日",
  ];

  // 农历的月份
  static const List<String> lunar_month = [
    "一月", // 春节
    "二月",
    "三月",
    "四月",
    "五月",
    "六月",
    "七月",
    "八月",
    "九月",
    "十月",
    "十一月", // 冬月
    "十二月", // 腊月
  ];

  // 农历的日期
  static const List<String> lunar_day = [
    "初一",
    "初二",
    "初三",
    "初四",
    "初五",
    "初六",
    "初七",
    "初八",
    "初九",
    "初十",
    "十一",
    "十二",
    "十三",
    "十四",
    "十五",
    "十六",
    "十七",
    "十八",
    "十九",
    "二十",
    "廿一",
    "廿二",
    "廿三",
    "廿四",
    "廿五",
    "廿六",
    "廿七",
    "廿八",
    "廿九",
    "三十"
  ];

  /// 注：天干地支的最后一位，取余为0，所以将天干地支中最后一位提到数组首位

  /// 天干：甲、乙、丙、丁、戊、己、庚、辛、壬、癸
  static const List<String> day_stem = [
    "癸",
    "甲",
    "乙",
    "丙",
    "丁",
    "戊",
    "己",
    "庚",
    "辛",
    "壬",
  ];

  /// 地支
  static const List<String> earth_branch = [
    "亥",
    "子",
    "丑",
    "寅",
    "卯",
    "辰",
    "巳",
    "午",
    "未",
    "申",
    "酉",
    "戌",
  ];
}