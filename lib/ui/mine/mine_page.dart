import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/const/const_num.dart';
import 'package:yiapp/complex/tools/adapt.dart';
import 'package:yiapp/complex/type/bool_utils.dart';
import 'package:yiapp/complex/widgets/cus_bg_wall.dart';
import 'package:yiapp/complex/widgets/cus_avatar.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/8/7 15:41
// usage ：个人主页
// ------------------------------------------------------

class MinePage extends StatefulWidget {
  MinePage({Key key}) : super(key: key);

  @override
  _MinePageState createState() => _MinePageState();
}

class _MinePageState extends State<MinePage>
    with AutomaticKeepAliveClientMixin {
  var _future;
  @override
  void initState() {
    _future = _fetch();
    print(">>>进了个人主页");
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
      backgroundColor: sec_primary,
    );
  }

  Widget _bodyCtr() {
    return ListView(
      physics: BouncingScrollPhysics(),
      children: <Widget>[
        _info(),
      ],
    );
  }

  /// 用户个人信息
  Widget _info() {
    return Container(
      height: Adapt.px(bgWallH),
      child: Stack(
        children: <Widget>[
          // 背景墙
          BackgroundWall(url: "", onTap: () => print(">>>点了背景墙")),
          // 头像
          Align(
            alignment: Alignment(0, 0),
            child: CusAvatar(url: "", borderRadius: 100),
          ),
          // 用户名
          Align(
            alignment: Alignment(0, 0.75),
            child: Text(
              "用户454709171",
              style: TextStyle(
                color: t_gray,
                fontSize: Adapt.px(30),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
