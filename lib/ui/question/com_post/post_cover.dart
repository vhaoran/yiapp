import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/const/const_int.dart';
import 'package:yiapp/complex/const/const_string.dart';
import 'package:yiapp/complex/tools/adapt.dart';
import 'package:yiapp/complex/tools/cus_routes.dart';
import 'package:yiapp/complex/tools/cus_time.dart';
import 'package:yiapp/complex/widgets/cus_avatar.dart';
import 'package:yiapp/complex/widgets/flutter/cus_text.dart';
import 'package:yiapp/model/bbs/bbs-Prize.dart';
import 'package:yiapp/ui/question/com_post/post_content.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/9/21 10:52
// usage ：帖子封面
// ------------------------------------------------------

class PostCover extends StatefulWidget {
  final BBSPrize data;

  PostCover({this.data, Key key}) : super(key: key);

  @override
  _PostCoverState createState() => _PostCoverState();
}

class _PostCoverState extends State<PostCover> {
  Color _typeColor = Colors.blueGrey;

  // 所求类型图片的背景色
  String _type = "未知"; // 所求类型的文字

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => CusRoutes.push(context, PostContent(data: widget.data)),
      child: Card(
        color: fif_primary,
        margin: EdgeInsets.symmetric(vertical: Adapt.px(10)),
        shadowColor: Colors.white70,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: Adapt.px(25), vertical: Adapt.px(10)),
          child: Column(
            children: <Widget>[
              _iconNameScore(), // 发帖人头像，昵称，悬赏金
              _briefAndType(), // 帖子标题和类型显示
              _timeCtr(), // 显示发布帖子时间
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

  /// 显示发布帖子时间以及后续补充
  Widget _timeCtr() {
    return Row(
      children: <Widget>[
        CusText("${CusTime.ymd(widget.data.create_date)}", t_gray, 28),
      ],
    );
  }

  /// 临时设置，根据所求类型，动态更改类型颜色和背景色
  void _dynamicType() {
    switch (widget.data.stat) {
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
