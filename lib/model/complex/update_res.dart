// ------------------------------------------------------
// author：suxing
// date  ：2021/1/14 上午9:29
// usage ：更新app的结果
// ------------------------------------------------------

class UpdateRes {
  String url;
  String version;

  UpdateRes({this.url, this.version});

  factory UpdateRes.fromJson(Map<String, dynamic> json) {
    return UpdateRes(
      url: json['url'],
      version: json['version'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['url'] = this.url;
    data['version'] = this.version;
    return data;
  }
}
