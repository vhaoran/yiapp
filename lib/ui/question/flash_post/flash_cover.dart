import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/const/const_int.dart';
import 'package:yiapp/complex/const/const_string.dart';
import 'package:yiapp/complex/tools/adapt.dart';
import 'package:yiapp/complex/tools/cus_routes.dart';
import 'package:yiapp/complex/widgets/small/cus_avatar.dart';
import 'package:yiapp/complex/widgets/flutter/cus_text.dart';
import 'package:yiapp/model/bbs/bbs-vie.dart';
import 'flash_content.dart';
import 'flash_pay_cancel.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/9/28 10:45
// usage ：闪断帖封面
// ------------------------------------------------------

class FlashCover extends StatefulWidget {
  final BBSVie data;
  VoidCallback onChanged; // 取消和支付的回调

  FlashCover({this.data, this.onChanged, Key key}) : super(key: key);

  @override
  _FlashCoverState createState() => _FlashCoverState();
}

class _FlashCoverState extends State<FlashCover> {
  // 临时设置，后边改为图片显示
  Color _typeColor = Colors.blueGrey; // 所求类型图片的背景色
  String _type = "其他"; // 所求类型的文字

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => CusRoutes.push(context, FlashContent(id: widget.data.id)),
      child: Card(
        color: fif_primary,
        margin: EdgeInsets.symmetric(vertical: Adapt.px(10)),
        shadowColor: Colors.white70,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: EdgeInsets.only(
              left: Adapt.px(25), right: Adapt.px(25), top: Adapt.px(10)),
          child: Column(
            children: <Widget>[
              _iconNameScore(), // 发帖人头像，昵称，悬赏金
              _briefAndType(), // 帖子标题和类型显示
              // 发帖时间。 如果本人帖子订单待支付，显示取消和支付按钮
              FlashPayCancel(data: widget.data, onChanged: widget.onChanged),
            ],
          ),
        ),
      ),
    );
  }

  /// 发帖人头像，昵称，悬赏金
  Widget _iconNameScore() {
    return Row(
      children: <Widget>[
        CusAvatar(
          url: widget.data.icon ?? "", // 头像
          size: 30,
          circle: true,
        ),
        // 昵称
        Padding(
          padding: EdgeInsets.symmetric(horizontal: Adapt.px(15)),
          child: CusText(
              widget.data.nick.isEmpty ? "至尊宝" : widget.data.nick, t_gray, 28),
        ),
        CusText("悬赏 ${widget.data.score} $yuan_bao", t_yi, 28), // 悬赏金
      ],
    );
  }

  /// 帖子标题和所求类型的图片（目前先用文字代替）
  Widget _briefAndType() {
    _dynamicType();
    return Row(
      children: <Widget>[
        Expanded(
          child: Text(
            widget.data.title, // 帖子标题
            style: TextStyle(color: t_gray, fontSize: Adapt.px(28)),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            softWrap: true,
          ),
        ),
        SizedBox(width: Adapt.px(12)),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: _typeColor,
          ),
          padding: EdgeInsets.all(20),
          child: Text(_type, style: TextStyle(fontSize: Adapt.px(30))),
        ),
      ],
    );
  }

  /// 临时设置，根据所求类型，动态更改类型颜色和背景色
  void _dynamicType() {
    switch (widget.data.content_type) {
      case post_liuyao: // 六爻
        _type = "六爻";
        _typeColor = Color(0xFF78BA3B);
        break;
      case post_sizhu: // 四柱
        _type = "四柱";
        _typeColor = Color(0xFF80DAEA);
        break;
      case he_hun: // 合婚
        _type = "合婚";
        _typeColor = Color(0xFFE0694D);
        break;
    }
  }
}
