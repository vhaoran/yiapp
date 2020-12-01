import 'package:flutter/material.dart';
import 'package:yiapp/func/debug_log.dart';
import 'package:yiapp/func/const/const_color.dart';
import 'package:yiapp/func/adapt.dart';
import 'package:yiapp/func/cus_callback.dart';
import 'package:yiapp/complex/widgets/flutter/cus_text.dart';
import 'package:yiapp/complex/widgets/flutter/rect_field.dart';
import 'package:yiapp/model/article/article_result.dart';
import 'package:yiapp/service/api/api_article.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/10/10 18:07
// usage ：搜索文章输入框
// ------------------------------------------------------

class ArticleSearch extends StatefulWidget {
  final TextEditingController searchCtrl; // 搜索输入框
  final Map data; // 搜索用到的数据
  final String type; // 文章类型名称
  FnBool fnHide; // 是否隐藏已加载出来的文章
  FnArticles fnArticles;

  ArticleSearch({
    this.searchCtrl,
    this.data,
    this.type,
    this.fnHide,
    this.fnArticles,
    Key key,
  }) : super(key: key);

  @override
  _ArticleSearchState createState() => _ArticleSearchState();
}

class _ArticleSearchState extends State<ArticleSearch> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 34, bottom: 10, left: 10, right: 10),
      child: Row(
        children: <Widget>[
          InkWell(
            onTap: () => Navigator.pop(context),
            child: Icon(Icons.arrow_back_ios, color: t_gray, size: 22),
          ),
          _searchInput(), // 搜索输入框
          InkWell(
            child: CusText("搜索", t_yi, 30),
            onTap: _doSearch,
          ),
        ],
      ),
    );
  }

  /// 搜索文章
  void _doSearch() async {
    // 有输入，再搜索
    if (widget.searchCtrl.text.isNotEmpty) {
      try {
        List<ArticleResult> res = await ApiArticle.articleSearch(widget.data);
        if (res != null) {
          if (widget.fnArticles != null) {
            widget.fnArticles(res);
          }
        }
      } catch (e) {
        Debug.logError("根据关键词搜索文章出现异常：$e");
      }
    }
  }

  /// 搜索输入框
  Widget _searchInput() {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: Adapt.px(15)),
        child: CusRectField(
          controller: widget.searchCtrl,
          hintText: "搜索${widget.type}类型的文章",
          prefixIcon: Icon(Icons.search, color: t_gray),
          borderRadius: 15,
          hideBorder: true,
          isClear: true,
          autofocus: false,
          onChanged: () {
            if (widget.fnHide != null) {
              widget.fnHide(widget.searchCtrl.text.isNotEmpty);
            }
          },
        ),
      ),
    );
  }
}
