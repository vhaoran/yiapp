import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/const/const_double.dart';
import 'package:yiapp/complex/tools/adapt.dart';
import 'package:yiapp/complex/type/bool_utils.dart';
import 'package:yiapp/complex/widgets/cus_avatar.dart';
import 'package:yiapp/complex/widgets/cus_bg_wall.dart';
import 'package:yiapp/complex/widgets/master/cus_fivestar.dart';
import 'package:yiapp/complex/widgets/master/cus_number_data.dart';
import 'package:yiapp/complex/widgets/flutter/cus_button.dart';
import 'package:yiapp/complex/widgets/master/user_comment.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/8/17 17:18
// usage ：大师主页
// ------------------------------------------------------

const double _fontSize = 24; // 个签、订单数、评论等字体大小

class MasterHomePage extends StatefulWidget {
  final String name;
  final String status; // 状态 在线/离线
  final String signature; // 个性签名
  final String defaultImage; // 默认图片（测试时用的，有数据时可以删除）

  MasterHomePage({
    this.name,
    this.status,
    this.signature,
    this.defaultImage,
    Key key,
  }) : super(key: key);

  @override
  _MasterHomePageState createState() => _MasterHomePageState();
}

class _MasterHomePageState extends State<MasterHomePage> {
  var _future;

  @override
  void initState() {
    _future = _fetch();
    print(">>>进了大师主页");
    super.initState();
  }

  _fetch() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: _future,
          builder: (context, snap) {
            return _bodyCtr();
            if (!snapDone(snap)) {
              return Center(child: CircularProgressIndicator());
            }
          }),
      backgroundColor: primary,
    );
  }

  Widget _bodyCtr() {
    List<int> tmp = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9];
    return ListView(
      physics: BouncingScrollPhysics(),
      children: <Widget>[
        _masterImage(), // 大师背景墙、头像
        _masterStatus(), // 大师姓名、状态、关注大师、立即约聊
        // 大师个性签名
        Padding(
          padding: EdgeInsets.all(Adapt.px(15)),
          child: Text(
            widget.signature,
            overflow: TextOverflow.ellipsis,
            maxLines: 3,
            style: TextStyle(color: t_gray, fontSize: Adapt.px(_fontSize)),
          ),
        ),
        Divider(thickness: 1, height: 0, color: Colors.black26),
        _comment(), // 大师评价区域
        Divider(thickness: 0, height: 0, color: Colors.black54),
        CusNumData(
          titles: ["12345", "12345", "12345", "12345"],
          subtitles: ["订单数", "订单数", "订单数", "订单数"],
          subSize: _fontSize,
          titleSize: 28,
          paddingV: 10,
        ),
        Divider(thickness: 1, height: 0, color: Colors.black54),
        ...tmp.map((e) {
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

  /// 大师背景墙、头像
  Widget _masterImage() {
    return Container(
      height: Adapt.px(bgWallH),
      child: Stack(
        children: <Widget>[
          // 背景墙
          BackgroundWall(url: ""),
          Align(
            alignment: Alignment(-0.95, -0.9),
            child: IconButton(
              icon: Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          // 头像
          Align(
            alignment: Alignment(-0.95, 1.6),
            child: CusAvatar(
              url: "",
              borderRadius: 100,
              defaultImage: widget.defaultImage,
            ),
          ),
        ],
      ),
    );
  }

  /// 大师姓名、状态、关注大师、立即约聊
  Widget _masterStatus() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Padding(
              padding:
                  EdgeInsets.only(left: Adapt.px(180), right: Adapt.px(10)),
              child: Text(
                widget.name, // 大师姓名
                style: TextStyle(
                  color: t_primary,
                  fontSize: Adapt.px(30),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Text(
              widget.status, // 大师状态
              style: TextStyle(
                color: widget.status.contains("在线") ? t_green : t_red,
                fontSize: Adapt.px(24),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        // 关注和立即约聊按钮
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            CusRaisedBtn(
              minWidth: 150,
              text: "关注",
              backgroundColor: Color(0xFF6C6B6D),
              textColor: t_primary,
              fontSize: 26,
              pdHor: 10,
              pdVer: 3,
              borderRadius: 20,
              onPressed: () {},
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Adapt.px(20)),
              child: CusRaisedBtn(
                minWidth: 150,
                text: "立即约聊",
                backgroundColor: t_primary,
                textColor: Colors.black,
                fontSize: 26,
                pdHor: 10,
                pdVer: 3,
                borderRadius: 20,
                onPressed: () {},
              ),
            )
          ],
        ),
        Divider(thickness: 1, height: 0, color: Colors.black54),
      ],
    );
    // 用户名
  }

  /// 大师五行评价区域
  Widget _comment() {
    return Container(
      padding: EdgeInsets.only(
        left: Adapt.px(30),
        right: Adapt.px(20),
        top: Adapt.px(15),
        bottom: Adapt.px(15),
      ),
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

  Widget _commentArea() {}
}
