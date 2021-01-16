import 'dart:math';
import 'package:flutter/material.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/util/screen_util.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2021/1/16 下午2:49
// usage ：自定义版本更新加提示框
// ------------------------------------------------------

class CusUpdateDialog {
  bool _isShowing = false;
  BuildContext _context;
  UpdateWidget _widget;

  CusUpdateDialog(
    BuildContext context, {
    double width,
    @required VoidCallback onUpdate,
    Widget updateTitle,
    Widget topTitle,
    double buttonTextSize,
    double progress,
    Color progressBackgroundColor,
    Image topImage,
    double extraHeight,
    double radius,
    Color buttonColor,
    bool enableIgnore,
    VoidCallback onIgnore,
    bool isForce,
    String updateButtonText,
    String ignoreButtonText,
    VoidCallback onClose,
  }) {
    _context = context;
    _widget = UpdateWidget(
      topTitle: topTitle,
      updateTitle: updateTitle,
      width: width,
      onUpdate: onUpdate,
      buttonTextSize: buttonTextSize,
      progress: progress,
      topImage: topImage,
      extraHeight: extraHeight,
      radius: radius,
      buttonColor: buttonColor,
      progressBackgroundColor: progressBackgroundColor,
      enableIgnore: enableIgnore,
      onIgnore: onIgnore,
      isForce: isForce,
      updateButtonText: updateButtonText,
      ignoreButtonText: ignoreButtonText,
      onClose: onClose != null ? onClose : () => {_dismiss()},
    );
  }

  /// 显示弹窗
  Future<bool> _show() {
    try {
      if (_isShow()) {
        return Future.value(false);
      }
      showDialog(
          context: _context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return WillPopScope(
                onWillPop: () => Future.value(false), child: _widget);
          });
      _isShowing = true;
      return Future.value(true);
    } catch (err) {
      _isShowing = false;
      return Future.value(false);
    }
  }

  /// 隐藏弹窗
  Future<bool> _dismiss() {
    try {
      if (_isShowing) {
        _isShowing = false;
        Navigator.pop(_context);
        return Future.value(true);
      } else {
        return Future.value(false);
      }
    } catch (err) {
      return Future.value(false);
    }
  }

  /// 是否显示
  bool _isShow() {
    return _isShowing;
  }

  /// 更新进度
//  void _update(double progress) {
//    if (_isShow()) {
//      _widget.update(progress);
//    }
//  }

  /// 显示版本更新提示框，设置初始值
  static CusUpdateDialog showUpdate(
    BuildContext context, {
    double width = 260,
    Widget updateTitle,
    Widget topTitle,
    @required String updateContent,
    @required VoidCallback onUpdate,
    double buttonTextSize = 15,
    double progress = -1,
    Color progressBackgroundColor = const Color(0xFFFFCDD2),
    Image topImage,
    double extraHeight = 5,
    double radius = 4,
    Color buttonColor = primary,
    bool enableIgnore = false,
    VoidCallback onIgnore,
    String updateButtonText: "升级",
    String ignoreButtonText,
    bool isForce = false,
  }) {
    CusUpdateDialog dialog = CusUpdateDialog(
      context,
      updateTitle: updateTitle,
      topTitle: topTitle,
      width: width,
      onUpdate: onUpdate,
      buttonTextSize: buttonTextSize,
      progress: progress,
      topImage: topImage,
      extraHeight: extraHeight,
      radius: radius,
      buttonColor: buttonColor,
      progressBackgroundColor: progressBackgroundColor,
      enableIgnore: enableIgnore,
      isForce: isForce,
      updateButtonText: updateButtonText,
      ignoreButtonText: ignoreButtonText,
      onIgnore: onIgnore,
    );
    dialog._show();
    return dialog;
  }
}

// ignore: must_be_immutable
class UpdateWidget extends StatefulWidget {
  final Widget updateTitle; // 更新内容组件
  final Widget topTitle;
  final double width; // 对话框的宽度
  final double buttonTextSize; // 按钮文字的大小
  final Widget topImage; // 顶部图片
  final double extraHeight; //拓展高度(适配顶部图片高度不一致的情况）
  final double radius; // 边框圆角大小
  final Color buttonColor; // 主题颜色
  final VoidCallback onUpdate; // 更新事件
  final bool enableIgnore; // 可忽略更新
  final VoidCallback onIgnore; // 更新事件
  double progress;
  final Color progressBackgroundColor; // 进度条的背景颜色
  final VoidCallback onClose; // 更新事件
  final bool isForce; // 是否是强制更新
  final String updateButtonText; // 更新按钮内容
  final String ignoreButtonText; // 忽略按钮内容

  // 其初始值在调用的地方106行设置
  UpdateWidget({
    @required this.updateTitle,
    @required this.topTitle,
    this.width,
    @required this.onUpdate,
    this.buttonTextSize,
    this.progress,
    this.progressBackgroundColor,
    this.topImage,
    this.extraHeight,
    this.radius,
    this.buttonColor,
    this.enableIgnore,
    this.onIgnore,
    this.isForce,
    this.updateButtonText,
    this.ignoreButtonText,
    this.onClose,
    Key key,
  }) : super(key: key);

