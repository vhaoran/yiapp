// ------------------------------------------------------
// author: whr    除本人外请勿更改，如果确有必要，请征得本人同意
// date  : 2020/9/7 18:24
// usage : 大师主页中的图片介绍
// ------------------------------------------------------

class MasterImages {
  int id;
  int uid;
  String image_path;
  int sort_no;

  MasterImages({this.id, this.image_path, this.sort_no, this.uid});

  factory MasterImages.fromJson(Map<String, dynamic> json) {
    return MasterImages(
      id: json['id'],
      image_path: json['image_path'],
      sort_no: json['sort_no'],
      uid: json['uid'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['image_path'] = this.image_path;
    data['sort_no'] = this.sort_no;
    data['uid'] = this.uid;
    return data;
  }
}
