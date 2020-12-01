import 'package:flutter/material.dart';
import 'package:yiapp/func/debug_log.dart';
import 'package:yiapp/func/const/const_color.dart';
import 'package:yiapp/func/cus_route.dart';
import 'package:yiapp/func/bool_utils.dart';
import 'package:yiapp/complex/widgets/cus_complex.dart';
import 'package:yiapp/complex/widgets/flutter/cus_button.dart';
import 'package:yiapp/complex/widgets/flutter/cus_text.dart';
import 'package:yiapp/model/article/article_type.dart';
import 'package:yiapp/service/api/api_article.dart';
import 'package:yiapp/ui/fortune/free_calculate/article/article_type.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/10/9 19:06
// usage ：文章主入口函数
// ------------------------------------------------------

class ArticleMain extends StatefulWidget {
  ArticleMain({Key key}) : super(key: key);

  @override
  _ArticleMainState createState() => _ArticleMainState();
}

class _ArticleMainState extends State<ArticleMain> {
  var _future;
  List<ArticleType> _l = []; // 已有文章类别列表

  @override
  void initState() {
    _future = _fetch();
    super.initState();
  }

  /// 获取文章类别列表
  _fetch() async {
    try {
      var res = await ApiArticle.articleCateList();
      if (res != null) _l = res;
    } catch (e) {
      Debug.logError("获取文章类别列表出现异常：$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 30),
        children: <Widget>[
          InkWell(
            child: Container(
              alignment: Alignment.centerLeft,
              child: Icon(Icons.arrow_back_ios, color: t_gray, size: 20),
            ),
            onTap: () => Navigator.pop(context),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10, bottom: 10),
            child: Center(child: CusText("热门文章类型", t_gray, 32)),
          ),
          Wrap(
            spacing: 40,
            children: <Widget>[
              ..._l.map(
                (e) => CusRaisedBtn(
                  text: e.name,
                  textColor: Colors.black,
                  pdHor: 25,
                  pdVer: 5,
                  borderRadius: 30,
                  backgroundColor: Colors.grey,
                  onPressed: () => CusRoute.push(
                    context,
                    ArticleTypePage(article: e),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
