import 'package:flutter/material.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/tools/adapt.dart';
import 'package:yiapp/complex/tools/cus_routes.dart';
import 'package:yiapp/complex/widgets/cus_complex.dart';
import 'package:yiapp/complex/widgets/flutter/cus_text.dart';
import 'package:yiapp/model/article/article_result.dart';
import 'package:yiapp/ui/fortune/free_calculate/article/article_page.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/10/10 18:22
// usage ：搜索文章的结果
// ------------------------------------------------------

class ArticleSearchRes extends StatefulWidget {
  final List<ArticleResult> res;

  ArticleSearchRes({this.res, Key key}) : super(key: key);

  @override
  _ArticleSearchResState createState() => _ArticleSearchResState();
}

class _ArticleSearchResState extends State<ArticleSearchRes> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ScrollConfiguration(
        behavior: CusBehavior(),
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: Adapt.px(30)),
          children: <Widget>[
//          if (widget.res.isEmpty) CusText("未搜索到相关结果", t_gray, 32),
            if (widget.res != null)
              ...widget.res.map((e) => _resItem(e)),
          ],
        ),
      ),
    );
  }

  /// 单个搜索结果
  Widget _resItem(ArticleResult e) {
    return InkWell(
      onTap: () => CusRoutes.push(context, ArticlePage(article_id: e.code)),
      child: Card(
        color: t_gray,
        child: Padding(
          padding: EdgeInsets.all(Adapt.px(20)),
          child: Row(
            children: <Widget>[
              Icon(Icons.search),
              SizedBox(width: Adapt.px(30)),
              Expanded(
                child: Text(
                  e.title,
                  style: TextStyle(fontSize: Adapt.px(28)),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
