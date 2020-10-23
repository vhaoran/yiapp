import 'package:flutter/material.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/widgets/flutter/cus_appbar.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/10/23 19:06
// usage ：添加资金账号
// ------------------------------------------------------

class AddFundAccount extends StatefulWidget {
  AddFundAccount({Key key}) : super(key: key);

  @override
  _AddFundAccountState createState() => _AddFundAccountState();
}

class _AddFundAccountState extends State<AddFundAccount> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CusAppBar(text: "添加资金账号"),
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
