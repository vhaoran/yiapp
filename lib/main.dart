import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yiapp/ui/provider/cus_provider.dart';
import 'ui/hongyun_app.dart';
import 'widget/su_toast.dart';

void main() {
  runApp(
    MultiProvider(
      providers: CusProvider.providers,
      child: SuToastProvider(
        defaults: SuToastDefaults(),
        child: HongYunApp(),
      ),
    ),
  );
}
