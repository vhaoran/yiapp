import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:yiapp/complex/class/debug_log.dart';
import 'package:yiapp/complex/class/yi_date_time.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/const/const_int.dart';
import 'package:yiapp/complex/const/const_string.dart';
import 'package:yiapp/complex/tools/adapt.dart';
import 'package:yiapp/complex/tools/yi_tool.dart';
import 'package:yiapp/complex/widgets/cus_time_picker/picker_mode.dart';
import 'package:yiapp/complex/widgets/cus_time_picker/time_picker.dart';
import 'package:yiapp/complex/widgets/flutter/cus_appbar.dart';
import 'package:yiapp/complex/widgets/flutter/cus_snackbar.dart';
import 'package:yiapp/complex/widgets/flutter/cus_text.dart';
import 'package:yiapp/complex/widgets/flutter/cus_toast.dart';
import 'package:yiapp/complex/widgets/flutter/rect_field.dart';
import 'package:yiapp/model/bbs/bbs-Prize.dart';
import 'package:yiapp/service/api/api-bbs-prize.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/9/21 17:19
// usage ：我要提问 0 其他 1 六爻 2 四柱 3 合婚
// ------------------------------------------------------

class AskQuestionPage extends StatefulWidget {
  final int content_type; // 提问类型

  AskQuestionPage({this.content_type, Key key}) : super(key: key);

  @override
  _AskQuestionPageState createState() => _AskQuestionPageState();
}

