import 'package:flutter/material.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/model/liuyaos/liuyao_riqi.dart';
import 'package:yiapp/model/orders/liuyao_content.dart';
import 'package:yiapp/ui/vip/liuyao/liuyao_toddler.dart';
import 'package:yiapp/util/screen_util.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2021/1/28 下午2:39
// usage ：显示六爻内容的详情
// usage ：六爻头部信息，含所问类型、占类、性别、起卦时间、干支
// usage ：六爻卦象，即六爻排盘结果，含世应爻、伏神等
// ------------------------------------------------------

class LiuYaoContentUI extends StatelessWidget {
  final LiuYaoContent liuYaoContent;

  LiuYaoContentUI({this.liuYaoContent, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (liuYaoContent != null) {
      return _co();
    }
    return SizedBox.shrink();
  }

  Widget _co() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Divider(height: 0, thickness: 0.2, color: t_gray),
        Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(vertical: S.h(5)),
          child: Text(
            "六爻排盘信息",
            style: TextStyle(fontSize: S.sp(16), color: t_primary),
          ),
        ),
        ..._liuYaoHeaderWts(),
        SizedBox(height: S.h(5)),
        // 六爻卦象
        LiuYaoToddler(liuYaoContent: liuYaoContent),
        SizedBox(height: S.h(10)),
        Divider(height: 0, thickness: 0.2, color: t_gray),
      ],
    );
  }

  /// 六爻头部信息
  List<Widget> _liuYaoHeaderWts() {
    return <Widget>[
      SizedBox(height: S.h(5)),
      // 六爻头部信息
      _descInfoWt("占类", "在线起卦"),
      _descInfoWt("性别", liuYaoContent.is_male ? "男" : "女"),
      _descInfoWt("起卦时间", liuYaoContent.qigua_time),
      _descInfoWt("干支", _ganZhi(liuYaoContent.liuyao_res.riqi)),
      SizedBox(height: S.h(5)),
    ];
  }

  /// 六爻干支
  String _ganZhi(LiuYaoRiqi riqi) {
    String nianGanZhi = riqi.nian_gan + riqi.nian_zhi;
    String yueGanZhi = riqi.yue_gan + riqi.yue_zhi;
    String riGanZhi = riqi.ri_gan + riqi.ri_zhi;
    String shiGanZhi = riqi.shi_gan + riqi.shi_zhi;
    String ganZhi = "$nianGanZhi $yueGanZhi $riGanZhi $shiGanZhi";
    return ganZhi;
  }

  /// 通用的显示占类、时间、干支
  Widget _descInfoWt(String title, subtitle) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: S.h(3)),
      child: Text(
        "$title:  $subtitle",
        style: TextStyle(color: t_gray, fontSize: S.sp(16)),
      ),
    );
  }
}
