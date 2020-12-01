import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:yiapp/func/const/const_color.dart';
import 'package:yiapp/func/adapt.dart';
import 'package:yiapp/complex/tools/cus_time.dart';
import 'package:yiapp/complex/widgets/flutter/cus_dialog.dart';
import 'package:yiapp/complex/widgets/flutter/cus_text.dart';
import 'package:yiapp/model/dicts/master-apply.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/9/14 16:56
// usage ：大师通用的审批记录组件
// ------------------------------------------------------

typedef FnMater = void Function(MasterInfoApply master, int stat);

class MasterApproveItem extends StatefulWidget {
  final FnMater onApproval;
  final FnMater onCancel;
  final VoidCallback onLoad;
  final bool isAll;
  final List<MasterInfoApply> l;

  MasterApproveItem({
    this.onApproval,
    this.onCancel,
    this.onLoad,
    this.isAll,
    this.l,
    Key key,
  }) : super(key: key);

  @override
  _MasterApproveItemState createState() => _MasterApproveItemState();
}

class _MasterApproveItemState extends State<MasterApproveItem> {
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

  Widget _leftScroll(MasterInfoApply e) {
    _stat(e);
    return ListTile(
      // 名称
      title: CusText("${e.info.nick}", t_gray, 30),
      // 时间
      subtitle: CusText("${CusTime.ymdhm(e.create_date)}", t_gray, 30),
      // 审核状态
      trailing: CusText(_statStr, _statColor, 28),
      onTap: () => e.stat == 0
          ? CusDialog.normal(
              context,
              title: e.info.brief.isEmpty ? "大师简介" : e.info.brief,
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
              title: e.info.brief.isEmpty ? "大师简介" : e.info.brief,
            ),
    );
  }

  /// 根据审核状态显示
  void _stat(MasterInfoApply e) {
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
