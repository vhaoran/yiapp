import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/tools/cus_routes.dart';
import 'package:yiapp/complex/widgets/flutter/cus_appbar.dart';
import 'package:yiapp/complex/widgets/gather/cus_swiper_pagination.dart';
import 'package:yiapp/complex/widgets/gather/net_photoview.dart';
import 'package:yiapp/complex/widgets/small/cus_bg_wall.dart';
import 'package:yiapp/model/dicts/product.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/10/12 16:23
// usage ：商品详情轮播图
// ------------------------------------------------------

class ProductLoops extends StatefulWidget {
  final Product product;

  ProductLoops({this.product, Key key}) : super(key: key);

  @override
  _ProductLoopsState createState() => _ProductLoopsState();
}

class _ProductLoopsState extends State<ProductLoops> {
  List<ProductImage> _images = [];

  @override
  void initState() {
    _images = widget.product.images;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        SizedBox(height: 260, child: _loops()),
      ],
    );
  }

  Widget _loops() {
    return Swiper(
      key: UniqueKey(),
      autoplay: true,
      itemCount: _images.length,
      itemBuilder: (context, i) {
        return BackgroundWall(
          url: _images[i].path,
          boxFit: BoxFit.cover,
          onTap: () {
            var l = _images.map((e) => e.toJson()).toList();
            CusRoutes.push(
              context,
              NetPhotoView(imageList: l, index: i),
            );
          },
        );
      },
      pagination: CusSwiperPagination(),
    );
  }
}
