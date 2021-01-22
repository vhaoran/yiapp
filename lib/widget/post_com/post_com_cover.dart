import 'package:flutter/material.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/const/con_int.dart';
import 'package:yiapp/model/bbs/bbs_prize.dart';
import 'package:yiapp/model/bbs/bbs_vie.dart';
import 'package:yiapp/util/screen_util.dart';
import 'package:yiapp/util/swicht_util.dart';
import 'package:yiapp/widget/small/cus_avatar.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2021/1/21 下午3:03
// usage ：帖子通用的封面
// usage ：含发帖人头像、昵称、赏金、帖子摘要、测算类型、发帖时间
// usage ：因帖子点击事件需根据实际情况显示，所以单独抽离出去
// ------------------------------------------------------

class PostComCover extends StatelessWidget {
  final BBSPrize prize;
  final BBSVie vie;
  final Widget events; // 点击事件

  PostComCover({this.prize, this.vie, this.events, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: fif_primary,
      shadowColor: Colors.white70,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: S.w(10), vertical: S.h(5)),
        child: _child(),
      ),
    );
  }

  Widget _child() {
    if (prize != null) return _prizeCover();
    if (vie != null) return _vieCover();
    return SizedBox.shrink();
  }

  /// 悬赏帖封面
  Widget _prizeCover() {
    Map<String, Color> m = SwitchUtil.postType(prize?.content_type);
    return Column(
      children: <Widget>[
        // 上层
        Row(
          children: <Widget>[
            // 发帖人头像
            CusAvatar(url: prize?.icon ?? "", size: 30, circle: true),
            SizedBox(width: S.w(15)),
            Expanded(
              child: Text(
                prize?.nick ?? "", // 发帖人昵称
                style: TextStyle(color: t_gray, fontSize: S.sp(15)),
              ),
            ),
            if (prize.stat == bbs_ok)
              Text(
                "已采纳",
                style: TextStyle(color: t_yi, fontSize: S.sp(15)),
              ),
            SizedBox(width: S.w(5)),
            Text(
              "悬赏 ${prize?.amt ?? '***'} 元宝", // 悬赏金
              style: TextStyle(color: t_yi, fontSize: S.sp(15)),
            ),
          ],
        ),
        // 中层
        Padding(
          padding: EdgeInsets.symmetric(vertical: S.h(10)),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  prize?.title ?? "", // 帖子标题
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
                  color: m.values.first,
                ),
                padding: EdgeInsets.all(20),
                child: Text(m.keys.first, style: TextStyle(fontSize: S.sp(16))),
              ),
            ],
          ),
        ),
        // 下层
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Text(
              prize?.create_date, // 发帖时间
              style: TextStyle(color: t_gray, fontSize: S.sp(15)),
            ),
            Spacer(),
            events, // 帖子点击事件
          ],
        ),
      ],
    );
  }

  /// 闪断帖封面
  Widget _vieCover() {
    Map<String, Color> m = SwitchUtil.postType(vie?.content_type);
    return Column(
      children: <Widget>[
        // 上层
        Row(
          children: <Widget>[
            // 发帖人头像
            CusAvatar(url: vie?.icon ?? "", size: 30, circle: true),
            SizedBox(width: S.w(15)),
            Expanded(
              child: Text(
                vie?.nick ?? "", // 发帖人昵称
                style: TextStyle(color: t_gray, fontSize: S.sp(15)),
              ),
            ),
            if (vie.stat == bbs_ok)
              Text(
                "已采纳",
                style: TextStyle(color: t_yi, fontSize: S.sp(15)),
              ),
            SizedBox(width: S.w(5)),
            Text(
              "悬赏 ${vie?.amt ?? '***'} 元宝", // 悬赏金
              style: TextStyle(color: t_yi, fontSize: S.sp(15)),
            ),
          ],
        ),
        // 中层
        Padding(
          padding: EdgeInsets.symmetric(vertical: S.h(10)),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  vie?.title ?? "", // 帖子标题
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
                  color: m.values.first,
                ),
                padding: EdgeInsets.all(20),
                child: Text(m.keys.first, style: TextStyle(fontSize: S.sp(16))),
              ),
            ],
          ),
        ),
        // 下层
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Text(
              vie?.create_date, // 发帖时间
              style: TextStyle(color: t_gray, fontSize: S.sp(15)),
            ),
            Spacer(),
            events, // 帖子点击事件
          ],
        ),
      ],
    );
  }
}
