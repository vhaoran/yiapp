import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:yiapp/complex/class/debug_log.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/const/const_string.dart';
import 'package:yiapp/complex/model/cus_liuyao_data.dart';
import 'package:yiapp/complex/tools/adapt.dart';
import 'package:yiapp/complex/tools/cus_routes.dart';
import 'package:yiapp/complex/type/bool_utils.dart';
import 'package:yiapp/complex/widgets/cus_complex.dart';
import 'package:yiapp/complex/widgets/flutter/cus_appbar.dart';
import 'package:yiapp/complex/widgets/flutter/cus_button.dart';
import 'package:yiapp/complex/widgets/flutter/cus_divider.dart';
import 'package:yiapp/complex/widgets/flutter/cus_text.dart';
import 'package:yiapp/complex/widgets/flutter/cus_toast.dart';
import 'package:yiapp/complex/widgets/flutter/rect_field.dart';
import 'package:yiapp/complex/widgets/small/cus_loading.dart';
import 'package:yiapp/model/liuyaos/liuyao_riqi.dart';
import 'package:yiapp/model/orders/yiOrder-dart.dart';
import 'package:yiapp/service/api/api-yi-order.dart';
import 'package:yiapp/service/api/api_base.dart';
import 'package:yiapp/service/storage_util/prefs/kv_storage.dart';
import 'package:yiapp/ui/fortune/daily_fortune/liu_yao/liuyao_symbol_res.dart';
import 'package:yiapp/ui/home/home_page.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/10/19 17:55
// usage ：约聊大师 -- 六爻
// ------------------------------------------------------

class MeetLiuyaoPage extends StatefulWidget {
  final int master_id;

  MeetLiuyaoPage({this.master_id, Key key}) : super(key: key);

  @override
  _MeetLiuyaoPageState createState() => _MeetLiuyaoPageState();
}

class _MeetLiuyaoPageState extends State<MeetLiuyaoPage> {
  var _future;
  var _data = CusLiuYaoData();
  var _contentCtrl = TextEditingController(); // 内容输入框
  String _err; // 错误提示信息

  @override
  void initState() {
    _future = _fetch();
    super.initState();
  }

  _fetch() async {
    try {
      String res = await KV.getStr(kv_liuyao);
      if (res != null) {
        _data = CusLiuYaoData.fromJson(json.decode(res));
      }
    } catch (e) {
      Debug.logError("获取本地存储的六爻数据出现异常：$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CusAppBar(text: "约聊大师"),
      body: FutureBuilder(
        future: _future,
        builder: (context, snap) {
          if (!snapDone(snap)) {
            return Center(child: CircularProgressIndicator());
          }
          return _lv();
        },
      ),
      backgroundColor: primary,
    );
  }

  Widget _lv() {
    return ScrollConfiguration(
      behavior: CusBehavior(),
      child: ListView(
        padding: EdgeInsets.all(Adapt.px(30)),
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(vertical: Adapt.px(20)),
            child: Row(
              children: <Widget>[
                CusText("服务类型", t_gray, 30),
                SizedBox(width: Adapt.px(40)),
                CusText("六爻排盘", t_primary, 30),
              ],
            ),
          ),
          CusText("排盘结果", t_gray, 30),
          LiuYaoSymRes(res: _data.res, codes: _data.codes),
          CusDivider(),
          CusText("问题描述", t_gray, 30),
          SizedBox(height: Adapt.px(20)),
          CusRectField(
            controller: _contentCtrl,
            maxLines: 10,
            autofocus: false,
            hintText: "请详细描述你的问题",
            errorText: _err,
          ),
          SizedBox(height: Adapt.px(20)),
          CusRaisedBtn(
            text: "下单",
            backgroundColor: Colors.blueGrey,
            onPressed: _doOrder,
          ),
        ],
      ),
    );
  }

  /// 六爻下单
  void _doOrder() async {
    setState(() {
      _err = _contentCtrl.text.isEmpty ? "提交的内容不能为空" : null;
    });
    if (_err != null) return;
    CusLoading(context);
    Navigator.pop(context);
    LiuYaoRiqi riqi = _data.res.riqi;
    var m = {
      "master_id": widget.master_id,
      "comment": _contentCtrl.text.trim(),
      "master_cate_id": ApiBase.uid,
      "liu_yao": {
        "year": riqi.year,
        "month": riqi.month,
        "day": riqi.day,
        "hour": riqi.hour,
        "minute": riqi.minute,
        "is_male": riqi.is_male,
        "yao_code": _data.strCode
      },
    };
    Debug.log("数据：${m.toString()}");
    try {
      YiOrder res = await ApiYiOrder.yiOrderAdd(m);
      if (res != null) {
        CusToast.toast(context, text: "下单成功");
        CusRoutes.pushReplacement(context, HomePage());
      }
    } catch (e) {
      Debug.logError("六爻下大师单出现异常：$e");
    }
  }

  @override
  void dispose() {
    _contentCtrl.dispose();
    super.dispose();
  }
}
