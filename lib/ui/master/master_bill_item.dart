import 'package:flutter/material.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/const/con_string.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/model/pays/master_business_res.dart';
import 'package:yiapp/util/screen_util.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2021/1/7 上午11:44
// usage ：单个大师对账单对象
// ------------------------------------------------------

class MasterBillItem extends StatefulWidget {
  final MasterBusinessRes business;

  MasterBillItem({this.business, Key key}) : super(key: key);

  @override
  _MasterBillItemState createState() => _MasterBillItemState();
}

class _MasterBillItemState extends State<MasterBillItem> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: fif_primary,
      margin: EdgeInsets.all(2),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: _buildItem(),
      ),
    );
  }

  /// 单个交易对象
  Widget _buildItem() {
    // 收益为红，退款为绿
    Color color = widget.business.amt >= 0 ? btn_red : t_ji;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          _billType(widget.business.b_type), // 交易类型
          style: TextStyle(color: t_primary, fontSize: S.sp(15)),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Row(
            children: <Widget>[
              Text(
                "${widget.business.amt}", // 交易金额
                style: TextStyle(color: color, fontSize: S.sp(25)),
              ),
              Text(
                " 元",
                style: TextStyle(color: color, fontSize: S.sp(15)),
              ),
            ],
          ),
        ),
        Container(
          alignment: Alignment.centerRight,
          child: Text(
            widget.business.created_at, // 交易时间
            style: TextStyle(color: t_gray, fontSize: S.sp(15)),
          ),
        ),
      ],
    );
  }

  /// 交易类型
  String _billType(String bType) {
    switch (bType) {
      // 收益
      case b_yi_order:
        return "大师订单";
        break;
      case b_mall:
        return "商城订单";
        break;
      case b_bbs_prize:
        return "悬赏帖订单";
        break;
      case b_bbs_vie:
        return "闪断帖订单";
        break;
      // 支出
      case b_master_draw_money:
        return "提现";
        break;
      // 其它
      case b_adjust:
        return "账务调整";
        break;
      default:
        "其它交易";
        Log.info("当前交易类型：$bType"); // 未知交易类型
        break;
    }
  }
}
