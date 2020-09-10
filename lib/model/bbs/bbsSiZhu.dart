// ------------------------------------------------------
// author: whr    除本人外请勿更改，如果确有必要，请征得本人同意
// date  : 2020/9/10 16:31
// usage :
//  *****暂不用-----
// ------------------------------------------------------
class BBSSiZhu {
  //
  String name;

  //
  bool is_male;

  //
  bool is_solar;
  int year;
  int month;
  int day;
  int hour;
  int minutes;

  BBSSiZhu(
      {this.day,
      this.hour,
      this.is_male,
      this.is_solar,
      this.minutes,
      this.month,
      this.name,
      this.year});

  factory BBSSiZhu.fromJson(Map<String, dynamic> json) {
    return BBSSiZhu(
      day: json['day'],
      hour: json['hour'],
      is_male: json['is_male'],
      is_solar: json['is_solar'],
      minutes: json['minutes'],
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
    data['minutes'] = this.minutes;
    data['month'] = this.month;
    data['name'] = this.name;
    data['year'] = this.year;
    return data;
  }
}
