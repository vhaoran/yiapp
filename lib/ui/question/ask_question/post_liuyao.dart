import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:yiapp/complex/class/yi_date_time.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/tools/adapt.dart';
import 'package:yiapp/complex/tools/yi_tool.dart';
import 'package:yiapp/complex/widgets/flutter/cus_text.dart';
import 'package:yiapp/model/liuyaos/liuyao_result.dart';
import 'package:yiapp/model/liuyaos/liuyao_riqi.dart';
import 'package:yiapp/ui/fortune/daily_fortune/liu_yao/liuyao_symbol_res.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/9/23 10:52
// usage ：我要提问 - 六爻排盘
// ------------------------------------------------------

class PostLiuYaoCtr extends StatefulWidget {
  final LiuYaoResult res;
  final List<int> l; // 六爻编码
  final YiDateTime guaTime;
  final String user_nick; // 卦主姓名

  PostLiuYaoCtr({this.res, this.l, this.guaTime, this.user_nick, Key key})
      : super(key: key);

  @override
  _PostLiuYaoCtrState createState() => _PostLiuYaoCtrState();
}

class _PostLiuYaoCtrState extends State<PostLiuYaoCtr> {
  @override
  Widget build(BuildContext context) {
    return _lv();
  }

  Widget _lv() {
    LiuYaoRiqi riqi = widget.res.riqi;
    return Column(
      children: <Widget>[
        Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(Adapt.px(10)),
          child: CusText("六爻排盘信息", t_primary, 32),
        ),
        _show("占类", "在线起卦"),
        _show("卦主", widget.user_nick),
        _show(
            "时间",
            "${YiTool.fullDateGong(
              YiDateTime(
                year: riqi.year,
                month: riqi.month,
                day: riqi.day,
                hour: riqi.hour,
                minute: riqi.minute,
              ),
            )}"),
        _show(
          "干支",
          "${riqi.nian_gan}${riqi.nian_zhi}  ${riqi.yue_gan}${riqi.yue_zhi}"
              "  ${riqi.ri_gan}${riqi.ri_zhi}  ${riqi.shi_gan}${riqi.shi_zhi}",
        ),
        // 卦象
        LiuYaoSymRes(res: widget.res, codes: widget.l.reversed.toList()),
      ],
    );
  }

  /// 显示占类、卦主、时间
  Widget _show(String title, subtitle) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: Adapt.px(5)),
      child: Row(
        children: <Widget>[
          Text(
            "$title:",
            style: TextStyle(color: t_gray, fontSize: Adapt.px(30)),
          ),
          SizedBox(width: Adapt.px(30)),
          Text(
            "$subtitle",
            style: TextStyle(color: t_gray, fontSize: Adapt.px(30)),
          ),
        ],
      ),
    );
  }
}
