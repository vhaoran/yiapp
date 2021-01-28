import 'package:flutter/material.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/model/bbs/bbs_prize.dart';
import 'package:yiapp/model/bbs/bbs_vie.dart';
import 'package:yiapp/util/screen_util.dart';
import 'package:yiapp/widget/small/cus_avatar.dart';
import 'package:yiapp/widget/yuan_bao_ctr.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2021/1/21 上午11:48
// usage ：帖子通用的头部信息
// usage : 含发帖人头像、昵称，发帖时间，悬赏金额
// ------------------------------------------------------

class PostComHeader extends StatelessWidget {
  final BBSPrize prize;
  final BBSVie vie;

  PostComHeader({this.prize, this.vie, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (prize != null) return _prizeHeader(prize);
    if (vie != null) return _vieHeader(vie);
    return SizedBox.shrink();
  }

  /// 悬赏帖头部
  Widget _prizeHeader(BBSPrize prize) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            // 发帖人头像
            CusAvatar(url: prize?.icon ?? "", circle: true, size: 50),
            SizedBox(width: S.w(10)),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  prize.nick ?? "", // 发帖人昵称
                  style: TextStyle(color: t_primary, fontSize: S.sp(15)),
                ),
                SizedBox(height: S.h(10)),
                Text(
                  prize.create_date ?? "", // 发帖时间
                  style: TextStyle(color: t_gray, fontSize: S.sp(15)),
                ),
              ],
            ),
            Spacer(),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                YuanBao(),
                SizedBox(width: S.w(5)),
                Text(
                  "${prize?.amt ?? '***'}",
                  style: TextStyle(color: t_primary, fontSize: S.sp(15)),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  /// 闪断帖头部
  Widget _vieHeader(BBSVie vie) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            // 发帖人头像
            CusAvatar(url: vie?.icon ?? "", circle: true, size: 50),
            SizedBox(width: S.w(10)),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  vie.nick ?? "", // 发帖人昵称
                  style: TextStyle(color: t_primary, fontSize: S.sp(15)),
                ),
                SizedBox(height: S.h(10)),
                Text(
                  vie.create_date ?? "", // 发帖时间
                  style: TextStyle(color: t_gray, fontSize: S.sp(15)),
                ),
              ],
            ),
            Spacer(),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                YuanBao(),
                SizedBox(width: S.w(5)),
                Text(
                  "${vie?.amt ?? '***'}",
                  style: TextStyle(color: t_primary, fontSize: S.sp(15)),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
