import 'package:flutter/material.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/tools/adapt.dart';
import 'package:yiapp/complex/tools/cus_routes.dart';
import 'package:yiapp/model/article/article_type_res.dart';
import 'package:yiapp/ui/fortune/free_calculate/article/article_page.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/10/10 16:25
// usage ：文章封面
// ------------------------------------------------------

class ArticleCover extends StatefulWidget {
  final ArticleTypeRes article;

  ArticleCover({this.article, Key key}) : super(key: key);

  @override
  _ArticleCoverState createState() => _ArticleCoverState();
}

class _ArticleCoverState extends State<ArticleCover> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: t_gray,
      child: ListTile(
        onTap: () => CusRoutes.push(
          context, // 根据文章id跳转到详情页
          ArticlePage(article_id: widget.article.article_id),
        ),
        title: Container(
          padding: EdgeInsets.symmetric(vertical: Adapt.px(10)),
          height: Adapt.px(120),
          child: Text(
            "${widget.article.title}", // 文章标题
            style: TextStyle(fontSize: Adapt.px(32)),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        subtitle: _buildSubtitle(), // 文章时间和访问量
      ),
    );
  }

  /// 文章时间和访问量
  Widget _buildSubtitle() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: Adapt.px(10)),
      child: Row(
        children: <Widget>[
          Text(
            "${widget.article.created_at}", // 文章时间
            style: TextStyle(fontSize: Adapt.px(30)),
          ),
          Padding(
            padding: EdgeInsets.only(left: Adapt.px(100), right: Adapt.px(15)),
            child: Icon(
              Icons.remove_red_eye, // 访问量图标
              size: Adapt.px(35),
              color: Colors.grey,
            ),
          ),
          Text(
            "${widget.article.visit_count}", // 文章访问量
            style: TextStyle(fontSize: Adapt.px(30)),
          ),
        ],
      ),
    );
  }
}
