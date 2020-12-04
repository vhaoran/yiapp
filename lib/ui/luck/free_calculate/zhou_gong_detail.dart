import 'package:flutter/material.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/util/adapt.dart';
import 'package:yiapp/widget/cus_complex.dart';
import 'package:yiapp/widget/flutter/cus_appbar.dart';
import 'package:yiapp/model/complex/zhou_gong_res.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/10/26 14:30
// usage ：单条周公解梦详情页
// ------------------------------------------------------

class ZhouGongDetail extends StatefulWidget {
  final ZhouGongRes res;

  ZhouGongDetail({this.res, Key key}) : super(key: key);

  @override
  _ZhouGongDetailState createState() => _ZhouGongDetailState();
}

class _ZhouGongDetailState extends State<ZhouGongDetail> {
  List<String> _l = []; // 周公解梦内容

  @override
  void initState() {
    _l = widget.res.content;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CusAppBar(text: "${widget.res.title}好不好"),
      body: _lv(),
      backgroundColor: primary,
    );
  }

  Widget _lv() {
    return ScrollConfiguration(
      behavior: CusBehavior(),
      child: ListView(
        padding: EdgeInsets.symmetric(horizontal: 10),
        physics: BouncingScrollPhysics(),
        children: <Widget>[
          SizedBox(height: 10),
          ...List.generate(
            _l.length,
            (i) => Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: RichText(
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text: "${i + 1}.  ", // 序号
                    style: TextStyle(color: t_primary, fontSize: 16),
                  ),
                  TextSpan(
                    text: "${_l[i]}", // 内容
                    style: TextStyle(
                      color: t_gray,
                      fontSize: 16,
                      height: 1.4,
                    ),
                  ),
                ]),
              ),
            ),
          ),
          SizedBox(height: Adapt.px(40)),
        ],
      ),
    );
  }
}
