import 'dart:io';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:yiapp/complex/class/yi_date_time.dart';
import 'package:yiapp/model/article/article_result.dart';
import 'package:yiapp/model/dicts/ProductCate.dart';
import 'package:yiapp/model/dicts/product.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/8/7 10:22
// usage ：自定义回调函数
// ------------------------------------------------------

// 普通类型
typedef FnInt = void Function(int uid);
typedef FnBool = void Function(bool value);
typedef FnString = void Function(String value);
typedef FnDynamic = void Function(dynamic value);

// 时间回调
typedef FnDate = void Function(DateTime date);
typedef FnYiDate = void Function(YiDateTime date);

// 文件回调
typedef FnFile = void Function(File file);
typedef FnFiles = void Function(List<File>);
typedef FnAssets = void Function(List<Asset>);

// yiapp 中指定类型的回调
typedef FnCategory = Function(Category category); // 商品
typedef FnColorPrice = void Function(List<ProductColor>); // 商品颜色和价格的回调
typedef FnArticles = void Function(List<ArticleResult>); // 文章
