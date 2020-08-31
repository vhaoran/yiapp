import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:yiapp/model/draw/daxian_result.dart';

class DrawParse {
  /// 黄大仙数据
  static List<Map> daXian(DaXianResult res) {
    return [
      {
        "title": "签诗",
        "contents": [res.qian_shi],
        "icon": FontAwesomeIcons.envira,
      },
      {
        "title": "解签诗",
        "contents": [res.jie_qian],
        "icon": FontAwesomeIcons.solidEnvelopeOpen,
      },
      {
        "title": "解运势",
        "contents": res.jie_yun_shi,
        "icon": FontAwesomeIcons.levelUpAlt,
      },
    ];
  }
}
