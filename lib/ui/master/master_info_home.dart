import 'package:flutter/material.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/util/adapt.dart';
import 'package:yiapp/widget/master/cus_fivestar.dart';
import 'package:yiapp/widget/master/master_rate.dart';
import 'package:yiapp/widget/master/user_comment.dart';
import 'package:yiapp/model/dicts/master-info.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/10/22 09:34
// usage ：大师个人信息 -- 主页(注：评论暂未用到)
// ------------------------------------------------------

class MasterInfoHome extends StatefulWidget {
  final MasterInfo info;

  MasterInfoHome({this.info, Key key}) : super(key: key);

  @override
  _MasterInfoHomeState createState() => _MasterInfoHomeState();
}

class _MasterInfoHomeState extends State<MasterInfoHome> {
  List<int> _tl = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9];

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(0),
      physics: BouncingScrollPhysics(),
      children: <Widget>[
        // 大师评价区域
        _comment(),
        Divider(thickness: 0, height: 0, color: Colors.black54),
        // 显示订单数
        MasterRate(
          titles: ["12345", "12345", "12345", "12345"],
          subtitles: ["订单数", "订单数", "订单数", "订单数"],
          subSize: 24,
          titleSize: 28,
        ),
        Divider(thickness: 1, height: 0, color: Colors.black54),
        // 显示评论详情
        ..._tl.map((e) {
          bool b = e.isOdd ? true : false;
          return UserComment(
            svip: b,
            title: b ? "雷军" : "郭德纲",
            titleColor: b ? t_svip : t_gray,
          );
        }).toList(),
      ],
    );
  }

  /// 大师五星评价区域
  Widget _comment() {
    return Container(
      padding: EdgeInsets.only(left: 15, right: 10, top: 10, bottom: 10),
      color: fif_primary,
      child: Row(
        children: <Widget>[
          Text(
            "评价",
            style: TextStyle(color: t_primary, fontSize: Adapt.px(28)),
          ),
          SizedBox(width: Adapt.px(10)),
          Text(
            "1000+",
            style: TextStyle(color: t_gray, fontSize: Adapt.px(28)),
          ),
          Spacer(),
          FiveStars(), // 五角星
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Adapt.px(10)),
            child: Text(
              "好评率",
              style: TextStyle(color: t_gray, fontSize: Adapt.px(28)),
            ),
          ),
          Text(
            "100%",
            style: TextStyle(color: t_red, fontSize: Adapt.px(28)),
          ),
        ],
      ),
    );
  }
}
