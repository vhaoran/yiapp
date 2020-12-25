import 'package:flutter/material.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/cus/cus_route.dart';
import 'package:yiapp/ui/master/master_console/master_yiorder_page.dart';
import 'package:yiapp/util/screen_util.dart';
import 'package:yiapp/util/swicht_util.dart';
import 'package:yiapp/util/temp/cus_time.dart';
import 'package:yiapp/widget/cus_button.dart';
import 'package:yiapp/widget/small/cus_avatar.dart';
import 'package:yiapp/model/orders/yiOrder-dart.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/12/25 下午3:51
// usage ：大师控制台 -- 大师处理中的订单
// ------------------------------------------------------

class MasterAwaitCover extends StatefulWidget {
  final YiOrder yiOrder;

  MasterAwaitCover({this.yiOrder, Key key}) : super(key: key);

  @override
  _MasterAwaitCoverState createState() => _MasterAwaitCoverState();
}

class _MasterAwaitCoverState extends State<MasterAwaitCover> {
  YiOrder _order; // 单个订单详情

  @override
  void initState() {
    _order = widget.yiOrder;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => CusRoute.push(
        context,
        MasterYiOrderPage(yiOrder: widget.yiOrder),
      ),
      child: Card(
        color: fif_primary,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: _row(),
        ),
      ),
    );
  }

  Widget _row() {
    TextStyle gray = TextStyle(color: t_gray, fontSize: S.sp(15));
    TextStyle tPrimary = TextStyle(color: t_primary, fontSize: S.sp(15));
    return Row(
      children: <Widget>[
        // 用户头像
        CusAvatar(url: _order.icon_ref, rate: 20),
        SizedBox(width: 10),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(_order.nick_ref, style: tPrimary), // 用户昵称
                  Spacer(),
                  Text("${_order.amt} 元宝", style: tPrimary), // 用户付款金额
                ],
              ),
              // 大师服务项目类型
              SizedBox(height: S.h(10)),
              Text(SwitchUtil.serviceType(_order.yi_cate_id), style: gray),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  // 下单时间 这里的 create_date 全数据为
                  // 2020-10-20T01:42:17.682Z 非标准的时间格式，故只转换为年月日
                  Text("${CusTime.ymd(_order.create_date)}", style: gray),
                  Spacer(),
                  Container(
                    width: S.w(70),
                    constraints: BoxConstraints(maxHeight: S.h(30)),
                    child: CusRaisedButton(
                      child: Text("回复", style: TextStyle(fontSize: S.sp(14))),
                      onPressed: () {},
                      borderRadius: 50,
                      backgroundColor: Colors.lightBlue,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
