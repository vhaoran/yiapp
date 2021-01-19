// ------------------------------------------------------
// author：suxing
// date  ：2021/1/14 上午9:29
// usage ：更新app，以及无码邀请
// ------------------------------------------------------

/// 更新App
class UpdateRes {
  String url; // 更新地址
  String version; // 最新版本号

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

