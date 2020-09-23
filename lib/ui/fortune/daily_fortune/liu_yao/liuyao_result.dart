import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:yiapp/complex/class/yi_date_time.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/const/const_int.dart';
import 'package:yiapp/complex/provider/user_state.dart';
import 'package:yiapp/complex/tools/adapt.dart';
import 'package:yiapp/complex/tools/cus_routes.dart';
import 'package:yiapp/complex/tools/yi_tool.dart';
import 'package:yiapp/complex/widgets/flutter/cus_appbar.dart';
import 'package:yiapp/complex/widgets/flutter/cus_button.dart';
import 'package:yiapp/model/liuyaos/liuyao_result.dart';
import 'package:yiapp/model/liuyaos/liuyao_riqi.dart';
import 'package:yiapp/ui/fortune/daily_fortune/liu_yao/liuyao_symbol_res.dart';
import 'package:yiapp/ui/question/ask_question/ask_main_page.dart';
import 'package:yiapp/ui/question/ask_question/post_liuyao.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/9/5 11:55
// usage ：六爻排盘结果页面
// ------------------------------------------------------

class LiuYaoResPage extends StatefulWidget {
  final LiuYaoResult res;
  final List<int> l; // 六爻编码
  final YiDateTime guaTime;

  LiuYaoResPage({
    this.res,
    this.l,
    this.guaTime,
    Key key,
  }) : super(key: key);

  @override
  _LiuYaoResPageState createState() => _LiuYaoResPageState(res);
}

class _LiuYaoResPageState extends State<LiuYaoResPage> {
  LiuYaoResult _res;
  _LiuYaoResPageState(this._res);

  String _user_nick; // 卦主

  @override
  Widget build(BuildContext context) {
    _user_nick = context.watch<UserInfoState>()?.userInfo?.nick ?? "";
    return Scaffold(
      appBar: CusAppBar(text: "六爻排盘"),
      body: _lv(),
      backgroundColor: primary,
    );
  }

  Widget _lv() {
    LiuYaoRiqi riqi = _res.riqi;
    return Column(
      children: <Widget>[
        Expanded(
          child: ListView(
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.all(Adapt.px(30)),
            children: <Widget>[
              _show("占类", "在线起卦"),
              _show("卦主", _user_nick),
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
              LiuYaoSymRes(res: _res, codes: widget.l.reversed.toList()),
            ],
          ),
        ),
        // 底部智能解盘、发帖求测按钮
        _bottom(),
      ],
    );
  }

  /// 底部智能解盘、发帖求测按钮
  Widget _bottom() {
    return Row(
      children: <Widget>[
        Expanded(
          child: CusRaisedBtn(
            text: "闪断帖求测",
            borderRadius: 0,
            backgroundColor: Color(0xFFED9951),
            height: 90,
            onPressed: () {},
          ),
        ),
        Expanded(
          child: CusRaisedBtn(
            text: "悬赏帖求测",
            borderRadius: 0,
            backgroundColor: Color(0xFFE96C62),
            height: 90,
            onPressed: () => CusRoutes.push(
              context,
              AskQuestionPage(
                content_type: post_liuyao,
                res: widget.res,
                l: widget.l,
                guaTime: widget.guaTime,
                user_nick: _user_nick,
              ),
            ),
          ),
        ),
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