  _UpdateWidgetState _state = _UpdateWidgetState();

  update(double progress) {
    _state.update(progress);
  }

  @override
  _UpdateWidgetState createState() => _state;
}

class _UpdateWidgetState extends State<UpdateWidget> {
  update(double progress) {
    if (!mounted) {
      return;
    }
    setState(() {
      widget.progress = progress;
    });
  }

  @override
  Widget build(BuildContext context) {
    double dialogWidth =
        widget.width <= 0 ? getFitWidth(context) * 0.618 : widget.width;
    return Material(
        type: MaterialType.transparency,
        child: SizedBox(
          width: dialogWidth,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // 设置顶部图片
              SizedBox(
                width: dialogWidth,
                child: widget.topImage != null
                    ? widget.topImage
                    : Image.asset('assets/images/bg_update_top.png',
                        fit: BoxFit.fill),
              ),
              Container(
                width: dialogWidth,
                alignment: Alignment.center,
                padding:
                    EdgeInsets.symmetric(horizontal: S.w(16), vertical: S.h(8)),
                decoration: ShapeDecoration(
                  color: fif_primary, // 背景色(不算顶部图片)
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(widget.radius),
                        bottomRight: Radius.circular(widget.radius)),
                  ),
                ),
                child: SingleChildScrollView(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(top: widget.extraHeight),
                      child: widget.topTitle, // 顶部描述信息
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: S.h(10)),
                      child: widget.updateTitle, // 更新了什么
                    ),
                    // 根据更新进度决定显示什么
                    widget.progress < 0
                        ?
                        // 升级按钮
                        Column(children: <Widget>[
                            FractionallySizedBox(
                              widthFactor: 1,
                              child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50)),
                                elevation: 0,
                                highlightElevation: 0,
                                child: Text(widget.updateButtonText,
                                    style: TextStyle(
                                        fontSize: widget.buttonTextSize)),
                                color: widget.buttonColor,
                                textColor: t_gray,
                                onPressed: widget.onUpdate,
                              ),
                            ),
                            widget.enableIgnore && widget.onIgnore != null
                                ? FractionallySizedBox(
                                    widthFactor: 1,
                                    child: FlatButton(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: Text(widget.ignoreButtonText,
                                          style: TextStyle(
                                              fontSize: widget.buttonTextSize)),
                                      materialTapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      textColor: Color(0xFF666666),
                                      onPressed: widget.onIgnore,
                                    ),
                                  )
                                : SizedBox()
                          ])
                        :
                        // 更新进度条
                        CusNumProgress(
                            value: widget.progress,
                            backgroundColor: widget.progressBackgroundColor,
                            valueColor: widget.buttonColor,
                            padding: EdgeInsets.symmetric(vertical: 10))
                  ],
                )),
              ),
              !widget.isForce
                  ? Column(children: <Widget>[
                      // 中间的竖线
                      SizedBox(
                          width: 1.5,
                          height: 50,
                          child: DecoratedBox(
                              decoration: BoxDecoration(color: t_gray))),
                      IconButton(
                        iconSize: 30, // 关闭弹窗按钮
                        constraints:
                            BoxConstraints(maxHeight: 30, maxWidth: 30),
                        padding: EdgeInsets.zero,
                        icon: Image.asset('assets/images/update_ic_close.png',
                            color: t_gray),
                        onPressed: widget.onClose,
                      )
                    ])
                  : SizedBox()
            ],
          ),
        ));
  }

  double getFitWidth(BuildContext context) {
    return min(getScreenHeight(context), getScreenWidth(context));
  }

  double getScreenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  double getScreenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }
}

/// 带进度文字的圆角进度条
class CusNumProgress extends StatelessWidget {
  final double height; // 进度条的高度
  final double value; // 进度
  final Color backgroundColor; // 进度条的背景颜色
  final Color valueColor; // 进度条的色值
  final Color textColor; // 文字的颜色
  final double textSize; // 文字的大小
  final AlignmentGeometry textAlignment; // 文字的对齐方式
  final EdgeInsetsGeometry padding; // 边距

  CusNumProgress(
      {Key key,
      this.height = 10,
      this.value = 0,
      this.backgroundColor,
      this.valueColor,
      this.textColor = Colors.white,
      this.textSize = 8,
      this.padding = EdgeInsets.zero,
      this.textAlignment = Alignment.center})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: padding,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            SizedBox(
              height: height,
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(height)),
                child: LinearProgressIndicator(
                  value: value,
                  backgroundColor: backgroundColor,
                  valueColor: AlwaysStoppedAnimation<Color>(valueColor),
                ),
              ),
            ),
            Container(
              height: height,
              alignment: textAlignment,
              child: Text(
                value >= 1 ? '100%' : '${(value * 100).toInt()}%',
                style: TextStyle(
                  color: textColor,
                  fontSize: textSize,
                ),
              ),
            ),
          ],
        ));
  }
}
