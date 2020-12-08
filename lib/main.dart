import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yiapp/ui/provider/cus_provider.dart';
import 'ui/hongyun_app.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/12/8 上午10:40
// usage ：鸿运来程序入口
// ------------------------------------------------------

void main() {
  runApp(
    MultiProvider(
      providers: CusProvider.providers,
      child: HongYunApp(),
    ),
  );
}
