import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/widgets/flutter/cus_appbar.dart';
import 'package:yiapp/model/bbs/bbs-Prize.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/9/21 10:54
// usage ：封装的单个悬赏帖内容组件
// ------------------------------------------------------

class RewardContentPage extends StatefulWidget {
  final BBSPrize data;

  RewardContentPage({this.data, Key key}) : super(key: key);

  @override
  _RewardContentPageState createState() => _RewardContentPageState();
}

class _RewardContentPageState extends State<RewardContentPage> {
  BBSPrize _data; // 悬赏帖详情

  @override
  void initState() {
    _data = widget.data;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CusAppBar(text: "问题详情"),
      body: _lv(),
      backgroundColor: primary,
    );
  }

  Widget _lv() {
    return ListView(
      children: <Widget>[],
    );
  }
}
