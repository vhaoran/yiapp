import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/widget/refresh_hf.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/func/snap_done.dart';
import 'package:yiapp/widget/cus_complex.dart';
import 'package:yiapp/widget/flutter/cus_text.dart';
import 'package:yiapp/model/bbs/bbs-vie.dart';
import 'package:yiapp/model/pagebean.dart';
import 'package:yiapp/service/api/api-bbs-vie.dart';
import 'package:yiapp/ui/question/flash_post/flash_cover.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/9/28 10:35
// usage ：闪断帖主页面
// ------------------------------------------------------

class FlashPostPage extends StatefulWidget {
  FlashPostPage({Key key}) : super(key: key);

  @override
  _FlashPostPageState createState() => _FlashPostPageState();
}

class _FlashPostPageState extends State<FlashPostPage>
    with AutomaticKeepAliveClientMixin {
  var _future;
  int _page_no = 0;
  int _rows_count = 0;
  final int _rows_per_page = 10; // 默认每页查询个数
  List<BBSVie> _l = []; // 闪断帖列表

  @override
  void initState() {
    _future = _fetch();
    super.initState();
  }

  /// 分页查询闪断帖
  _fetch() async {
    if (_page_no * _rows_per_page > _rows_count) return;
    _page_no++;
    var m = {
      "page_no": _page_no,
      "rows_per_page": _rows_per_page,
      "where": {
        "stat": {
          "\$in": [1, 2] // 1 已支付 和 2 已打赏
        }
      },
      "sort": {"create_date": -1},
    };
    try {
      PageBean pb = await ApiBBSVie.bbsViePage(m);
      if (_rows_count == 0) _rows_count = pb.rowsCount ?? 0;
      Log.info("总的闪断帖个数：$_rows_count");
      var l = pb.data.map((e) => e as BBSVie).toList();
      l.forEach((src) {
        var dst = _l.firstWhere((e) => src.id == e.id, orElse: () => null);
        if (dst == null) _l.add(src);
      });
      Log.info("当前已查询多少条闪断帖：${_l.length}");
    } catch (e) {
      Log.error("分页查询闪断帖出现异常：$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: CusBehavior(),
      child: _buildFb(),
    );
  }

  Widget _buildFb() {
    return FutureBuilder(
      future: _future,
      builder: (context, snap) {
        if (!snapDone(snap)) {
          return Center(child: CircularProgressIndicator());
        }
        return EasyRefresh(
          header: CusHeader(),
          footer: CusFooter(),
          child: ListView(
            children: <Widget>[
              if (_l.isEmpty)
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(top: 200),
                  child: CusText("暂未有人发帖", t_gray, 30),
                ),
              ..._l.map((e) => FlashCover(data: e)),
            ],
          ),
          onLoad: () async {
            await _refresh();
          },
          onRefresh: () async {
            _page_no = _rows_count = 0;
            _l.clear();
            _refresh();
          },
        );
      },
    );
  }

  void _refresh() async {
    await _fetch();
    setState(() {});
  }

  @override
  bool get wantKeepAlive => true;
}
