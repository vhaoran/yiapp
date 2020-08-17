import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/const/const_num.dart';
import 'package:yiapp/complex/tools/adapt.dart';
import 'package:yiapp/complex/type/bool_utils.dart';
import 'package:yiapp/complex/widgets/cus_avatar.dart';
import 'package:yiapp/complex/widgets/cus_bg_wall.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/8/17 17:18
// usage ：大师主页
// ------------------------------------------------------

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
    return ListView(
      physics: BouncingScrollPhysics(),
      children: <Widget>[
        _masterImage(), // 大师背景墙、头像
        _masterStatus(), // 大师姓名、状态、关注大师、立即约聊
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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: Adapt.px(180), right: Adapt.px(10)),
          child: Text(
            widget.name,
            style: TextStyle(
              color: t_primary,
              fontSize: Adapt.px(30),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Text(
          widget.status,
          style: TextStyle(
            color: t_green,
            fontSize: Adapt.px(24),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
    // 用户名
  }

  @override
  bool get wantKeepAlive => true;
}
