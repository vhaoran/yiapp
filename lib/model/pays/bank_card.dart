class BankCard {
  String bank_name;
  String branch_band_id;
  String branch_bank_addr;
  String card_code;
  String full_name;

  BankCard({
    this.bank_name,
    this.branch_band_id,
    this.branch_bank_addr,
    this.card_code,
    this.full_name,
  });

  factory BankCard.fromJson(Map<String, dynamic> json) {
    return BankCard(
      bank_name: json['bank_name'],
      branch_band_id: json['branch_band_id'],
      branch_bank_addr: json['branch_bank_addr'],
      card_code: json['card_code'],
      full_name: json['full_name'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['bank_name'] = this.bank_name;
    data['branch_band_id'] = this.branch_band_id;
    data['branch_bank_addr'] = this.branch_bank_addr;
    data['card_code'] = this.card_code;
    data['full_name'] = this.full_name;
    return data;
  }
}
