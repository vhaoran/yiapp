import 'package:flutter/material.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/model/dicts/master-info.dart';
import 'package:yiapp/util/screen_util.dart';
import 'package:yiapp/widget/cus_complex.dart';
import 'package:yiapp/widget/master/master_rate.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/12/24 上午11:43
// usage ：查看大师主页（用户、大师共用此页面）
// ------------------------------------------------------

class MasterHome extends StatefulWidget {
  final MasterInfo m;

  MasterHome({this.m, Key key}) : super(key: key);

  @override
  _MasterHomeState createState() => _MasterHomeState();
}

class _MasterHomeState extends State<MasterHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _lv(),
      backgroundColor: primary,
    );
  }

  Widget _lv() {
    return ScrollConfiguration(
      behavior: CusBehavior(),
      child: ListView(
        children: <Widget>[
          Text(
            "${widget.m.brief}",
            style: TextStyle(color: t_gray, fontSize: S.sp(16)),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: S.h(5)),
          // 大师好评差评率
          MasterRate(
            titles: ["好评率", "中评率", "差评率"],
            subtitles: [
              "${widget.m.best_rate}",
              "${widget.m.mid_rate}",
              "${widget.m.bad_rate}"
            ],
          ),
        ],
      ),
    );
  }
}