class _AskQuestionPageState extends State<AskQuestionPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String _snackErr; // 提示信息
  bool _isLunar = false; // 是否选择了阴历

  var _nameCtrl = TextEditingController(); // 姓名
  YiDateTime _birth; // 出生日期
  var _scoreCtrl = TextEditingController(); // 悬赏金额
  var _titleCtrl = TextEditingController(); // 帖子标题
  var _briefCtrl = TextEditingController(); // 帖子摘要

  int _male = 1; // 性别

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CusAppBar(
        text: "我要提问",
        actions: <Widget>[
          FlatButton(onPressed: _doPost, child: CusText("发帖", t_gray, 28)),
        ],
      ),
      body: _lv(),
      key: _scaffoldKey,
      backgroundColor: primary,
    );
  }

  Widget _lv() {
    return ListView(
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: Adapt.px(25)),
      children: <Widget>[
        Container(
          alignment: Alignment.center,
          padding: EdgeInsets.only(top: Adapt.px(10)),
          child: CusText("填写您的基本信息", t_primary, 32),
        ),
        _nameInput(), // 姓名
        _birthTime(), // 选择出生日期
        _sex(),
        _moneyInput(), // 设置悬赏金
        Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(vertical: Adapt.px(30)),
          child: CusText("输入您要咨询的问题", t_primary, 32),
        ),
        _titleInput(), // 帖子标题
        _briefInput(), // 帖子摘要
      ],
    );
  }

  /// 发帖
  void _doPost() async {
    setState(() {
      if (_snackErr != null) _snackErr = null; // 清空错误信息
      if (_nameCtrl.text.isEmpty) {
        _snackErr = "姓名不能为空";
      } else if (_birth == null) {
        _snackErr = "请选择出生日期";
      } else if (_scoreCtrl.text.isEmpty) {
        _snackErr = "悬赏金额不能为空";
      } else if (_titleCtrl.text.isEmpty) {
        _snackErr = "帖子标题不能为空";
      } else if (_briefCtrl.text.isEmpty) {
        _snackErr = "帖子内容不能为空";
      }
    });
    // 不满足发帖条件
    if (_snackErr != null) {
      CusSnackBar(
        context,
        scaffoldKey: _scaffoldKey,
        text: _snackErr,
        milliseconds: 1200,
        backgroundColor: fif_primary,
      );
    }
    // 满足发帖条件
    else {
      var m = {
        "score": num.parse(_scoreCtrl.text.trim()),
        "title": _titleCtrl.text.trim(),
        "brief": _briefCtrl.text.trim(),
        "content_type": widget.content_type,
        "content": {
          "is_solar": !_isLunar,
          "name": _nameCtrl.text.trim(),
          "is_male": _male == male ? true : false,
          "year": _birth.year,
          "month": _birth.month,
          "day": _birth.day,
          "hour": _birth.hour,
          "minutes": _birth.minute,
        },
      };
      BBSPrize res = await ApiBBSPrize.bbsPrizeAdd(m);
      if (res != null) {
        Debug.log("发帖结果：${res.toJson()}");
        CusToast.toast(context, text: "发帖成功，订单待支付");
        Navigator.pop(context);
      }
    }
  }

  /// 姓名输入框
  Widget _nameInput() {
    return Container(
      padding: EdgeInsets.only(left: Adapt.px(30)),
      margin: EdgeInsets.symmetric(vertical: Adapt.px(30)),
      decoration: BoxDecoration(
          color: fif_primary, borderRadius: BorderRadius.circular(10)),
      child: Row(
        children: <Widget>[
          CusText("您的姓名", t_yi, 30),
          Expanded(
            child: CusRectField(
              controller: _nameCtrl,
              hintText: "请输入您的姓名",
              autofocus: false,
              hideBorder: true,
              maxLength: 10,
            ),
          ),
        ],
      ),
    );
  }

  /// 选择出生日期
  Widget _birthTime() {
    return InkWell(
      onTap: () {
        if (_isLunar != false) _isLunar = false;
        TimePicker(
          context,
          pickMode: PickerMode.full,
          showLunar: true,
          isLunar: (val) => setState(() => _isLunar = val),
          onConfirm: (yiDate) => setState(() => _birth = yiDate),
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: Adapt.px(30),
          vertical: Adapt.px(20),
        ),
        decoration: BoxDecoration(
          color: fif_primary,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            CusText("出生日期", t_yi, 30),
            Text(
              _birth == null
                  ? "选择出生日期"
                  : _isLunar
                      ? "${YiTool.fullDateNong(_birth)}"
                      : "${YiTool.fullDateGong(_birth)}",
              style: TextStyle(color: t_gray, fontSize: Adapt.px(30)),
            ),
            Icon(FontAwesomeIcons.calendarAlt, color: t_yi),
          ],
        ),
      ),
    );
  }

  Widget _sex() {
    return Container(
      padding: EdgeInsets.only(left: Adapt.px(30)),
      margin: EdgeInsets.symmetric(vertical: Adapt.px(30)),
      decoration: BoxDecoration(
          color: fif_primary, borderRadius: BorderRadius.circular(10)),
      child: Row(
        children: <Widget>[
          CusText("您的性别", t_yi, 30),
          _selectCtr(male, "男"),
          _selectCtr(female, "女"),
        ],
      ),
    );
  }

  Widget _selectCtr(int value, String text) {
    return Row(
      children: <Widget>[
        Radio(
          value: value,
          groupValue: _male,
          activeColor: t_gray,
          focusColor: value == 0 ? Colors.red : Colors.green,
          hoverColor: Colors.blue,
          onChanged: (val) => setState(() => _male = val),
        ),
        CusText(text, t_gray, 28),
      ],
    );
  }

  /// 设置悬赏金
  Widget _moneyInput() {
    return Container(
      padding: EdgeInsets.only(left: Adapt.px(30)),
      decoration: BoxDecoration(
          color: fif_primary, borderRadius: BorderRadius.circular(10)),
      child: Row(
        children: <Widget>[
          CusText("悬赏金额", t_yi, 30),
          Expanded(
            child: CusRectField(
              controller: _scoreCtrl,
              hintText: "请输入$yuan_bao金额",
              autofocus: false,
              hideBorder: true,
              formatter: true,
            ),
          ),
        ],
      ),
    );
  }

  /// 帖子标题输入框
  Widget _titleInput() {
    return Container(
      padding: EdgeInsets.only(left: Adapt.px(30)),
      decoration: BoxDecoration(
          color: fif_primary, borderRadius: BorderRadius.circular(10)),
      child: Row(
        children: <Widget>[
          CusText("帖子标题", t_yi, 30),
          Expanded(
            child: CusRectField(
              controller: _titleCtrl,
              hintText: "请输入帖子标题",
              autofocus: false,
              hideBorder: true,
            ),
          ),
        ],
      ),
    );
  }

  /// 帖子摘要输入框
  Widget _briefInput() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: Adapt.px(30)),
      padding: EdgeInsets.only(left: Adapt.px(30)),
      decoration: BoxDecoration(
          color: fif_primary, borderRadius: BorderRadius.circular(10)),
      child: CusRectField(
        controller: _briefCtrl,
        hintText: "该区域填写您的帖子内容，问题描述的越清晰，详尽，大师们才能更完整、更高质量的为您解答",
        autofocus: false,
        hideBorder: true,
        maxLines: 10,
        pdHor: 0,
      ),
    );
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _scoreCtrl.dispose();
    _titleCtrl.dispose();
    _briefCtrl.dispose();
    super.dispose();
  }
}
