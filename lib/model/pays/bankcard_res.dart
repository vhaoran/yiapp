// ------------------------------------------------------
// author：suxing
// date  ：2021/1/6 上午11:47
// usage ：设置提现账号
// ------------------------------------------------------

class BankCardRes {
  String acc_type;
  String bank_name;
  String branch_band_id;
  String branch_bank_addr;
  String card_code;
  String full_name;
  int id;
  int m_or_b_id;
  String name;

  BankCardRes({
    this.acc_type,
    this.bank_name,
    this.branch_band_id,
    this.branch_bank_addr,
    this.card_code,
    this.full_name,
    this.id,
    this.m_or_b_id,
    this.name,
  });

  factory BankCardRes.fromJson(Map<String, dynamic> json) {
    return BankCardRes(
      acc_type: json['acc_type'],
      bank_name: json['bank_name'],
      branch_band_id: json['branch_band_id'],
      branch_bank_addr: json['branch_bank_addr'],
      card_code: json['card_code'],
      full_name: json['full_name'],
      id: json['ID'],
      m_or_b_id: json['m_or_b_id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['acc_type'] = this.acc_type;
    data['bank_name'] = this.bank_name;
    data['branch_band_id'] = this.branch_band_id;
    data['branch_bank_addr'] = this.branch_bank_addr;
    data['card_code'] = this.card_code;
    data['full_name'] = this.full_name;
    data['ID'] = this.id;
    data['m_or_b_id'] = this.m_or_b_id;
    data['name'] = this.name;
    return data;
  }
}
