import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/10/13 17:31
// usage ：自定义加载页面
// ------------------------------------------------------

/// 自定义指示器类型
enum CusIndicator {
  spinKitCircle,
}

class CusLoading {
  final CusIndicator indicator;

  CusLoading(
    BuildContext context, {
    this.indicator: CusIndicator.spinKitCircle,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _indicator(indicator),
    );
  }

  Widget _indicator(CusIndicator indicator) {
    switch (indicator) {
      case CusIndicator.spinKitCircle:
        return SpinKitFadingCircle(
          itemBuilder: (context, index) {
            return KitCircle();
          },
        );
      default:
        break;
    }
  }
}

/// SpinKitCircle 类型的指示器
class KitCircle extends StatelessWidget {
  KitCircle({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency, // 创建透明层
      child: Center(
        child: Container(
          width: 150,
          height: 150,
          color: Colors.white,
          child: SpinKitCircle(color: Colors.white, size: 50),
        ),
      ),
    );
  }
}
