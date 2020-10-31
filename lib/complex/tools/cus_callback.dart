import 'dart:io';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:yiapp/complex/model/yi_date_time.dart';
import 'package:yiapp/model/article/article_result.dart';
import 'package:yiapp/model/complex/address_result.dart';
import 'package:yiapp/model/dicts/ProductCate.dart';
import 'package:yiapp/model/dicts/product.dart';
import 'package:yiapp/model/orders/productOrder.dart';
import 'package:yiapp/ui/chat/msg_types/msg_base.dart';

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
typedef FnMsgSend = Function(MsgBase msg);
typedef FnCategory = Function(Category category); // 商品
typedef FnColorPrices = void Function(List<ProductColor>); // 添加商品颜色和价格的回调
typedef FnArticles = void Function(List<ArticleResult>); // 文章
typedef FnColorPrice = void Function(ProductColor); // 选择商品的颜色和价格
typedef FnAddr = void Function(AddressResult); // 选择收货地址后的回调
typedef FnProOrder = void Function(ProductOrder); // 返回订单详情
