// ------------------------------------------------------
// author: whr    除本人外请勿更改，如果确有必要，请征得本人同意
// date  : 2020/9/8 15:47
// usage : 大师订单内容--排四柱
//
// ------------------------------------------------------
class YiOrderSiZhu {
  //姓名，可以没有
  String name;

  //true :男性 false:女性
  bool is_male;

  //true:生日为公历（太阳历） false:nong历
  bool is_solar;

  int year;
  int month;
  int day;
  int hour;
  int minute;

  YiOrderSiZhu(
      {this.day,
      this.hour,
      this.is_male,
      this.is_solar,
      this.minute,
      this.month,
      this.name,
      this.year});

  factory YiOrderSiZhu.fromJson(Map<String, dynamic> json) {
    return YiOrderSiZhu(
      day: json['day'],
      hour: json['hour'],
      is_male: json['is_male'],
      is_solar: json['is_solar'],
      minute: json['minute'],
      month: json['month'],
      name: json['name'],
      year: json['year'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['day'] = this.day;
    data['hour'] = this.hour;
    data['is_male'] = this.is_male;
    data['is_solar'] = this.is_solar;
    data['minute'] = this.minute;
    data['month'] = this.month;
    data['name'] = this.name;
    data['year'] = this.year;
    return data;
  }
}
