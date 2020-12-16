// ------------------------------------------------------
// author：suxing
// date  ：2020/12/16 下午5:12
// usage ：不同身份，不同需求时帖子的动态设置
// ------------------------------------------------------

class Post {
  bool is_vie; // 是否闪断帖
  bool is_his; // 是否查询历史帖子
  bool is_ing; // 是否正在处理中的单子
  dynamic data; // 单条帖子的数据

  Post({
    this.is_vie: false,
    this.is_his: false,
    this.is_ing: false,
    this.data,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      is_vie: json['is_vie'],
      is_his: json['is_his'],
      is_ing: json['is_ing'],
      data: json['data'] != null ? json['data'] : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['is_vie'] = this.is_vie;
    data['is_his'] = this.is_his;
    data['is_ing'] = this.is_ing;
    if (this.data != null) {
      data['data'] = this.data;
    }
    return data;
  }
}
