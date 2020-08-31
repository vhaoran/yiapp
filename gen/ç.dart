class ç {
    String jie_qian;
    List<String> jie_yun_shi;
    String name;
    String qian_shi;

    ç({this.jie_qian, this.jie_yun_shi, this.name, this.qian_shi});

    factory ç.fromJson(Map<String, dynamic> json) {
        return ç(
            jie_qian: json['jie_qian'], 
            jie_yun_shi: json['jie_yun_shi'] != null ? new List<String>.from(json['jie_yun_shi']) : null, 
            name: json['name'], 
            qian_shi: json['qian_shi'], 
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['jie_qian'] = this.jie_qian;
        data['name'] = this.name;
        data['qian_shi'] = this.qian_shi;
        if (this.jie_yun_shi != null) {
            data['jie_yun_shi'] = this.jie_yun_shi;
        }
        return data;
    }
}