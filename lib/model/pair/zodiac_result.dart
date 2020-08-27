// ------------------------------------------------------
// author：suxing
// date  ：2020/8/27 10:29
// usage ：生肖配对结果
// ------------------------------------------------------

class ZodiacResult {
  String biao_bai; // 最佳表白日
  List<String> flower; // 定情花
  String gem; // 定情宝石
  String name; // 配对名
  String oath; // 宣言
  String qing_yuan; // 情缘
  List<String> result; // 配对结果

  ZodiacResult(
      {this.biao_bai,
      this.flower,
      this.gem,
      this.name,
      this.oath,
      this.qing_yuan,
      this.result});

  ZodiacResult.fromJson(Map<String, dynamic> json) {
    this.biao_bai = json['biao_bai'];
    this.flower =
        json['flower'] != null ? List<String>.from(json['flower']) : [];
    this.gem = json['gem'];
    this.name = json['name'];
    this.oath = json['oath'];
    this.qing_yuan = json['qing_yuan'];
    this.result =
        json['result'] != null ? new List<String>.from(json['result']) : [];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['biao_bai'] = this.biao_bai;
    data['gem'] = this.gem;
    data['name'] = this.name;
    data['oath'] = this.oath;
    data['qing_yuan'] = this.qing_yuan;
    if (this.flower != null) {
      data['flower'] = this.flower;
    }
    if (this.result != null) {
      data['result'] = this.result;
    }
    return data;
  }
}
