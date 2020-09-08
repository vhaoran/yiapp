// ------------------------------------------------------
// author：suxing
// date  ：2020/9/8 17:17
// usage ：收货地址 Model 类
// ------------------------------------------------------

class AddressResult {
  String area;
  String city;
  String contact_person; // 收件人
  String detail; // 详情地址
  int id; // 收货地址的 id
  String mobile;
  String province;
  int uid;
  String zipcode; // 邮政编码

  AddressResult({
    this.area,
    this.city,
    this.contact_person,
    this.detail,
    this.id,
    this.mobile,
    this.province,
    this.uid,
    this.zipcode,
  });

  factory AddressResult.fromJson(Map<String, dynamic> json) {
    return AddressResult(
      area: json['area'],
      city: json['city'],
      contact_person: json['contact_person'],
      detail: json['detail'],
      id: json['id'],
      mobile: json['mobile'],
      province: json['province'],
      uid: json['uid'],
      zipcode: json['zipcode'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['area'] = this.area;
    data['city'] = this.city;
    data['contact_person'] = this.contact_person;
    data['detail'] = this.detail;
    data['id'] = this.id;
    data['mobile'] = this.mobile;
    data['province'] = this.province;
    data['uid'] = this.uid;
    data['zipcode'] = this.zipcode;
    return data;
  }
}
