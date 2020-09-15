import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/tools/adapt.dart';
import 'package:yiapp/complex/tools/cus_time.dart';
import 'package:yiapp/complex/widgets/flutter/cus_dialog.dart';
import 'package:yiapp/complex/widgets/flutter/cus_text.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/9/14 16:56
// usage ：通用的审批记录组件，如大师、代理
// ------------------------------------------------------

class ApproveItem extends StatefulWidget {
  final String title;
  final String time; // 申请时间
  final String brief; // 简介
  final int stat; // 状态 0 待审核、1 已审核、2 已拒绝
  final VoidCallback onApproval;
  final VoidCallback onCancel;

  ApproveItem({
    this.title: "title",
    this.time: "",
    this.brief: "",
    this.stat,
    this.onApproval,
    this.onCancel,
    Key key,
  }) : super(key: key);

  @override
  _ApproveItemState createState() => _ApproveItemState();
}

class _ApproveItemState extends State<ApproveItem> {
  String _statStr = ""; // 审核状态
  Color _statColor = Colors.grey; // 审核颜色
  @override
  Widget build(BuildContext context) {
    _stat();
    return Card(
      margin: EdgeInsets.only(bottom: Adapt.px(5)),
      color: fif_primary,
      shadowColor: Colors.white,
      child: _leftScroll(),
    );
  }

  Widget _leftScroll() {
    return ListTile(
      // 名称
      title: CusText("${widget.title}", t_gray, 30),
      // 时间
      subtitle: CusText("${CusTime.ymdhm(widget.time)}", t_gray, 30),
      // 审核状态
      trailing: CusText(_statStr, _statColor, 28),
      onTap: () => widget.stat == 0
          ? CusDialog.normal(
              context,
              title: widget.brief,
              textAgree: "同意",
              onApproval: widget.onApproval,
              textCancel: "拒绝",
              onCancel: widget.onCancel,
              cancelCo: Colors.red,
              barrierDismissible: true,
            )
          : CusDialog.tip(context, title: widget.brief),
    );
  }

  /// 根据审核状态显示
  void _stat() {
    switch (widget.stat) {
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
