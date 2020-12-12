import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/const/con_int.dart';
import 'package:yiapp/const/con_string.dart';
import 'package:yiapp/cus/cus_route.dart';
import 'package:yiapp/ui/question/post_content.dart';
import 'package:yiapp/ui/question/post_pay_cancel.dart';
import 'package:yiapp/util/screen_util.dart';
import 'package:yiapp/widget/small/cus_avatar.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/9/21 10:52
// usage ：帖子封面
// ------------------------------------------------------

class PostCover extends StatefulWidget {
  final data; // BBSVie、BBSPrize
  final bool isVie;
  final bool isHis;
  final VoidCallback onChanged; // 取消和支付的回调

  PostCover({
    this.data,
    this.isVie: false,
    this.isHis: false,
    this.onChanged,
    Key key,
  }) : super(key: key);

  @override
  _PostCoverState createState() => _PostCoverState();
}

class _PostCoverState extends State<PostCover> {
  Map<String, Color> _m = {}; // 测算类别，图片

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => CusRoute.push(
        context,
        PostContent(
            id: widget.data.id, isVie: widget.isVie, isHis: widget.isHis),
      ),
      child: _coverItem(),
    );
  }

  Widget _coverItem() {
    return Card(
      color: fif_primary,
      shadowColor: Colors.white70,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: EdgeInsets.only(left: 15, right: 15, top: 5),
        child: Column(
          children: <Widget>[
            _iconNameScore(), // 发帖人头像，昵称，悬赏金
            SizedBox(height: S.h(5)),
            _briefType(), // 帖子标题和类型显示
            // 如果本人帖子订单待支付，显示取消和支付按钮
            SizedBox(height: S.h(5)),
            PostPayCancel(
              data: widget.data,
              isVie: widget.isVie,
              onChanged: widget.onChanged,
            ),
          ],
        ),
      ),
    );
  }

  /// 发帖人头像，昵称，悬赏金
  Widget _iconNameScore() {
    return Row(
      children: <Widget>[
        CusAvatar(url: widget.data.icon ?? "", size: 30, circle: true), // 头像
        SizedBox(width: S.w(15)),
        Expanded(
          child: Text(
            widget.data.nick.isEmpty ? "" : widget.data.nick, // 昵称
            style: TextStyle(color: t_gray, fontSize: S.sp(15)),
          ),
        ),
        Text(
          "悬赏 ${widget.data.amt} $yuan_bao", // 悬赏金
          style: TextStyle(color: t_yi, fontSize: S.sp(15)),
        ),
      ],
    );
  }

  /// 帖子标题和所求类型的图片（目前先用文字代替）
  Widget _briefType() {
    _postType();
    return Row(
      children: <Widget>[
        Expanded(
          child: Text(
            widget.data.title, // 帖子标题
            style: TextStyle(color: t_gray, fontSize: S.sp(15)),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            softWrap: true,
          ),
        ),
        SizedBox(width: S.w(10)),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: _m.values.first,
          ),
          padding: EdgeInsets.all(20),
          child: Text(_m.keys.first, style: TextStyle(fontSize: S.sp(16))),
        ),
      ],
    );
  }

  /// 显示测算类别
  void _postType() {
    int type = widget.data.content_type;
    if (type == post_liuyao) {
      _m = {"六爻": Color(0xFF78BA3B)};
    } else if (type == post_sizhu) {
      _m = {"四柱": Color(0xFF80DAEA)};
    } else if (type == post_hehun) {
      _m = {"合婚": Color(0xFFE0694D)};
    } else {
      _m = {"其他": Colors.blueGrey};
    }
  }
}
