import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../const/const_color.dart';
import '../../tools/adapt.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/8/7 10:19
// usage ：自定义提示弹框组件
// ------------------------------------------------------

class CusDialog {
  /// 警告弹框，一般用于执行不可回退的操作(如删除),可选择确定或取消
  static err(BuildContext context,
      {@required String title,
      String subTitle,
      String textAgree,
      String textCancel,
      Color titleCo,
      Color agreeCo,
      Color cancelCo,
      VoidCallback onApproval,
      VoidCallback onCancel}) {
    _ComDialog(
      context,
      textAgree: textAgree ?? "确定",
      textCancel: textCancel ?? "取消",
      agreeCo: agreeCo,
      cancelCo: cancelCo,
      onApproval: onApproval,
      onCancel: () {},
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(15),
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(
                  top: subTitle == null ? 25 : 10,
                  bottom: subTitle == null ? 25 : 5),
              child: Text(
                title,
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: titleCo,
                    fontSize: Adapt.px(34)),
              ),
            ),
            if (subTitle != null) ...[
              SizedBox(height: 10),
              Text(
                subTitle,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: Adapt.px(30),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// 普通弹框，可选择确定或取消
  static normal(BuildContext context,
      {@required String title,
      String subTitle,
      String textAgree,
      String textCancel,
      Color titleCo,
      Color agreeCo,
      Color cancelCo,
      VoidCallback onApproval,
      VoidCallback onCancel}) {
    _ComDialog(
      context,
      textAgree: textAgree ?? "确定",
      textCancel: textCancel ?? "取消",
      agreeCo: agreeCo ?? Colors.lightBlue,
      cancelCo: cancelCo,
      onApproval: onApproval,
      onCancel: () {},
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(
                  top: subTitle == null ? 25 : 10,
                  bottom: subTitle == null ? 25 : 5),
              child: Text(
                title, // title
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: titleCo,
                    fontSize: Adapt.px(34)),
              ),
            ),
            if (subTitle != null)
              Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: Text(
                  subTitle,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: Adapt.px(30),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// 提醒弹框，比如发布朋友圈内容不能为空的提醒，只有确定按钮
  static tip(BuildContext context,
      {@required String title,
      String subTitle,
      String textAgree,
      Color titleCo,
      Color agreeCo,
      VoidCallback onApproval}) {
    _ComDialog(
      context,
      onApproval: onApproval,
      textAgree: textAgree ?? "确定",
      agreeCo: agreeCo ?? Colors.black,
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(15),
        child: Column(
          children: <Widget>[
            Text(
              title,
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: titleCo,
                  fontSize: Adapt.px(34)),
            ),
            if (subTitle != null) ...[
              SizedBox(height: 10),
              Text(
                subTitle,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: Adapt.px(30),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// 通用的弹框模板
class _ComDialog {
  String title; // 中间提示的内容
  String subTitle;
  String textAgree; // 确定按钮名称
  String textCancel; // 取消按钮名称
  Color titleCo; // 提示内容颜色
  Color agreeCo; // 同意按钮颜色
  Color cancelCo; // 取消按钮颜色
  VoidCallback onApproval; // 同意按钮事件
  VoidCallback onCancel; // 取消按钮事件
  Widget child; // 按钮上面的组件

  _ComDialog(
    BuildContext context, {
    this.title = "确认删除吗？",
    this.subTitle,
    this.textAgree = '确定',
    this.textCancel = '取消',
    this.titleCo,
    this.agreeCo,
    this.cancelCo,
    this.onApproval,
    this.onCancel,
    this.child,
  }) {
    showDialog<Null>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return _dialogCtr(context);
      },
    );
  }

  Widget _dialogCtr(BuildContext context) {
    return AlertDialog(
      backgroundColor: tipBg,
      content: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            child,
            Divider(height: 1, color: CusColors.placeholder(context)),
            Container(
              child: Row(
                children: <Widget>[
                  if (onCancel != null) ...[
                    Expanded(
                        child: _buildBtn(context, onCancel, textCancel,
                            color: cancelCo ?? CusColors.label(context))),
                    Container(
                      width: 1,
                      height: 40,
                      decoration: BoxDecoration(
                        border: Border(
                          left: BorderSide(
                            width: 1,
                            color: CusColors.placeholder(context),
                          ),
                        ),
                      ),
                    ),
                  ],
                  Expanded(
                    child: _buildBtn(context, onApproval ?? () {}, textAgree,
                        color: agreeCo ?? CusColors.systemRed(context)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      contentPadding: EdgeInsets.all(0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    );
  }

  /// 下面的按钮模板
  Widget _buildBtn(BuildContext context, VoidCallback onPressed, String text,
      {Color color}) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        onPressed();
        Navigator.pop(context);
      },
      child: Semantics(
        button: true,
        child: ConstrainedBox(
          constraints: BoxConstraints(),
          child: Container(
            padding: EdgeInsets.all(10),
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(color: color),
            ),
          ),
        ),
      ),
    );
  }
}
