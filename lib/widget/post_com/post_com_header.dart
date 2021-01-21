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
    if (prize != null) return _prizeHeader();
    if (vie != null) return _vieHeader();
    return SizedBox.shrink();
  }

  /// 悬赏帖头部
  Widget _prizeHeader() {
    return ListTile(
      // 发帖人头像
      leading: CusAvatar(url: prize?.icon ?? "", circle: true, size: 50),
      // 发帖人昵称
      title: Text(
        prize?.nick ?? "",
        style: TextStyle(color: t_primary, fontSize: S.sp(15)),
      ),
      // 发帖时间
      subtitle: Padding(
        padding: EdgeInsets.only(top: S.h(10)),
        child: Text(
          prize?.create_date ?? "",
          style: TextStyle(color: t_gray, fontSize: S.sp(15)),
        ),
      ),
      // 悬赏金额
      trailing: Row(
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
      contentPadding: EdgeInsets.all(0),
    );
  }

  /// 闪断帖头部
  Widget _vieHeader() {
    return ListTile(
      // 发帖人头像
      leading: CusAvatar(url: vie.icon ?? "", circle: true, size: 50),
      // 发帖人昵称
      title: Text(
        vie?.nick ?? "",
        style: TextStyle(color: t_primary, fontSize: S.sp(15)),
      ),
      // 发帖时间
      subtitle: Padding(
        padding: EdgeInsets.only(top: S.h(10)),
        child: Text(
          vie?.create_date ?? "",
          style: TextStyle(color: t_gray, fontSize: S.sp(15)),
        ),
      ),
      // 悬赏金额
      trailing: Row(
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
      contentPadding: EdgeInsets.all(0),
    );
  }
}
