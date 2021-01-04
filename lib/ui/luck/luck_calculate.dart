import 'package:flutter/material.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/const/con_string.dart';
import 'package:yiapp/cus/cus_role.dart';
import 'package:yiapp/cus/cus_route.dart';
import 'package:yiapp/util/screen_util.dart';
import 'luck_list.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/12/3 下午2:11
// usage ：【每日运势】- 免费、付费测算
// ------------------------------------------------------

class LuckCalculate extends StatelessWidget {
  LuckCalculate({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // 大师不显示付费项目
        if (!CusRole.is_master || !CusRole.is_admin) ...[
          _title(text: "付费测算"),
          _iconView(LuckList.pay, context, true),
        ],
        _title(text: "免费测算"),
        _iconView(LuckList.free, context, false),
      ],
    );
  }

  /// 算命功能区分类
  Widget _iconView(List<Map> l, BuildContext context, bool isPay) {
    return GridView.count(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      mainAxisSpacing: S.w(5),
      crossAxisCount: 5,
      children: <Widget>[
        ...List.generate(
          l.length,
          (i) => _iconItem(context, LuckIcon.fromJson(l[i]), i, isPay),
        ),
      ],
    );
  }

  /// 单个测算对象
  Widget _iconItem(BuildContext context, LuckIcon e, int index, bool isPay) {
    return InkWell(
      onTap: () => CusRoute.pushNamed(context, e.route, arguments: e.text),
      child: Column(
        children: <Widget>[
          // 裁剪图标为圆形
          ClipOval(
            child: Container(
              height: S.w(45),
              width: S.w(45),
              color: Color(e.color),
              child: Icon(
                isPay ? _payIconData(index) : _freeIconData(index),
                size: S.w(40),
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(height: S.h(5)),
          Text(
            e.text,
            style: TextStyle(fontSize: S.sp(14), color: t_gray),
            overflow: TextOverflow.ellipsis,
          )
        ],
      ),
    );
  }

  /// 付费、免费测算标题
  Widget _title({String text}) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.all(S.w(10)),
      margin: EdgeInsets.only(bottom: S.h(10)),
      color: fif_primary,
      child: Text(
        text,
        style: TextStyle(fontSize: S.sp(16), color: t_primary),
      ),
    );
  }

  /// 付费项目显示图标，因为Release下要求IconData必须为静态的
  IconData _payIconData(int index) {
    if (index == 0) return _payIcon0;
    if (index == 1) return _payIcon1;
    if (index == 2) return _payIcon2;
    return _payIcon0;
  }

  /// 付费项目显示图标，因为Release下要求IconData必须为静态的
  IconData _freeIconData(int index) {
    if (index == 0) return _freeIcon0;
    if (index == 1) return _freeIcon1;
    if (index == 2) return _freeIcon2;
    if (index == 3) return _freeIcon3;
    if (index == 4) return _freeIcon4;
    if (index == 5) return _freeIcon5;
    if (index == 6) return _freeIcon6;
    if (index == 7) return _freeIcon7;
    if (index == 8) return _freeIcon8;
    if (index == 9) return _freeIcon9;
    if (index == 10) return _freeIcon10;
    if (index == 11) return _freeIcon11;
    if (index == 12) return _freeIcon12;
    return _freeIcon0;
  }

  // 付费项目图标
  static const IconData _payIcon0 = IconData(0xeb00, fontFamily: ali_font);
  static const IconData _payIcon1 = IconData(0xe633, fontFamily: ali_font);
  static const IconData _payIcon2 = IconData(0xe606, fontFamily: ali_font);
  // 免费项目图标
  static const IconData _freeIcon0 = IconData(0xe69e, fontFamily: ali_font);
  static const IconData _freeIcon1 = IconData(0xe6b1, fontFamily: ali_font);
  static const IconData _freeIcon2 = IconData(0xe656, fontFamily: ali_font);
  static const IconData _freeIcon3 = IconData(0xe728, fontFamily: ali_font);
  static const IconData _freeIcon4 = IconData(0xe601, fontFamily: ali_font);
  static const IconData _freeIcon5 = IconData(0xe606, fontFamily: ali_font);
  static const IconData _freeIcon6 = IconData(0xe627, fontFamily: ali_font);
  static const IconData _freeIcon7 = IconData(0xe600, fontFamily: ali_font);
  static const IconData _freeIcon8 = IconData(0xe668, fontFamily: ali_font);
  static const IconData _freeIcon9 = IconData(0xebcd, fontFamily: ali_font);
  static const IconData _freeIcon10 = IconData(0xe604, fontFamily: ali_font);
  static const IconData _freeIcon11 = IconData(0xe6b5, fontFamily: ali_font);
  static const IconData _freeIcon12 = IconData(0xe6ce, fontFamily: ali_font);
}
