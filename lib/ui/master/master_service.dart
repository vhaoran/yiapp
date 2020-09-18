import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:yiapp/complex/class/debug_log.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/tools/cus_routes.dart';
import 'package:yiapp/complex/type/bool_utils.dart';
import 'package:yiapp/complex/widgets/flutter/cus_button.dart';
import 'package:yiapp/complex/widgets/flutter/cus_dialog.dart';
import 'package:yiapp/complex/widgets/flutter/cus_text.dart';
import 'package:yiapp/complex/widgets/flutter/cus_toast.dart';
import 'package:yiapp/complex/widgets/master/cus_service.dart';
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
      Debug.logError("获取大师项目列表出现异常：$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _future,
      builder: (context, snap) {
        if (!snapDone(snap)) {
          return Center(child: CircularProgressIndicator());
        }
        if (_l.isEmpty) {
          return Center(child: CusText("暂未添加项目", t_gray, 30));
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
                onChange: (m) =>
                    CusRoutes.push(context, AddChServicePage(res: m)).then(
                  (val) => _refresh(),
                ),
              ),
            ),
          ),
        ),
        CusRaisedBtn(
          text: "添加服务",
          minWidth: double.infinity,
          backgroundColor: fif_primary,
          pdVer: 20,
          onPressed: () => CusRoutes.push(context, AddChServicePage()).then(
            (val) => _refresh(),
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
          Debug.log("移除大师项目结果：$ok");
          if (ok) {
            CusToast.toast(context, text: "移除成功");
            _refresh();
          }
        } catch (e) {
          Debug.logError("移除大师服务项目出现异常：$e");
        }
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
