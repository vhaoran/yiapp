class Product {
  String id_of_es;
  int cate_id;
  String cate_name;

  String name;
  String key_word;
  String image_main;
  String remark;

  List<ProductColor> colors;
  List<ProductImage> images;
  bool enabled;

  String created;
  String last_updated;
  int visit_count;

  Product({
    this.cate_id,
    this.cate_name,
    this.colors,
    this.created,
    this.enabled,
    this.id_of_es,
    this.image_main,
    this.images,
    this.key_word,
    this.last_updated,
    this.name,
    this.remark,
    this.visit_count,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      cate_id: json['cate_id'],
      cate_name: json['cate_name'],
      colors: json['colors'] != null
          ? (json['colors'] as List)
              .map((i) => ProductColor.fromJson(i))
              .toList()
          : null,
      created: json['created'],
      enabled: json['enabled'],
      id_of_es: json['id_of_es'],
      image_main: json['image_main'],
      images: json['images'] != null
          ? (json['images'] as List)
              .map((i) => ProductImage.fromJson(i))
              .toList()
          : null,
      key_word: json['key_word'],
      last_updated: json['last_updated'],
      name: json['name'],
      remark: json['remark'],
      visit_count: json['visit_count'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cate_id'] = this.cate_id;
    data['cate_name'] = this.cate_name;
    data['created'] = this.created;
    data['enabled'] = this.enabled;
    data['id_of_es'] = this.id_of_es;
    data['image_main'] = this.image_main;
    data['key_word'] = this.key_word;
    data['last_updated'] = this.last_updated;
    data['name'] = this.name;
    data['remark'] = this.remark;
    data['visit_count'] = this.visit_count;
    if (this.colors != null) {
      data['colors'] = this.colors.map((v) => v.toJson()).toList();
    }
    if (this.images != null) {
      data['images'] = this.images.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ProductImage {
  String path;
  int sort_no;

  ProductImage({this.path, this.sort_no});

  factory ProductImage.fromJson(Map<String, dynamic> json) {
    return ProductImage(
      path: json['path'],
      sort_no: json['sort_no'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['path'] = this.path;
    data['sort_no'] = this.sort_no;
    return data;
  }
}

class ProductColor {
  String code;
  int price;

  ProductColor({this.code, this.price});

  factory ProductColor.fromJson(Map<String, dynamic> json) {
    return ProductColor(
      code: json['code'],
      price: json['price'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['price'] = this.price;
    return data;
  }
}
