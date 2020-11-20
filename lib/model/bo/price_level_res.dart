// ------------------------------------------------------
// author：suxing
// date  ：2020/11/20 10:55
// usage ：用户查看，运营商悬赏帖收费标准
// ------------------------------------------------------

class PriceLevelRes {
  int id;
  int broker_id;
  String level_name;
  int price;
  int price_level_id;

  PriceLevelRes({
    this.id,
    this.broker_id,
    this.level_name,
    this.price,
    this.price_level_id,
  });

  factory PriceLevelRes.fromJson(Map<String, dynamic> json) {
    return PriceLevelRes(
      id: json['ID'],
      broker_id: json['broker_id'],
      level_name: json['level_name'],
      price: json['price'],
      price_level_id: json['price_level_id'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['ID'] = this.id;
    data['broker_id'] = this.broker_id;
    data['level_name'] = this.level_name;
    data['price'] = this.price;
    data['price_level_id'] = this.price_level_id;
    return data;
  }
}
