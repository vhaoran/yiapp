import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/cus/cus_route.dart';
import 'package:yiapp/func/snap_done.dart';
import 'package:yiapp/util/screen_util.dart';
import 'package:yiapp/widget/cus_button.dart';
import 'package:yiapp/widget/flutter/cus_dialog.dart';
import 'package:yiapp/widget/flutter/cus_text.dart';
import 'package:yiapp/widget/flutter/cus_toast.dart';
import 'package:yiapp/widget/master/cus_service.dart';
import 'package:yiapp/model/dicts/master-cate.dart';
import 'package:yiapp/service/api/api-master.dart';
import 'package:yiapp/service/api/api_base.dart';
import 'package:yiapp/ui/master/addChServicePage.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/9/15 18:46
// usage ：大师服务页面
// ------------------------------------------------------

class MasterServicePage extends StatefulWidget {
  MasterServicePage({Key key}) : super(key: key);

  @override
  _MasterServicePageState createState() => _MasterServicePageState();
}

class _MasterServicePageState extends State<MasterServicePage>
    with AutomaticKeepAliveClientMixin {
  var _future;
  List<MasterCate> _l; // 获取大师项目列表

  @override
  void initState() {
    _future = _fetch();
    super.initState();
  }

  _fetch() async {
    try {
      var res = await ApiMaster.masterItemList(ApiBase.uid);
      if (res != null) _l = res;
    } catch (e) {
      _l = [];
      Log.error("获取大师项目列表出现异常，是否暂未添加：$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder(
      future: _future,
      builder: (context, snap) {
        if (!snapDone(snap)) {
          return Center(child: CircularProgressIndicator());
        }
        if (_l.isEmpty) {
          return InkWell(
            onTap: _doFn,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CusText("暂未添加项目，", t_gray, 30),
                CusText("现在添加?", Colors.lightBlue, 30)
              ],
            ),
          );
        }
        return _co();
      },
    );
  }

  Widget _co() {
    return Column(
      children: <Widget>[
        Expanded(
          child: ListView(
            physics: BouncingScrollPhysics(),
            children: List.generate(
              _l.length,
              (i) => CusService(
                m: _l[i],
                onRm: _doRm,
                onChange: (m) => _doFn(m: m),
              ),
            ),
          ),
        ),
        SizedBox(
          width: S.screenW(),
          child: CusRaisedButton(
            child: Text(
              "添加服务",
              style: TextStyle(color: Colors.white, fontSize: S.sp(15)),
            ),
            onPressed: _doFn,
            colors: [Colors.grey, t_yi],
          ),
        ),
      ],
    );
  }

  /// 移除服务项目
  void _doRm(MasterCate m) {
    if (m == null) return;
    CusDialog.err(
      context,
      title: "确认移除该服务项目吗 ?",
      onApproval: () async {
        try {
          bool ok = await ApiMaster.masterItemRm(m.id);
          Log.info("移除大师项目结果：$ok");
          if (ok) {
            CusToast.toast(context, text: "移除成功");
            _refresh();
          }
        } catch (e) {
          Log.error("移除大师服务项目出现异常：$e");
        }
      },
    );
  }

  /// 跳转回本页面的回调
  void _doFn({MasterCate m}) {
    CusRoute.push(context, AddChServicePage(res: m)).then((val) {
      if (val != null) _refresh();
    });
  }

  void _refresh() async {
    _l.clear();
    await _fetch();
    setState(() {});
  }

  @override
  bool get wantKeepAlive => true;
}
