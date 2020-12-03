import 'package:flutter/material.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/const/con_string.dart';
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
        _title(text: "付费测算"),
        _iconView(LuckList.pay, context),
        _title(text: "免费测算"),
        _iconView(LuckList.free, context),
      ],
    );
  }

  /// 算命功能区分类
  Widget _iconView(List<Map> l, BuildContext context) {
    return GridView.count(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      mainAxisSpacing: S.w(5),
      crossAxisCount: 5,
      children: <Widget>[
        ...l.map((e) => _iconItem(context, LuckIcon.fromJson(e))),
      ],
    );
  }

  /// 单个测算对象
  Widget _iconItem(BuildContext context, LuckIcon e) {
    return InkWell(
      onTap: () {
        CusRoute.pushNamed(context, e.route, arguments: e.text);
      },
      child: Column(
        children: <Widget>[
          // 裁剪图标为圆形
          ClipOval(
            child: Container(
              height: S.w(45),
              width: S.w(45),
              color: Color(e.color),
              child: Icon(
                IconData(e.icon, fontFamily: ali_font),
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
}
