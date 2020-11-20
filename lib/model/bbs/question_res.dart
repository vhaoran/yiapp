// ------------------------------------------------------
// author：suxing
// date  ：2020/11/20 下午3:50
// usage ：提交悬赏、闪断帖的数据格式
// ------------------------------------------------------

class QuestionRes {
  String brief;
  QueContent content;
  QueLiuyao content_liuyao;
  int content_type;
  int score;
  String title;

  QuestionRes({
    this.brief,
    this.content,
    this.content_liuyao,
    this.content_type,
    this.score,
    this.title,
  });

  factory QuestionRes.fromJson(Map<String, dynamic> json) {
    return QuestionRes(
      brief: json['brief'],
      content:
          json['content'] != null ? QueContent.fromJson(json['content']) : null,
      content_liuyao: json['content_liuyao'] != null
          ? QueLiuyao.fromJson(json['content_liuyao'])
          : null,
      content_type: json['content_type'],
      score: json['score'],
      title: json['title'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['brief'] = this.brief;
    data['content_type'] = this.content_type;
    data['score'] = this.score;
    data['title'] = this.title;
    if (this.content != null) {
      data['content'] = this.content.toJson();
    }
    if (this.content_liuyao != null) {
      data['content_liuyao'] = this.content_liuyao.toJson();
    }
    return data;
  }
}

/// 悬赏/闪断 提交的六爻数据
class QueLiuyao {
  int year;
  int month;
  int day;
  int hour;
  String yao_code;

  QueLiuyao({
    this.year,
    this.month,
    this.day,
    this.hour,
    this.yao_code,
  });

  factory QueLiuyao.fromJson(Map<String, dynamic> json) {
    return QueLiuyao(
      year: json['year'],
      month: json['month'],
      day: json['day'],
      hour: json['hour'],
      yao_code: json['yao_code'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['year'] = this.year;
    data['month'] = this.month;
    data['day'] = this.day;
    data['hour'] = this.hour;
    data['yao_code'] = this.yao_code;
    return data;
  }
}

/// 悬赏/闪断 提交的内容数据
class QueContent {
  bool is_solar;
  String name;
  bool is_male;
  int year;
  int month;
  int day;
  int hour;
  int minutes;

  QueContent({
    this.is_solar,
    this.name,
    this.is_male,
    this.year,
    this.month,
    this.day,
    this.hour,
    this.minutes,
  });

  factory QueContent.fromJson(Map<String, dynamic> json) {
    return QueContent(
      is_solar: json['is_solar'],
      name: json['name'],
      is_male: json['is_male'],
      year: json['year'],
      month: json['month'],
      day: json['day'],
      hour: json['hour'],
      minutes: json['minutes'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['is_solar'] = this.is_solar;
    data['name'] = this.name;
    data['is_male'] = this.is_male;
    data['year'] = this.year;
    data['month'] = this.month;
    data['day'] = this.day;
    data['hour'] = this.hour;
    data['minutes'] = this.minutes;
    return data;
  }
}
