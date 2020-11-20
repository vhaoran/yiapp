import 'package:flutter/material.dart';
import 'package:yiapp/complex/class/debug_log.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/tools/api_state.dart';
import 'package:yiapp/complex/type/bool_utils.dart';
import 'package:yiapp/complex/widgets/cus_complex.dart';
import 'package:yiapp/complex/widgets/flutter/cus_appbar.dart';
import 'package:yiapp/complex/widgets/flutter/cus_text.dart';
import 'package:yiapp/model/bbs/question_res.dart';
import 'package:yiapp/model/bo/price_level_res.dart';
import 'package:yiapp/service/api/api_bo.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/11/20 下午3:39
// usage ：问命结果详情
// ------------------------------------------------------

class QueDetailPage extends StatefulWidget {
  final QuestionRes data;
  final String barName;

  QueDetailPage({this.barName, this.data, Key key}) : super(key: key);

  @override
  _QueDetailPageState createState() => _QueDetailPageState();
}

class _QueDetailPageState extends State<QueDetailPage> {
  var _future;
  List<PriceLevelRes> _l = []; // 运营商悬赏帖标准

  @override
  void initState() {
    _future = _fetch();
    super.initState();
  }

  _fetch() async {
    try {
      var res = await ApiBo.brokerPriceLevelPrizeUserList();
      if (res != null) _l = res;
    } catch (e) {
      Debug.logError("获取运营商悬赏帖标准出现异常：$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CusAppBar(
        text: widget.barName,
        actions: <Widget>[
          FlatButton(
            onPressed: () {},
            child: CusText("发${ApiState.isFlash ? '闪断' : '悬赏'}帖", t_gray, 28),
          ),
        ],
      ),
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
        padding: EdgeInsets.symmetric(horizontal: 10),
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(vertical: 5),
            child: Text(
              "请选择您的悬赏金额",
              style: TextStyle(fontSize: 18, color: t_primary),
            ),
          ),
          Wrap(
            children: <Widget>[
              ..._l.map((e) => _priceItem(e)),
            ],
          ),
        ],
      ),
    );
  }

  /// 悬赏帖标准
  Widget _priceItem(PriceLevelRes e) {
    return InkWell(
      onTap: () {},
      child: Container(
        color: t_gray,
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        child: Text(
          "${e.price}元宝",
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}
