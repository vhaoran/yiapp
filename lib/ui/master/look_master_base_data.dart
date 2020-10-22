import 'package:flutter/material.dart';
import 'package:yiapp/complex/class/debug_log.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/const/const_double.dart';
import 'package:yiapp/complex/tools/adapt.dart';
import 'package:yiapp/complex/widgets/flutter/cus_button.dart';
import 'package:yiapp/complex/widgets/small/cus_avatar.dart';
import 'package:yiapp/complex/widgets/small/cus_bg_wall.dart';
import 'package:yiapp/model/dicts/master-info.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/10/22 10:03
// usage ：用户查看大师信息的基本资料(如头像，背景墙，个签等)
// ------------------------------------------------------

class LookMasterBaseData extends StatefulWidget {
  final MasterInfo info;

  LookMasterBaseData({this.info, Key key}) : super(key: key);

  @override
  _LookMasterBaseDataState createState() => _LookMasterBaseDataState();
}

class _LookMasterBaseDataState extends State<LookMasterBaseData> {
  var _m = MasterInfo();

  @override
  void initState() {
    _m = widget.info;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _masterImage(), // 大师背景墙、头像
        _masterStatus(), // 大师姓名、状态、关注大师、立即约聊
        // 大师个性签名
        Padding(
          padding: EdgeInsets.all(Adapt.px(15)),
          child: Text(
            _m.brief.isEmpty ? "这里是大师签名" : _m.brief,
            overflow: TextOverflow.ellipsis,
            maxLines: 3,
            style: TextStyle(color: t_gray, fontSize: Adapt.px(24)),
          ),
        ),
        Divider(thickness: 1, height: 0, color: Colors.black26),
      ],
    );
  }

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
            child: CusAvatar(url: "", borderRadius: 100),
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
                _m.nick, // 大师姓名
                style: TextStyle(
                  color: t_primary,
                  fontSize: Adapt.px(30),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
//            Text(
//              widget.status, // 大师状态
//              style: TextStyle(
//                color: widget.status.contains("在线") ? t_green : t_red,
//                fontSize: Adapt.px(24),
//                fontWeight: FontWeight.w500,
//              ),
//            ),
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
                borderRadius: 20,
                onPressed: () {
                  Debug.log("点了哪位大师：${_m.nick}");
                },
              ),
            )
          ],
        ),
      ],
    );
  }
}
