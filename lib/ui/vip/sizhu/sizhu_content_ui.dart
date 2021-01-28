import 'package:flutter/material.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/model/orders/sizhu_content.dart';
import 'package:yiapp/model/sizhu/sizhu_bazi.dart';
import 'package:yiapp/util/screen_util.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2021/1/28 下午6:15
// usage ：显示四柱内容的详情
// usage ：含姓名、性别、出生日期、八字
// ------------------------------------------------------

class SiZhuContentUI extends StatelessWidget {
  final SiZhuContent siZhuContent;

  SiZhuContentUI({this.siZhuContent, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (siZhuContent != null) {
      return _co();
    }
    return SizedBox.shrink();
  }

  Widget _co() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _descInfoWt("姓名", siZhuContent.name),
        _descInfoWt("性别", siZhuContent.is_male ? "男" : "女"),
        _descInfoWt("出生日期", siZhuContent.birth_date),
        _descInfoWt("八字", _baZi(siZhuContent.sizhu_res.baZi)),
        SizedBox(height: S.h(5)),
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

  /// 通用的显示姓名、性别、出生日期的组件
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
