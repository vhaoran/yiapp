import 'package:flutter/material.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/model/orders/yiOrder-dart.dart';
import 'package:yiapp/util/screen_util.dart';
import 'package:yiapp/util/temp/cus_time.dart';
import 'package:yiapp/widget/small/cus_avatar.dart';
import 'package:yiapp/widget/yuan_bao_ctr.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2021/1/26 上午11:57
// usage ：大师订单通用的头部信息
// usage ：含订单人头像、昵称，订单时间，金额
// ------------------------------------------------------

class YiOrderComHeader extends StatelessWidget {
  final YiOrder yiOrder;

  YiOrderComHeader({this.yiOrder, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (yiOrder != null) {
      return _yiorderHeader(yiOrder);
    }
    return SizedBox.shrink();
  }

  /// 大师订单头部
  Widget _yiorderHeader(YiOrder yiOrder) {
    return ListTile(
      // 订单人头像
      leading: CusAvatar(url: yiOrder.icon_ref ?? "", circle: true, size: 50),
      // 订单人昵称
      title: Text(
        yiOrder.nick_ref ?? "",
        style: TextStyle(color: t_primary, fontSize: S.sp(15)),
      ),
      // 订单生成时间
      // 下单时间 这里的 create_date 全数据为
      // 2020-10-20T01:42:17.682Z 非标准的时间格式，故只转换为年月日
      subtitle: Padding(
        padding: EdgeInsets.only(top: S.h(5)),
        child: Text(
          "${CusTime.ymd(yiOrder.create_date)}",
          style: TextStyle(color: t_gray, fontSize: S.sp(15)),
        ),
      ),
      // 订单金额
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          YuanBao(),
          SizedBox(width: S.w(5)),
          Text(
            "${yiOrder.amt ?? '***'}",
            style: TextStyle(color: t_primary, fontSize: S.sp(15)),
          ),
        ],
      ),
      contentPadding: EdgeInsets.all(0),
    );
  }
}
