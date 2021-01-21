import 'package:flutter/material.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/util/screen_util.dart';
import 'package:yiapp/widget/small/cus_avatar.dart';
import 'package:yiapp/widget/yuan_bao_ctr.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2021/1/21 上午11:48
// usage ：帖子通用的顶部信息
// ------------------------------------------------------

class PostComHeader extends StatelessWidget {
  final String url; // 头像地址
  final String nick; // 昵称
  final String createDate; // 发帖时间
  final num amt; // 赏金

  PostComHeader({
    this.url: "",
    this.nick: "",
    this.createDate: "",
    this.amt: 0,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _header();
  }

  Widget _header() {
    return ListTile(
      // 发帖人头像
      leading: CusAvatar(url: url ?? "", circle: true, size: 50),
      // 发帖人昵称
      title: Text(
        nick ?? "",
        style: TextStyle(color: t_primary, fontSize: S.sp(15)),
      ),
      // 发帖时间
      subtitle: Padding(
        padding: EdgeInsets.only(top: S.h(5)),
        child: Text(
          createDate ?? "",
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
            "${amt ?? '***'}",
            style: TextStyle(color: t_primary, fontSize: S.sp(15)),
          ),
        ],
      ),
      contentPadding: EdgeInsets.all(0),
    );
  }
}
