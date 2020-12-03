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
import 'package:yiapp/widget/master/hehun_res_show.dart';
import 'package:yiapp/widget/small/cus_loading.dart';
import 'package:yiapp/model/orders/yiOrder-dart.dart';
import 'package:yiapp/model/orders/yiOrder-heHun.dart';
import 'package:yiapp/service/api/api-yi-order.dart';
import 'package:yiapp/service/api/api_base.dart';
import 'package:yiapp/ui/home/home_page.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/10/23 16:24
// usage ：约聊合婚
// ------------------------------------------------------

class MeetHeHunPage extends StatefulWidget {
  final int master_id;
  final YiOrderHeHun heHun;
  final String timeHunMale;
  final String timeHunFemale;

  MeetHeHunPage({
    this.master_id,
    this.heHun,
    this.timeHunMale,
    this.timeHunFemale,
    Key key,
  }) : super(key: key);

  @override
  _MeetHeHunPageState createState() => _MeetHeHunPageState();
}

class _MeetHeHunPageState extends State<MeetHeHunPage> {
  var _contentCtrl = TextEditingController(); // 内容输入框
  String _err; // 错误提示信息
  YiOrderHeHun _heHun;

  @override
  void initState() {
    _heHun = widget.heHun;
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
              CusText("合婚测算", t_gray, 30),
            ],
          ),
          HeHunResShow(
              name: _heHun.name_male, sex: "男", time: widget.timeHunMale),
          HeHunResShow(
              name: _heHun.name_female, sex: "女", time: widget.timeHunFemale),
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

  void _doOrder() async {
    setState(() {
      _err = _contentCtrl.text.isEmpty ? "未填写描述的内容" : null;
    });
    if (_err != null) return;
    SpinKit.threeBounce(context);
    var m = {
      "master_id": widget.master_id,
      "master_cate_id": ApiBase.uid,
      "comment": _contentCtrl.text.trim(),
      "he_hun": widget.heHun.toJson(),
    };
    Log.info("数据：${m.toString()}");
    try {
      YiOrder res = await ApiYiOrder.yiOrderAdd(m);
      if (res != null) {
        Navigator.pop(context);
        CusToast.toast(context, text: "下单成功");
        CusRoute.pushReplacement(context, HomePage());
      }
    } catch (e) {
      Log.error("合婚下大师单出现异常：$e");
    }
  }
}
