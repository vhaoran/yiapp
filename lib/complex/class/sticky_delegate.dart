import 'package:flutter/material.dart';
import 'package:yiapp/func/const/const_color.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/9/17 18:19
// usage ： 顶部 SliverAppBar 配合 TabBar 实现吸附功能
// ------------------------------------------------------

class StickyTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar child;

  StickyTabBarDelegate({@required this.child});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: primary,
      child: this.child,
    );
  }

  // 滚动的时候高度在 minExtent 和 maxExtent 范围内变化
  @override // 滚动最大值
  double get maxExtent => this.child.preferredSize.height;

  @override // 滚动最小值
  double get minExtent => this.child.preferredSize.height;

  @override // 是否需要更新
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
