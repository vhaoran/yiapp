import 'package:flutter/material.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/model/liuyaos/liuyao_result.dart';
import 'package:yiapp/model/orders/liuyao_content.dart';
import 'package:yiapp/service/api/api_yi.dart';
import 'package:yiapp/ui/fortune/daily_fortune/liu_yao/liuyao_symbol_res.dart';
import 'package:yiapp/util/screen_util.dart';
import 'package:yiapp/widget/post_com/liuyao_com_header.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2021/1/27 上午9:25
// usage ：六爻通用详情，含六爻头部和卦象
// ------------------------------------------------------

class LiuYaoComDetail extends StatefulWidget {
  final LiuYaoContent liuYaoContent;

  LiuYaoComDetail({this.liuYaoContent, Key key}) : super(key: key);

  @override
  _LiuYaoComDetailState createState() => _LiuYaoComDetailState();
}

class _LiuYaoComDetailState extends State<LiuYaoComDetail> {
  var _future;
  LiuYaoResult _liuYaoRes = LiuYaoResult();
  List<int> _codes = [];

  @override
  void initState() {
    List<String> codes = widget.liuYaoContent.yao_code.split('').toList();
    codes.forEach((e) => _codes.add(int.parse(e)));
    _future = _fetchLiuYao();
    super.initState();
  }

  _fetchLiuYao() async {
    try {
      var m = widget.liuYaoContent.toJson();
      var res = await ApiYi.liuYaoQiGua(m);
      if (res != null) {
        _liuYaoRes = res;
      }
    } catch (e) {
      Log.error("获取六爻起卦出现异常：$e");
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
            // 把 LiuYaoComHeader 和详情放到一起，可以少请求一次数据
            LiuYaoComHeader(
              liuYaoRes: _liuYaoRes,
              liuYaoContent: widget.liuYaoContent,
            ),
            Divider(height: 0, thickness: 0.2, color: t_gray),
            SizedBox(height: S.h(5)),
            LiuYaoSymRes(
              res: _liuYaoRes,
              codes: _codes.reversed.toList(),
            ),
            Divider(height: 0, thickness: 0.2, color: t_gray),
            SizedBox(height: S.h(5)),
          ],
        );
      },
    );
  }
}
