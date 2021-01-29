import 'package:flutter/material.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/const/con_int.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/cus/cus_route.dart';
import 'package:yiapp/model/bo/broker_master_cate.dart';
import 'package:yiapp/model/complex/yi_date_time.dart';
import 'package:yiapp/model/orders/sizhu_content.dart';
import 'package:yiapp/model/sizhu/sizhu_result.dart';
import 'package:yiapp/service/api/api_pai_pan.dart';
import 'package:yiapp/ui/mine/my_orders/talk_about_master_detail.dart';
import 'package:yiapp/util/screen_util.dart';
import 'package:yiapp/util/time_util.dart';
import 'package:yiapp/widget/cus_button.dart';
import 'package:yiapp/widget/cus_complex.dart';
import 'package:yiapp/widget/cus_time_picker/picker_mode.dart';
import 'package:yiapp/widget/cus_time_picker/time_picker.dart';
import 'package:yiapp/widget/flutter/cus_appbar.dart';
import 'package:yiapp/widget/flutter/cus_toast.dart';
import 'package:yiapp/widget/flutter/rect_field.dart';
import 'package:yiapp/widget/small/cus_loading.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/12/25 上午11:08
// usage ：大师订单下单(默认四柱)
// ------------------------------------------------------

class TalkAboutMaster extends StatefulWidget {
  final BrokerMasterCate data;

  TalkAboutMaster({this.data, Key key}) : super(key: key);

  @override
  _TalkAboutMasterState createState() => _TalkAboutMasterState();
}

class _TalkAboutMasterState extends State<TalkAboutMaster> {
  var _nameCtrl = TextEditingController(); // 姓名
  var _briefCtrl = TextEditingController(); // 内容输入框
  int _sex = male; // 0 女，1 男
  String _timeStr = ""; // 用来显示时间
  YiDateTime _yi;
  bool _isLunar = false; // 是否阴历

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CusAppBar(text: "提交问题"),
      body: _lv(),
      backgroundColor: primary,
    );
  }

  Widget _lv() {
    TextStyle tYi = TextStyle(color: t_yi, fontSize: S.sp(15));
    return ScrollConfiguration(
      behavior: CusBehavior(),
      child: ListView(
        padding: EdgeInsets.symmetric(horizontal: S.w(15)),
        children: <Widget>[
          SizedBox(height: S.h(5)),
          // 服务类型
          _comBg(children: <Widget>[
            Text("亲测服务", style: tYi),
            Expanded(
              child: CusRectField(
                hintText: "${widget.data.yi_cate_name}",
                enable: false,
                autofocus: false,
                hideBorder: true,
              ),
            ),
          ]),
          // 姓名
          _comBg(children: <Widget>[
            Text("姓名", style: tYi),
            Expanded(
              child: CusRectField(
                controller: _nameCtrl,
                hintText: "可默认匿名",
                autofocus: false,
                hideBorder: true,
              ),
            ),
          ]),
          // 选择性别
          _comBg(children: <Widget>[
            Text("性别", style: tYi),
            _selectCtr(male, "男"),
            SizedBox(width: S.w(10)),
            _selectCtr(female, "女"),
          ]),
          // 选择出生日期
          _choseDate(),
          SizedBox(height: S.h(5)),
          CusRectField(
            controller: _briefCtrl,
            hintText: "请详细描述你的问题",
            maxLines: 10,
            autofocus: false,
          ),
          SizedBox(height: S.h(50)),
          // 提交
          CusRaisedButton(
              child: Text("下一步"), borderRadius: 50, onPressed: _doVerify),
        ],
      ),
    );
  }

  void _doVerify() async {
    String err;
    setState(() {
      if (_yi == null)
        err = "未选择日期";
      else if (_briefCtrl.text.isEmpty) err = "描述信息不能为空";
    });
    if (err != null) {
      CusToast.toast(context, text: err);
      return;
    }
    String name = _nameCtrl.text.trim().isEmpty ? "匿名" : _nameCtrl.text.trim();
    SiZhuContent content = SiZhuContent(
      is_solar: !_isLunar,
      name: name,
      is_male: _sex == male ? true : false,
      birth_date: _timeStr,
      year: _yi.year,
      month: _yi.month,
      day: _yi.day,
      hour: _yi.oldTime.hour,
      minute: _yi.oldTime.minute,
    );
    // 先排下四柱
    var m = {
      "is_male": content.is_male,
      "is_solar": content.is_solar,
      "year": content.year,
      "month": content.month,
      "day": content.day,
      "hour": content.hour,
      "minute": content.minute,
      "name": content.name,
    };
    SpinKit.threeBounce(context);
    try {
      SiZhuResult siZhuRes = await ApiPaiPan.paiBaZi(m);
      if (siZhuRes != null) {
        Navigator.pop(context);
        content.sizhu_res = siZhuRes;
        CusRoute.push(
          context,
          TalkAboutMasterDetail(
            siZhuContent: content,
            cateData: widget.data,
            comment: _briefCtrl.text.trim(),
          ),
        );
      }
    } catch (e) {
      Log.error("出现异常：$e");
    }
  }

  /// 选择出生日期
  Widget _choseDate() {
    _timeStr = _yi == null
        ? "请选择出生日期"
        : TimeUtil.YMDHM(isSolar: !_isLunar, date: _yi, comment: true);
    return _comBg(
      children: <Widget>[
        Text("出生日期", style: TextStyle(color: t_yi, fontSize: S.sp(15))),
        Expanded(
          child:
              CusRectField(hintText: _timeStr, hideBorder: true, enable: false),
        ),
        CusRaisedButton(
          padding: EdgeInsets.symmetric(horizontal: S.w(10), vertical: S.h(3)),
          backgroundColor: Colors.grey,
          child: Text("选择", style: TextStyle(color: Colors.black)),
          onPressed: () => TimePicker(
            context,
            pickMode: PickerMode.full,
            showLunar: true,
            isLunar: (val) => setState(() => _isLunar = val),
            onConfirm: (val) => setState(() => _yi = val),
          ),
        ),
        SizedBox(width: S.w(10)),
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
        Text(text, style: TextStyle(color: t_gray, fontSize: S.sp(15))),
      ],
    );
  }

  /// 通用背景组件
  Widget _comBg({List<Widget> children}) {
    return Container(
      padding: EdgeInsets.only(left: S.w(15)),
      margin: EdgeInsets.symmetric(vertical: S.h(5)),
      decoration: BoxDecoration(
        color: fif_primary,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(children: <Widget>[...children]),
    );
  }
}
