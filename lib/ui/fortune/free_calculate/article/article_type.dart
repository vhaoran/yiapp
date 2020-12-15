import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/widget/refresh_hf.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/util/adapt.dart';
import 'package:yiapp/widget/flutter/cus_text.dart';
import 'package:yiapp/model/article/article_result.dart';
import 'package:yiapp/model/article/article_type.dart';
import 'package:yiapp/model/article/article_type_res.dart';
import 'package:yiapp/service/api/api_article.dart';
import 'package:yiapp/ui/fortune/free_calculate/article/article_cover.dart';
import 'package:yiapp/ui/fortune/free_calculate/article/article_search.dart';
import 'package:yiapp/ui/fortune/free_calculate/article/article_search_res.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/10/10 11:56
// usage ：显示某一文章类别的数据
// detail: 目前只有 1 四柱、2 六爻、3 星座、4 血型、5 其他
// ------------------------------------------------------

class ArticleTypePage extends StatefulWidget {
  final ArticleType article;

  ArticleTypePage({this.article, Key key}) : super(key: key);

  @override
  _ArticleTypePageState createState() => _ArticleTypePageState();
}

class _ArticleTypePageState extends State<ArticleTypePage> {
  var _future;
  int _pageNo = 0;
  final int _count = 20; // 默认每页查询 20 篇
  bool _loadAll = false; // 是否加载完毕
  bool _hide = false; // 搜索时是否隐藏已加载文章
  var _refreshCtrl = EasyRefreshController();
  List<ArticleTypeRes> _allArticles = []; // 当前类别所有文章的列表
  List<ArticleTypeRes> _l = []; // 已加载当前类别文章的列表
  List<ArticleResult> _searchRes = []; // 搜索文章的结果
  var _searchCtrl = TextEditingController(); // 搜索输入框

  @override
  void initState() {
    _future = _fetch();
    super.initState();
  }

  /// 获取当前类别文章的全部数据
  _fetch() async {
    try {
      var res = await ApiArticle.articleGetByCate(widget.article.id);
      if (res != null) {
        _allArticles = res;
        if (_l.isEmpty) _fetchRemain();
      }
    } catch (e) {
      Log.error("文章分类查询出现异常：$e");
    }
  }

  /// 模拟分页添加数据
  void _fetchRemain() async {
    if (_pageNo * _count > _allArticles.length) {
      setState(() => _loadAll = true);
      return;
    }
    _pageNo++;
    _l = _allArticles.take(_pageNo * _count).toList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return Center(child: CircularProgressIndicator());
          }
          if (_allArticles.isEmpty) {
            return Center(
              child: CusText("${widget.article.name}分类暂时没有文章", t_gray, 32),
            );
          }
          return _lv();
        },
      ),
      backgroundColor: primary,
    );
  }

  Widget _lv() {
    return Column(
      children: <Widget>[
        // 搜索文章组件
        ArticleSearch(
          searchCtrl: _searchCtrl,
          data: {
            "cate_id": widget.article.id,
            "key_words": _searchCtrl.text.trim(),
            "size": 20, // 默认先显示10条
          },
          type: widget.article.name,
          fnHide: (val) => setState(() {
            _hide = val;
            if (!_hide && _searchRes != null) {
              _searchRes = [];
            }
          }),
          fnArticles: (val) => setState(() => _searchRes = val),
        ),
        if (_hide)
          ArticleSearchRes(res: _searchRes), // 文章封面内容
        if (!_hide)
          _showArticles(), // 加载文章
      ],
    );
  }

  /// 加载文章
  Widget _showArticles() {
    return Expanded(
      child: EasyRefresh(
        header: CusHeader(),
        footer: CusFooter(),
        onRefresh: () async {
          await _refresh();
        },
        onLoad: _loadAll
            ? () async {
                await _refreshCtrl.finishLoad(noMore: _loadAll);
              }
            : () async {
                await Future.delayed(Duration(milliseconds: 200)).then(
                  (value) => _fetchRemain(),
                );
              },
        child: ListView(
          children: <Widget>[
            SizedBox(height: Adapt.px(20)),
            ..._l.map((e) => ArticleCover(article: e)),
          ],
        ),
      ),
    );
  }

  void _refresh() async {
    _l.clear();
    _allArticles.clear();
    _pageNo = 0;
    _loadAll = false;
    await _refreshCtrl.finishLoad(noMore: _loadAll);
    await _fetch();
    setState(() {});
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    _refreshCtrl.dispose();
    super.dispose();
  }
}
