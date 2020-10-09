import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/tools/adapt.dart';
import 'package:yiapp/complex/widgets/flutter/cus_appbar.dart';
import 'package:yiapp/complex/widgets/flutter/cus_text.dart';
import 'package:yiapp/complex/widgets/flutter/rect_field.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/10/9 19:06
// usage ：文章主入口
// ------------------------------------------------------

class ArticleMain extends StatefulWidget {
  ArticleMain({Key key}) : super(key: key);

  @override
  _ArticleMainState createState() => _ArticleMainState();
}

class _ArticleMainState extends State<ArticleMain> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CusAppBar(
        showLeading: false,
        title: Row(
          children: <Widget>[
            Expanded(
              child: CusRectField(
                hintText: "搜索",
                prefixIcon: Icon(Icons.search, color: t_gray),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: Adapt.px(30)),
              child: InkWell(child: CusText("取消", Colors.blue, 28)),
            ),
          ],
        ),
      ),
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
