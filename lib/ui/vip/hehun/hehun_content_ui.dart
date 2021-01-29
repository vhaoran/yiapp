import 'package:flutter/material.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/model/orders/hehun_content.dart';
import 'package:yiapp/model/sizhu/sizhu_bazi.dart';
import 'package:yiapp/util/screen_util.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2021/1/28 下午2:39
// usage ：显示合婚内容的详情
// usage ：男女方姓名、出生日期
// ------------------------------------------------------

class HeHunContentUI extends StatelessWidget {
  final HeHunContent heHunContent;

  HeHunContentUI({this.heHunContent, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (heHunContent != null) {
      return _co();
    }
    return SizedBox.shrink();
  }

  Widget _co() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          alignment: Alignment.center,
          child: Text(
            "合婚信息",
            style: TextStyle(fontSize: S.sp(16), color: t_primary),
          ),
        ),
        _descInfoWt("男方姓名", heHunContent.name_male),
        _descInfoWt("出生日期", heHunContent.birth_date_male),
        _descInfoWt("八字", _baZi(heHunContent.male_sizhu_res.baZi)),
        _descInfoWt("女方姓名", heHunContent.name_female),
        _descInfoWt("出生日期", heHunContent.birth_date_female),
        _descInfoWt("八字", _baZi(heHunContent.female_sizhu_res.baZi)),
        Divider(height: 0, thickness: 0.2, color: t_gray),
      ],
    );
  }

  /// 显示八字
  String _baZi(SiZhuBaZi baZi) {
    String nianGanZhi = baZi.nian_gan + baZi.nian_zhi;
    String yueGanZhi = baZi.yue_gan + baZi.yue_zhi;
    String riGanZhi = baZi.ri_gan + baZi.ri_zhi;
    String shiGanZhi = baZi.shi_gan + baZi.shi_zhi;
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
