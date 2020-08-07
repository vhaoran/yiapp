import 'package:flutter/material.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/8/7 20:02
// usage ：单个bottom选项
// ------------------------------------------------------

class CusSingleBar extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const CusSingleBar({
    this.title: "暂无",
    this.icon: Icons.broken_image,
    this.onTap,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(icon ?? Icons.broken_image, size: 20),
            Text(title ?? "选项")
          ],
        ),
      ),
    );
  }
}
