class YiOrderLiuYao {
  //卦的代码
  String yao_code;

  //这是公历表示的日期
  int year;
  int month;
  int day;
  int hour;
  int minute;

  //是否为男性
  bool is_male;

  YiOrderLiuYao({
    this.day,
    this.hour,
    this.month,
    this.yao_code,
    this.year,
    this.minute,
    this.is_male,
  });

  factory YiOrderLiuYao.fromJson(Map<String, dynamic> json) {
    return YiOrderLiuYao(
      day: json['day'],
      hour: json['hour'],
      month: json['month'],
      yao_code: json['yao_code'],
      year: json['year'],
      minute: json['minute'],
      is_male: json['is_male'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['day'] = this.day;
    data['hour'] = this.hour;
    data['month'] = this.month;
    data['yao_code'] = this.yao_code;
    data['year'] = this.year;
    data['minute'] = this.minute;
    data['is_male'] = this.is_male;
    return data;
  }
}
