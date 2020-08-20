
// ------------------------------------------------------
// author: whr    除本人外请勿更改，如果确有必要，请征得本人同意
// date  : 2020/4/7 12:14
// usage : 群基本信息
// ------------------------------------------------------

class Group {
  String created_at;
  bool exchange_info;
  int g_member_count;
  int ID;
  String icon;
  bool join_confirm;
  String name;
  int owner_id;
  bool recommend;
  String update_at;

  Group(
      {this.created_at,
      this.exchange_info,
      this.g_member_count,
      this.ID,
      this.icon,
      this.join_confirm,
      this.name,
      this.owner_id,
      this.recommend,
      this.update_at});

  factory Group.fromJson(Map<String, dynamic> json) {
    if (json == null){
      return null;
    }


    return Group(
      created_at: json['created_at'],
      exchange_info: json['exchange_info'],
      g_member_count: json['g_member_count'],
      ID: json['ID'],
      icon: json['icon'],
      join_confirm: json['join_confirm'],
      name: json['name'],
      owner_id: json['owner_id'],
      recommend: json['recommend'],
      update_at: json['update_at'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['created_at'] = this.created_at;
    data['exchange_info'] = this.exchange_info;
    data['g_member_count'] = this.g_member_count;
    data['ID'] = this.ID;
    data['icon'] = this.icon;
    data['join_confirm'] = this.join_confirm;
    data['name'] = this.name;
    data['owner_id'] = this.owner_id;
    data['recommend'] = this.recommend;
    data['update_at'] = this.update_at;
    return data;
  }
}
