import 'package:flutter_test/flutter_test.dart';
import 'package:yiapp/func/debug_log.dart';
import 'package:yiapp/func/const/const_string.dart';
import 'package:yiapp/model/article/article_result.dart';
import 'package:yiapp/model/article/article_type.dart';
import 'package:yiapp/model/article/article_type_res.dart';
import 'package:yiapp/service/api/api_article.dart';
import 'package:yiapp/service/api/api_base.dart';

void main() {
  /// 获取文章类别
  test("获取文章类别", () async {
    ApiBase.jwt = jwt_134;
    try {
      List<ArticleType> res = await ApiArticle.articleCateList();
      if (res != null) {
        res.forEach((e) => Debug.log("类别:${e.toJson()}"));
      }
    } catch (e) {
      Debug.logError("测试---获取文章类别出现异常：$e");
    }
  });

  /// 查询文章
  test("查询文章", () async {
    ApiBase.jwt = jwt_134;
    var m = {
      "cate_id": 1,
      "key_words": "人体器官信息定位表",
      "size": 1,
    };
    try {
      List<ArticleResult> res = await ApiArticle.articleSearch(m);
      if (res != null) {
        res.forEach((e) => Debug.log("文章数据:${e.toJson()}"));
      }
    } catch (e) {
      Debug.logError("测试---查询某一类文章出现异常：$e");
    }
  });

  /// 文章分类查询
  test("文章分类查询", () async {
    ApiBase.jwt = jwt_134;
    try {
      List<ArticleTypeRes> res = await ApiArticle.articleGetByCate(1);
      if (res != null) {
        res.forEach((e) => Debug.log("分类文章数据:${e.toJson()}"));
      }
    } catch (e) {
      Debug.logError("测试---文章分类查询出现异常：$e");
    }
  });

  /// 根据id获取文章详情
  test("根据id获取文章详情", () async {
    ApiBase.jwt = jwt_134;
    String article_id = "DTn9a3QBgZ4HPoMn5kjG";
    try {
      ArticleResult res = await ApiArticle.articleGet(article_id);
      if (res != null) {
        Debug.log("当前文章详情:${res.toJson()}");
      }
    } catch (e) {
      Debug.logError("测试---根据id获取文章详情出现异常：$e");
    }
  });
}
