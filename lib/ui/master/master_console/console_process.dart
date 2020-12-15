import 'package:flutter/material.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/util/screen_util.dart';
import 'package:yiapp/widget/cus_complex.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/12/15 上午10:43
// usage ：处理中的订单
// ------------------------------------------------------

class ConsoleProcess extends StatefulWidget {
  final bool isVie; // 是否闪断帖

  ConsoleProcess({this.isVie, Key key}) : super(key: key);

  @override
  _ConsoleProcessState createState() => _ConsoleProcessState();
}

class _ConsoleProcessState extends State<ConsoleProcess>
    with AutomaticKeepAliveClientMixin {
  var _future;

  @override
  void initState() {
    _future = _fetch();
    super.initState();
  }

  /// 获取正在处理中的悬赏帖
  _fetch() async {
    await Future.delayed(Duration(milliseconds: 100));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ScrollConfiguration(
      behavior: CusBehavior(),
      child: FutureBuilder(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return Center(child: CircularProgressIndicator());
          }
          return _lv();
        },
      ),
    );
  }

  Widget _lv() {
    return ListView(
      children: <Widget>[
        _noData(),
      ],
    );
  }

  /// 显示没有帖子
  Widget _noData() {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(top: S.screenH() / 4),
      child: Text(
        "暂无订单",
        style: TextStyle(color: t_gray, fontSize: S.sp(15)),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
