// ------------------------------------------------------
// author：suxing
// date  ：2020/9/23 15:49
// usage ：帖子内容
// ------------------------------------------------------

class BBSContent {
  int year;
  int month;
  int day;
  int hour;
  int minutes;
  bool is_male;
  bool is_solar;
  String name;

  BBSContent({
    this.year,
    this.month,
    this.day,
    this.hour,
    this.minutes,
    this.is_male,
    this.is_solar,
    this.name,
  });

  factory BBSContent.fromJson(Map<String, dynamic> json) {
    return BBSContent(
      year: json['year'],
      month: json['month'],
      day: json['day'],
      hour: json['hour'],
      minutes: json['minutes'],
      is_male: json['is_male'],
      is_solar: json['is_solar'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['year'] = this.year;
    data['month'] = this.month;
    data['day'] = this.day;
    data['hour'] = this.hour;
    data['minutes'] = this.minutes;
    data['is_male'] = this.is_male;
    data['is_solar'] = this.is_solar;
    data['name'] = this.name;
    return data;
  }
}
