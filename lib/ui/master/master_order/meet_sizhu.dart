import 'package:flutter/material.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/util/adapt.dart';
import 'package:yiapp/cus/cus_route.dart';
import 'package:yiapp/widget/cus_complex.dart';
import 'package:yiapp/widget/flutter/cus_appbar.dart';
import 'package:yiapp/widget/flutter/cus_button.dart';
import 'package:yiapp/widget/flutter/cus_divider.dart';
import 'package:yiapp/widget/flutter/cus_text.dart';
import 'package:yiapp/widget/flutter/cus_toast.dart';
import 'package:yiapp/widget/flutter/rect_field.dart';
import 'package:yiapp/widget/small/cus_loading.dart';
import 'package:yiapp/model/orders/yiOrder-dart.dart';
import 'package:yiapp/model/orders/yiOrder-sizhu.dart';
import 'package:yiapp/service/api/api-yi-order.dart';
import 'package:yiapp/service/api/api_base.dart';
import 'package:yiapp/ui/home/home_page.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/10/22 18:04
// usage ：约聊四柱
// ------------------------------------------------------

class MeetSiZhuPage extends StatefulWidget {
  final int master_id;
  final YiOrderSiZhu siZhu;
  final String timeSiZhu;

  MeetSiZhuPage({
    this.master_id,
    this.siZhu,
    this.timeSiZhu,
    Key key,
  }) : super(key: key);

  @override
  _MeetSiZhuPageState createState() => _MeetSiZhuPageState();
}

class _MeetSiZhuPageState extends State<MeetSiZhuPage> {
  var _contentCtrl = TextEditingController(); // 内容输入框
  String _err; // 错误提示信息
  YiOrderSiZhu _siZhu;

  @override
  void initState() {
    _siZhu = widget.siZhu;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CusAppBar(text: "约聊大师"),
      body: _lv(),
      backgroundColor: primary,
    );
  }

  Widget _lv() {
    return ScrollConfiguration(
      behavior: CusBehavior(),
      child: ListView(
        padding: EdgeInsets.all(Adapt.px(30)),
        children: <Widget>[
          Row(
            children: <Widget>[
              CusText("服务类型", t_primary, 30),
              SizedBox(width: Adapt.px(40)),
              CusText("四柱测算", t_gray, 30),
            ],
          ),
          CusDivider(),
          CusText("基本信息", t_primary, 30),
          _baseInfo(),
          CusDivider(),
          CusText("问题描述", t_primary, 30),
          SizedBox(height: Adapt.px(20)),
          CusRectField(
            controller: _contentCtrl,
            maxLines: 10,
            autofocus: false,
            hintText: "请详细描述你的问题",
            errorText: _err,
          ),
          SizedBox(height: Adapt.px(20)),
          CusBtn(
            text: "下单",
            backgroundColor: Colors.blueGrey,
            onPressed: _doOrder,
          ),
        ],
      ),
    );
  }

  Widget _baseInfo() {
    return Column(
      children: <Widget>[
        SizedBox(height: Adapt.px(20)),
        Row(
          children: <Widget>[
            CusText("姓名：", t_primary, 30),
            CusText(_siZhu.name, t_gray, 30),
          ],
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: Adapt.px(10)),
          child: Row(
            children: <Widget>[
              CusText("性别：", t_primary, 30),
              CusText(_siZhu.is_male ? "男" : "女", t_gray, 30),
            ],
          ),
        ),
        Row(
          children: <Widget>[
            CusText("出生日期：", t_primary, 30),
            CusText(widget.timeSiZhu, t_gray, 30),
          ],
        ),
      ],
    );
  }

  void _doOrder() async {
    setState(() {
      _err = _contentCtrl.text.isEmpty ? "未填写描述的内容" : null;
    });
    if (_err != null) return;
    var m = {
      "master_id": widget.master_id,
      "yi_cate_id": ApiBase.uid,
      "comment": _contentCtrl.text.trim(),
      "si_zhu": widget.siZhu.toJson(),
    };
    Log.info("数据：${m.toString()}");
    try {
      SpinKit.threeBounce(context);
      YiOrder res = await ApiYiOrder.yiOrderAdd(m);
      if (res != null) {
        Navigator.pop(context);
        Log.info("四柱下单后返回的订单id：${res.id}");
        CusToast.toast(context, text: "下单成功");
        CusRoute.pushReplacement(context, HomePage());
      }
    } catch (e) {
      Log.error("四柱下大师单出现异常：$e");
    }
  }
}
