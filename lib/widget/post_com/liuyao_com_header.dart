import 'package:flutter/material.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/model/liuyaos/liuyao_result.dart';
import 'package:yiapp/model/liuyaos/liuyao_riqi.dart';
import 'package:yiapp/util/screen_util.dart';
import 'package:yiapp/util/time_util.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2021/1/26 下午7:24
// usage ：六爻通用的头部信息
// ------------------------------------------------------

class LiuYaoComHeader extends StatelessWidget {
  final LiuYaoResult liuYaoRes;

  LiuYaoComHeader({this.liuYaoRes, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (liuYaoRes != null) {
      return Column(
        children: <Widget>[
          _headerData("占类", "在线起卦"),
          _headerData(
            "时间",
            TimeUtil.YMDHM(comment: true, date: liuYaoRes.riqi.dateTime()),
          ),
          _ganZhiWt(liuYaoRes.riqi),
        ],
      );
    }
    return SizedBox.shrink();
  }

  Widget _ganZhiWt(LiuYaoRiqi riqi) {
    String nianGanZhi = riqi.nian_gan + riqi.nian_zhi;
    String yueGanZhi = riqi.yue_gan + riqi.yue_zhi;
    String riGanZhi = riqi.ri_gan + riqi.ri_zhi;
    String shiGanZhi = riqi.shi_gan + riqi.shi_zhi;
    String ganZhi = "$nianGanZhi $yueGanZhi $riGanZhi $shiGanZhi";
    return _headerData("干支", ganZhi);
  }

  /// 通用的显示占类、时间、干支
  Widget _headerData(String title, subtitle) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: S.h(3)),
      child: Row(
        children: <Widget>[
          Text(
            "$title：",
            style: TextStyle(color: t_gray, fontSize: S.sp(16)),
          ),
          Text(
            "$subtitle",
            style: TextStyle(color: t_gray, fontSize: S.sp(16)),
          ),
        ],
      ),
    );
  }
}
