// ------------------------------------------------------
// author：suxing
// date  ：2020/11/3 14:24
// usage ：运营商选择的服务项目 0 禁用 1 启用
// ------------------------------------------------------

class Modules {
  int enable_mall; // 商城
  int enable_master; // 大师
  int enable_prize; // 悬赏帖
  int enable_vie; // 闪断帖

  Modules({
    this.enable_mall,
    this.enable_master,
    this.enable_prize,
    this.enable_vie,
  });

  Modules.fromJson(Map<String, dynamic> json) {
    enable_mall = json['enable_mall'];
    enable_master = json['enable_master'];
    enable_prize = json['enable_prize'];
    enable_vie = json['enable_vie'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['enable_mall'] = this.enable_mall;
    data['enable_master'] = this.enable_master;
    data['enable_prize'] = this.enable_prize;
    data['enable_vie'] = this.enable_vie;
    return data;
  }
}
