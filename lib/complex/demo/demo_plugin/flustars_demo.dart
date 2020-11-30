import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/refactor_widgets/su_button.dart';
import 'package:yiapp/complex/tools/su_regexp.dart';
import 'package:yiapp/complex/widgets/flutter/cus_appbar.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/11/30 下午5:44
// usage ：依赖于Dart常用工具类库
// ------------------------------------------------------

class DemoFlustars extends StatefulWidget {
  DemoFlustars({Key key}) : super(key: key);

  @override
  _DemoFlustarsState createState() => _DemoFlustarsState();
}

class _DemoFlustarsState extends State<DemoFlustars> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CusAppBar(text: "Flustars 工具库"),
      body: _lv(),
      backgroundColor: primary,
    );
  }

  Widget _lv() {
    return ListView(
      children: <Widget>[
        SuButton(
            child: Text("RegexUtil"),
            onPressed: () {
//              LogUtil.init(isDebug: false);
              bool isMobile = SuRegExp.isMobile("16620182878");
              print(">>>isMobile:$isMobile");
            }),
      ],
    );
  }
}
