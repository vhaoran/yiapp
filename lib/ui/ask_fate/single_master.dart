import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/widgets/cus_article.dart';
import 'package:yiapp/complex/widgets/cus_behavior.dart';
import 'package:yiapp/complex/widgets/cus_number_data.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/8/14 17:17
// usage ：大师榜单
// ------------------------------------------------------

class MasterList extends StatefulWidget {
  final int l; // 临时设置

  MasterList({this.l, Key key}) : super(key: key);

  @override
  _MasterListState createState() => _MasterListState();
}

class _MasterListState extends State<MasterList>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    print(">>>进来了");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      // 之所以一个 ListView 也另外定义一个Dart文件里，是因为 TabBarView 组件默认同父组件等宽高，
      // 如果指定高度，当前页面不能显示多个数据
      body: ScrollConfiguration(
        behavior: CusBehavior(),
        child: ListView(
          children: List.generate(widget.l, (index) {
            Widget midTitle = index.isEven
                ? Text("在线", style: TextStyle(color: t_green))
                : Text("离线", style: TextStyle(color: t_svip));
            String img = index.isEven
                ? "assets/images/master.png"
                : "assets/images/girl_master.png";
            String subtitle;
            if (index.isEven) subtitle = "再大的愿景都是从小处着手，越大的图越要从小处搞，越小的东西越要从大处着眼";
            return Column(
              children: <Widget>[
                CusArticle(
                  title: "蓝岩天",
                  titleColor: Colors.white,
                  imgSize: 100,
                  subColor: t_gray,
                  btnName: "立即约聊",
                  spaceHeight: 0,
                  midTitle: midTitle,
                  subtitle: subtitle,
                  defaultImage: img,
                ),
                CusNumData(), // 详情数据
              ],
            );
          }),
        ),
      ),
      backgroundColor: primary,
    );
  }

  @override
  bool get wantKeepAlive => true;
}
