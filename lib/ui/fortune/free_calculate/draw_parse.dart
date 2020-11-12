import 'package:yiapp/free_model/draws/chegong_result.dart';
import 'package:yiapp/free_model/draws/daxian_result.dart';
import 'package:yiapp/free_model/draws/guandi_result.dart';
import 'package:yiapp/free_model/draws/guanyin_result.dart';
import 'package:yiapp/free_model/draws/lvzu_result.dart';
import 'package:yiapp/free_model/draws/mazu_result.dart';
import 'package:yiapp/free_model/draws/yuelao_result.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/9/7 19:24
// usage ：解析抽签数据
// ------------------------------------------------------

class DrawParse {
  /// 黄大仙数据
  static List<Map> daXian(DaXianResult res) {
    return [
      {
        "title": "签诗",
        "contents": res.qian_shi,
      },
      {
        "title": "解签诗",
        "contents": [res.jie_qian],
      },
      {
        "title": "解运势",
        "contents": res.jie_yun_shi,
      },
    ];
  }

  /// 关公数据
  static List<Map> guanDi(GuanDiResult res) {
    return [
      {
        "title": "盛意",
        "contents": [res.sheng_yi],
      },
      {
        "title": "解曰",
        "contents": [res.jie_qian],
      },
      {
        "title": "释义",
        "contents": [res.shi_yi],
      },
      {
        "title": "解签",
        "contents": [res.jie_qian],
      },
      {
        "title": "东坡解",
        "contents": [res.dong_po_jie],
      },
      {
        "title": "碧仙注",
        "contents": [res.bi_xian_zhu],
      },
    ];
  }

  /// 观音数据
  static List<Map> guanYin(GuanYinResult res) {
    return [
      {
        "title": "宫位",
        "contents": [res.gong_wei],
      },
      {
        "title": "诗意",
        "contents": [res.shi_yi],
      },
      {
        "title": "解曰",
        "contents": [res.jie_yue],
      },
      {
        "title": "仙机",
        "contents": [res.xian_ji],
      },
      {
        "title": "典故",
        "contents": [res.dian_gu],
      },
    ];
  }

  /// 妈祖数据
  static List<Map> maZu(MaZuResult res) {
    return [
      {
        "title": "签题",
        "contents": [res.qian_ti],
      },
      {
        "title": "签文",
        "contents": [res.qian_wen],
      },
      {
        "title": "解签",
        "contents": [res.jie_qian],
      },
      {
        "title": "典故",
        "contents": [res.dian_gu],
      },
      {
        "title": "运程",
        "contents": res.yun_cheng,
      },
    ];
  }

  /// 月老数据
  static List<Map> yueLao(YueLaoResult res) {
    return [
      {
        "title": "签诗",
        "contents": [res.qian_shi],
      },
      {
        "title": "解签",
        "contents": [res.jie_qian],
      },
      {
        "title": "签注",
        "contents": [res.qian_zhu],
      },
      {
        "title": "解读",
        "contents": [res.jie_du],
      },
    ];
  }

  /// 车公数据
  static List<Map> cheGong(CheGongResult res) {
    return [
      {
        "title": "签文",
        "contents": [res.qian_wen],
      },
      {
        "title": "解签",
        "contents": [res.jie_qian],
      },
      {
        "title": "签云",
        "contents": res.qian_yun,
      },
    ];
  }

  /// 吕祖数据
  static List<Map> lvZu(LvZuResult res) {
    return [
      {
        "title": "签文",
        "contents": [res.qian_wen],
      },
      {
        "title": "概述",
        "contents": [res.gai_shu],
      },
      {
        "title": "诗曰",
        "contents": [res.shi_yue],
      },
      {
        "title": "运程",
        "contents": res.yun_cheng,
      },
    ];
  }
}
