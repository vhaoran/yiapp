import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:yiapp/func/const/const_agreement.dart';
import 'package:yiapp/complex/widgets/cus_complex.dart';
import 'package:yiapp/complex/widgets/flutter/cus_appbar.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/11/17 11:47
// usage ：用户服务协议和隐私政策
// ------------------------------------------------------

class AgreementPage extends StatelessWidget {
  AgreementPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CusAppBar(text: "用户服务协议和隐私政策"),
      body: ScrollConfiguration(
        behavior: CusBehavior(),
        child: _lv(),
      ),
      backgroundColor: Colors.black12,
    );
  }

  Widget _lv() {
    return ListView(
      padding: EdgeInsets.only(bottom: 20),
      children: <Widget>[
        Html(
          data: agreeHtml,
          style: {"html": Style(fontSize: FontSize(16))},
        ),
      ],
    );
  }
}
