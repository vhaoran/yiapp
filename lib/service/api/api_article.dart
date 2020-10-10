import 'package:yiapp/complex/const/const_string.dart';
import 'package:yiapp/model/article/article_result.dart';
import 'package:yiapp/model/article/article_type.dart';
import 'package:yiapp/model/article/article_type_res.dart';
import 'api_base.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/10/10 09:39
// usage ：文章路由
// ------------------------------------------------------

class ApiArticle {
  /// 获取文章类别列表
  static Future<List<ArticleType>> articleCateList() async {
    var url = w_yi_cms + "ArticleCateList";
    var data = Map<String, dynamic>();
    return await ApiBase.postList(
        url, data, (l) => l.map((x) => ArticleType.fromJson(x)).toList());
  }

  /// 查询文章
  static Future<List<ArticleResult>> articleSearch(dynamic data) async {
    var url = w_yi_cms + "ArticleSearch";
    return await ApiBase.postList(
        url, data, (l) => l.map((x) => ArticleResult.fromJson(x)).toList());
  }

  /// 文章分类查询
  static Future<List<ArticleTypeRes>> articleGetByCate(int cate_id) async {
    var url = w_yi_cms + "ArticleGetByCate";
    var data = {"cate_id": cate_id};
    return await ApiBase.postList(
        url, data, (l) => l.map((x) => ArticleTypeRes.fromJson(x)).toList());
  }

  /// 根据id获取文章
  static Future<ArticleResult> articleGet(String article_id) async {
    var url = w_yi_cms + "ArticleGet";
    var data = {"article_id": article_id};
    return await ApiBase.postObj(url, data, (m) => ArticleResult.fromJson(m));
  }
}
