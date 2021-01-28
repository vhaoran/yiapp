// ------------------------------------------------------
// author：suxing
// date  ：2021/1/28 下午5:18
// usage ：四柱 - 八字
// ------------------------------------------------------

class SiZhuBaZi {
  int day;
  int hour;
  bool is_male;
  int minute;
  int month;
  int nian;
  String nian_gan;
  String nian_zhi;
  int ri;
  String ri_gan;
  String ri_zhi;
  String shi;
  String shi_gan;
  String shi_zhi;
  int year;
  int yue;
  String yue_gan;
  String yue_zhi;

  SiZhuBaZi({
    this.day,
    this.hour,
    this.is_male,
    this.minute,
    this.month,
    this.nian,
    this.nian_gan,
    this.nian_zhi,
    this.ri,
    this.ri_gan,
    this.ri_zhi,
    this.shi,
    this.shi_gan,
    this.shi_zhi,
    this.year,
    this.yue,
    this.yue_gan,
    this.yue_zhi,
  });

  factory SiZhuBaZi.fromJson(Map<String, dynamic> json) {
    return SiZhuBaZi(
      day: json['day'],
      hour: json['hour'],
      is_male: json['is_male'],
      minute: json['minute'],
      month: json['month'],
      nian: json['nian'],
      nian_gan: json['nian_gan'],
      nian_zhi: json['nian_zhi'],
      ri: json['ri'],
      ri_gan: json['ri_gan'],
      ri_zhi: json['ri_zhi'],
      shi: json['shi'],
      shi_gan: json['shi_gan'],
      shi_zhi: json['shi_zhi'],
      year: json['year'],
      yue: json['yue'],
      yue_gan: json['yue_gan'],
      yue_zhi: json['yue_zhi'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['day'] = this.day;
    data['hour'] = this.hour;
    data['is_male'] = this.is_male;
    data['minute'] = this.minute;
    data['month'] = this.month;
    data['nian'] = this.nian;
    data['nian_gan'] = this.nian_gan;
    data['nian_zhi'] = this.nian_zhi;
    data['ri'] = this.ri;
    data['ri_gan'] = this.ri_gan;
    data['ri_zhi'] = this.ri_zhi;
    data['shi'] = this.shi;
    data['shi_gan'] = this.shi_gan;
    data['shi_zhi'] = this.shi_zhi;
    data['year'] = this.year;
    data['yue'] = this.yue;
    data['yue_gan'] = this.yue_gan;
    data['yue_zhi'] = this.yue_zhi;
    return data;
  }
}
