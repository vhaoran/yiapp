import 'package:flutter/material.dart';
import 'package:yiapp/func/debug_log.dart';
import 'package:yiapp/func/const/const_color.dart';
import 'package:yiapp/func/adapt.dart';
import 'package:yiapp/func/cus_route.dart';
import 'package:yiapp/func/bool_utils.dart';
import 'package:yiapp/complex/widgets/cus_complex.dart';
import 'package:yiapp/complex/widgets/flutter/cus_appbar.dart';
import 'package:yiapp/complex/widgets/gather/net_photoview.dart';
import 'package:yiapp/complex/widgets/small/cus_bg_wall.dart';
import 'package:yiapp/model/article/article_content.dart';
import 'package:yiapp/model/article/article_result.dart';
import 'package:yiapp/service/api/api_article.dart';
import 'package:yiapp/service/api/api_base.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/10/10 16:08
// usage ：单篇文章详情
// ------------------------------------------------------

class ArticlePage extends StatefulWidget {
  final String article_id;

  ArticlePage({this.article_id, Key key}) : super(key: key);

  @override
  _ArticlePageState createState() => _ArticlePageState();
}

class _ArticlePageState extends State<ArticlePage> {
  var _future;
  ArticleResult _article = ArticleResult(); // 当前文章详情
  List _images = []; // 所有的图片

  @override
  void initState() {
    _future = _fetch();
    super.initState();
  }

  _fetch() async {
    try {
      var res = await ApiArticle.articleGet(widget.article_id);
      Debug.log("当篇文章详情:${res.toJson()}");
      if (res != null) _article = res;
    } catch (e) {
      Debug.logError("根据id获取文章出现异常：$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _future,
      builder: (context, snap) {
        if (!snapDone(snap)) {
          return Center(child: CircularProgressIndicator());
        }
        return Scaffold(
          appBar: CusAppBar(
            backGroundColor: primary,
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.more_horiz, color: t_gray, size: Adapt.px(40)),
                onPressed: () {},
              ),
            ],
          ),
          body: _lv(),
          backgroundColor: primary,
        );
      },
    );
  }

  Widget _lv() {
    return ScrollConfiguration(
      behavior: CusBehavior(),
      child: ListView(
        padding: EdgeInsets.symmetric(
            horizontal: Adapt.px(30), vertical: Adapt.px(20)),
        physics: BouncingScrollPhysics(),
        children: <Widget>[
          Text(
            _article.title, // 文章标题
            style: TextStyle(color: t_gray, fontSize: Adapt.px(32)),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          // 文章内容
          ..._article.content.map((e) {
            switch (e.type) {
              case 0: // 文字
                return Padding(
                  padding: EdgeInsets.only(top: Adapt.px(32)),
                  child: Text(
                    e.content,
                    style: TextStyle(color: t_gray, fontSize: Adapt.px(28)),
                  ),
                );
                break;
              case 1: // 图片
                return _buildImage(e);
                break;
              default:
                Debug.logError("出现了未知的文章内容类别:${e.type}");
                return SizedBox.shrink();
                break;
            }
          }),
        ],
      ),
    );
  }

  /// 显示图片
  Widget _buildImage(ArticleContent article) {
    if (article.content.contains(ApiBase.host)) {
      _images.add(article.toJson());
    }
    return Container(
      padding: EdgeInsets.only(top: 15),
      height: 200,
      child: InkWell(
        onTap: () {
          var index = _images
              .map((e) => e['content'])
              .toList()
              .indexOf(article.content);
          Debug.log("共${_images.length}张图片,当前选中的第${index + 1}张");
          CusRoute.push(
            context,
            NetPhotoView(imageList: _images, index: index, path: "content"),
          );
        },
        child: BackgroundWall(
          url: article.content,
          boxFit: BoxFit.contain,
        ),
      ),
    );
  }
}
