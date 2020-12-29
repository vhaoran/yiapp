import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/const/con_string.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/model/complex/cus_liuyao_data.dart';
import 'package:yiapp/model/orders/yiOrder-liuyao.dart';
import 'package:yiapp/service/storage_util/prefs/kv_storage.dart';
import 'package:yiapp/ui/fortune/daily_fortune/liu_yao/liuyao_symbol_res.dart';
import 'package:yiapp/util/screen_util.dart';
import 'package:yiapp/util/time_util.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/12/29 下午6:59
// usage ：如果是六爻，显示的内容（提交大师订单及查看订单可用）
// ------------------------------------------------------

class MasterOrder extends StatefulWidget {
  final YiOrderLiuYao liuYao;

  MasterOrder({this.liuYao, Key key}) : super(key: key);

  @override
  _MasterOrderState createState() => _MasterOrderState();
}

class _MasterOrderState extends State<MasterOrder> {
  var _future;
  var _data = CusLiuYaoData();

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
      Log.error("获取本地存储的六爻数据出现异常：$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _future,
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return Center(child: CircularProgressIndicator());
        }
        return Column(
          children: <Widget>[
            _comRow("性别：", widget.liuYao.is_male ? "男" : "女"),
            _comRow("摇卦时间：", _birthDate()),
            SizedBox(height: S.h(10)),
            LiuYaoSymRes(res: _data.res, codes: _data.codes),
          ],
        );
      },
    );
  }

  /// 出生日期
  String _birthDate() {
    DateTime time = widget.liuYao.dateTime(); // 选择的年月日转换为DateTime
    return TimeUtil.YMDHM(date: time);
  }

  /// 通用的 Row
  Widget _comRow(String title, String subtitle) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: S.h(2)),
      child: Row(
        children: <Widget>[
          Text(title, style: TextStyle(color: t_primary, fontSize: S.sp(15))),
          Text(subtitle, style: TextStyle(color: t_gray, fontSize: S.sp(15))),
        ],
      ),
    );
  }
}
