import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/tools/adapt.dart';
import 'package:yiapp/complex/tools/cus_time.dart';
import 'package:yiapp/complex/widgets/flutter/cus_dialog.dart';
import 'package:yiapp/complex/widgets/flutter/cus_text.dart';
import 'package:yiapp/model/dicts/broker-apply.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/9/18 17:36
// usage ：运营商通用的审批记录组件
// ------------------------------------------------------

typedef FnBroker = void Function(BrokerApply master, int stat);

class BrokerApproveItem extends StatefulWidget {
  final FnBroker onApproval;
  final FnBroker onCancel;
  final VoidCallback onLoad;
  final bool isAll; // 是否全部分类
  final List<BrokerApply> l;

  BrokerApproveItem({
    this.onApproval,
    this.onCancel,
    this.onLoad,
    this.isAll,
    this.l,
    Key key,
  }) : super(key: key);

  @override
  _BrokerApproveItemState createState() => _BrokerApproveItemState();
}

class _BrokerApproveItemState extends State<BrokerApproveItem> {
  String _statStr = ""; // 审核状态
  Color _statColor = Colors.grey; // 审核颜色

  @override
  Widget build(BuildContext context) {
    return EasyRefresh(
      onLoad: widget.isAll ? widget.onLoad : null,
      child: ListView(
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        children: List.generate(widget.l.length, (i) {
          return Container(
            child: Card(
              margin: EdgeInsets.only(bottom: Adapt.px(5)),
              color: fif_primary,
              shadowColor: Colors.white,
              child: _leftScroll(widget.l[i]),
            ),
          );
        }),
      ),
    );
  }

  Widget _leftScroll(BrokerApply e) {
    _stat(e);
    return ListTile(
      // 名称
      title: CusText("${e.owner_nick}", t_gray, 30),
      // 时间
      subtitle: CusText("${CusTime.ymdhm(e.created_at)}", t_gray, 30),
      // 审核状态
      trailing: CusText(_statStr, _statColor, 28),
      onTap: () => e.stat == 0
          ? CusDialog.normal(
              context,
              title: e.brief.isEmpty ? "运营商简介" : e.brief,
              textAgree: "同意",
              agreeColor: Colors.black,
              onApproval: () {
                if (widget.onApproval != null) {
                  widget.onApproval(e, 1);
                }
              },
              textCancel: "拒绝",
              onCancel: () {
                if (widget.onCancel != null) {
                  widget.onCancel(e, 2);
                }
              },
              cancelColor: Colors.red,
              barrierDismissible: true,
            )
          : CusDialog.tip(
              context,
              title: e.brief.isEmpty ? "运营商简介" : e.brief,
            ),
    );
  }

  /// 根据审核状态显示
  void _stat(BrokerApply e) {
    switch (e.stat) {
      case 0:
        _statStr = "待审核";
        _statColor = Color(0xFF83C677);
        break;
      case 1:
        _statStr = "已审核";
        _statColor = t_gray;
        break;
      case 2:
        _statStr = "已拒绝";
        _statColor = t_yi;
        break;
      default:
        break;
    }
  }
}
