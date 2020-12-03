import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/util/screen_util.dart';
import 'luck_list.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/12/1 下午6:14
// usage ：【每日运势】- 轮播图
// ------------------------------------------------------

class LuckLoops extends StatelessWidget {
  LuckLoops({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: S.h(180),
      color: primary,
      child: Swiper(
        itemCount: LuckList.loops.length,
        itemBuilder: (context, index) {
          return Image.asset(
            "assets/images/loop/${LuckList.loops[index]}",
            fit: BoxFit.fill,
          );
        },
        onTap: (index) {
          Log.info("当前点的第${index + 1}张轮播图片");
        },
        autoplay: false, // 自动翻页
        pagination: SwiperPagination(
          builder: DotSwiperPaginationBuilder(
            color: Colors.white,
            activeColor: Colors.blue,
            size: S.w(10),
            activeSize: S.w(10),
          ),
        ), // 分页指示
      ),
    );
  }
}
