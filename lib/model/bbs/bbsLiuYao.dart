// ------------------------------------------------------
// author: whr    除本人外请勿更改，如果确有必要，请征得本人同意
// date  : 2020/9/10 15:46
// usage : bbs类功能中的六多表示
//   *****暂不用-----
// ------------------------------------------------------
class BBSLiuYao {
  //日期为公历日期及时间
  String yao_code;
  int year;
  int month;
  int day;
  int hour;

  BBSLiuYao({this.day, this.hour, this.month, this.yao_code, this.year});

  factory BBSLiuYao.fromJson(Map<String, dynamic> json) {
    return BBSLiuYao(
      day: json['day'],
      hour: json['hour'],
      month: json['month'],
      yao_code: json['yao_code'],
      year: json['year'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['day'] = this.day;
    data['hour'] = this.hour;
    data['month'] = this.month;
    data['yao_code'] = this.yao_code;
    data['year'] = this.year;
    return data;
  }
}
