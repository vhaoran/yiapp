import 'package:flutter/material.dart';
import 'package:yiapp/complex/class/debug_log.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/const/const_int.dart';
import 'package:yiapp/complex/model/yi_date_time.dart';
import 'package:yiapp/complex/tools/adapt.dart';
import 'package:yiapp/complex/tools/cus_routes.dart';
import 'package:yiapp/complex/widgets/cus_complex.dart';
import 'package:yiapp/complex/widgets/cus_time_picker/picker_mode.dart';
import 'package:yiapp/complex/widgets/cus_time_picker/time_picker.dart';
import 'package:yiapp/complex/widgets/flutter/cus_appbar.dart';
import 'package:yiapp/complex/widgets/flutter/cus_button.dart';
import 'package:yiapp/complex/widgets/flutter/cus_snackbar.dart';
import 'package:yiapp/complex/widgets/flutter/cus_text.dart';
import 'package:yiapp/complex/widgets/flutter/rect_field.dart';
import 'package:yiapp/model/orders/yiOrder-sizhu.dart';
import 'package:yiapp/ui/master/master_order/master_recommend.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/10/22 16:02
// usage ：四柱测算
// ------------------------------------------------------

class SiZhuMeasure extends StatefulWidget {
  SiZhuMeasure({Key key}) : super(key: key);

  @override
  _SiZhuMeasureState createState() => _SiZhuMeasureState();
}

class _SiZhuMeasureState extends State<SiZhuMeasure> {
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  var _nameCtrl = TextEditingController(); // 姓名
  int _sex = male; // 0 女，1 男
  bool _isLunar = false; // 是否阴历
  String _timeStr = ""; // 用来显示时间
  YiDateTime _yi;
  String _err; // 错误提示信息

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: CusAppBar(text: "四柱测算"),
      body: _lv(),
      backgroundColor: primary,
    );
  }

  Widget _lv() {
    return ListView(
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 20),
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Center(child: CusText("填写个人基本信息", t_primary, 30)),
        ),
        // 姓名输入框
        _bgCtr(children: <Widget>[
          CusText("您的姓名", t_yi, 30),
          Expanded(
            child: CusRectField(
              controller: _nameCtrl,
              hintText: "(可不填)",
              autofocus: false,
              hideBorder: true,
            ),
          ),
        ]),
        // 选择性别
        _bgCtr(children: <Widget>[
          CusText("您的性别", t_yi, 30),
          _selectCtr(male, "男"),
          SizedBox(width: Adapt.px(20)),
          _selectCtr(female, "女"),
        ]),
        // 选择出生日期
        _choseDate(),
        SizedBox(height: Adapt.px(70)),
        // 大师亲测
        CusRaisedBtn(
          text: "大师亲测",
          backgroundColor: Colors.blueGrey,
          onPressed: _doMasterTest,
        ),
      ],
    );
  }

  /// 大师亲测
  void _doMasterTest() {
    setState(() {
      _err = null;
      if (_yi == null) _err = "未选择日期";
    });
    if (_err != null) {
      CusSnackBar(
        context,
        scaffoldKey: _scaffoldKey,
        text: _err,
        backgroundColor: fif_primary,
      );
      return;
    }
    YiOrderSiZhu siZhu = YiOrderSiZhu(
      is_solar: !_isLunar,
      name: _nameCtrl.text.trim(),
      is_male: _sex == male ? true : false,
      year: _yi.year,
      month: _yi.month,
      day: _yi.day,
      hour: _yi.hour,
      minute: _yi.minute,
    );
    Debug.log(
        "信息：_err:$_err,sex:$_sex,name:${_nameCtrl.text},时间：${_yi.toJson()}");
    CusRoutes.push(
      context,
      MasterRecommend(type: post_sizhu, siZhu: siZhu, timeStr: _timeStr),
    );
  }

  /// 选择出生日期
  Widget _choseDate() {
    _timeStr = _yi == null ? "请选择出生日期" : _yi.yiTimeShow(_yi, _isLunar);
    return _bgCtr(
      children: <Widget>[
        CusText("出生日期", t_yi, 30),
        Expanded(
          child:
              CusRectField(hintText: _timeStr, hideBorder: true, enable: false),
        ),
        CusRaisedBtn(
          text: "选择",
          pdVer: 0,
          pdHor: 15,
          fontSize: 28,
          textColor: Colors.black,
          backgroundColor: t_gray,
          onPressed: () => TimePicker(
            context,
            pickMode: PickerMode.yi,
            showLunar: true,
            isLunar: (val) => setState(() => _isLunar = val),
            onConfirm: (val) => setState(() => _yi = val),
          ),
        ),
        SizedBox(width: Adapt.px(20)),
      ],
    );
  }

  /// 选择性别组件
  Widget _selectCtr(int value, String text) {
    return Row(
      children: <Widget>[
        Radio(
          value: value,
          groupValue: _sex,
          activeColor: t_primary,
          onChanged: (val) => setState(() => _sex = val),
        ),
        CusText(text, t_gray, 28),
      ],
    );
  }

  /// 通用背景组件
  Widget _bgCtr({List<Widget> children}) {
    return Container(
      height: Adapt.px(90),
      padding: EdgeInsets.only(left: Adapt.px(30)),
      margin: EdgeInsets.symmetric(vertical: Adapt.px(10)),
      decoration: BoxDecoration(
        color: fif_primary,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(children: <Widget>[...children]),
    );
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }
}
