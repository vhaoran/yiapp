class ProductOrderAddr {
  //省
  String province;

  //市
  String city;

  //县区
  String area;

  //街道及详细地址
  String detail;

  //邮编
  String zipcode;

  //手机号
  String mobile;

  ProductOrderAddr({
    this.area,
    this.city,
    this.detail,
    this.province,
    this.zipcode,
    this.mobile,
  });

  factory ProductOrderAddr.fromJson(Map<String, dynamic> json) {
    return ProductOrderAddr(
      area: json['area'],
      city: json['city'],
      detail: json['detail'],
      province: json['province'],
      zipcode: json['zipcode'],
      mobile: json['mobile'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['area'] = this.area;
    data['city'] = this.city;
    data['detail'] = this.detail;
    data['province'] = this.province;
    data['zipcode'] = this.zipcode;
    data['mobile'] = this.mobile;
    return data;
  }
}
