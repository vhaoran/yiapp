import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/tools/cus_routes.dart';
import 'package:yiapp/complex/widgets/cus_complex.dart';
import 'package:yiapp/complex/widgets/cus_number_data.dart';
import 'package:yiapp/complex/widgets/master/master_base_info.dart';
import 'master_homepage.dart';

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
        child: _lv(),
      ),
      backgroundColor: primary,
    );
  }

  Widget _lv() {
    return ListView(
      children: List.generate(widget.l, (index) {
        bool isEven = index.isEven;
        String title = isEven ? "蓝岩天" : "迪丽热巴";
        String subtitle = isEven
            ? "再大的愿景都是从小处着手，越大的图越要从小处搞，越小的东西越要从大处着眼再大的愿景都是从小处着手，越大的图越要从小处搞，越小的东西越要从大处着眼"
            : "中华姓名文化起源于原始社会，以人性为根，以姓氏为本，不仅体现了社会";
        String image = isEven
            ? "assets/images/master.png"
            : "assets/images/girl_master.png";
        String status = isEven ? "在线" : "离线";
        return Column(
          children: <Widget>[
            MasterBaseInfo(
              title: title,
              subtitle: subtitle,
              midTitle: status,
              midColor: isEven ? t_green : t_red,
              defaultImage: image,
              onTap: () => CusRoutes.push(
                context,
                MasterHomePage(
                  name: title,
                  signature: subtitle,
                  status: status,
                  defaultImage: image,
                ),
              ),
            ),
            CusNumData(
              titles: ["12345", "100%", "12888"],
              subtitles: ["服务人数", "好评率", "粉丝数"],
            ), // 详情数据
          ],
        );
      }),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
