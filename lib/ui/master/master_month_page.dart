import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/model/complex/yi_date_time.dart';
import 'package:yiapp/model/pagebean.dart';
import 'package:yiapp/model/pays/master_business_month.dart';
import 'package:yiapp/service/api/api-account.dart';
import 'package:yiapp/service/api/api_base.dart';
import 'package:yiapp/util/screen_util.dart';
import 'package:yiapp/widget/cus_complex.dart';
import 'package:yiapp/widget/cus_time_picker/picker_mode.dart';
import 'package:yiapp/widget/cus_time_picker/time_picker.dart';
import 'package:yiapp/widget/flutter/cus_appbar.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2021/1/7 下午2:59
// usage ：大师月度对账单
// ------------------------------------------------------

class MasterMonthPage extends StatefulWidget {
  MasterMonthPage({Key key}) : super(key: key);

  @override
  _MasterMonthPageState createState() => _MasterMonthPageState();
}

class _MasterMonthPageState extends State<MasterMonthPage> {
  var _future;
  MasterMonthRes _res; //
  YiDateTime _time; // 当前选择的日期

  @override
  void initState() {
    _time = YiDateTime(year: DateTime.now().year, month: DateTime.now().month);
    _future = _fetch();
    super.initState();
  }

  /// 分页查询大师月度账单
  _fetch() async {
    var m = {
      "page_no": 1,
      "rows_per_page": 1,
      "where": {
        "uid": 12, // 目前是12有数据
        "year": _time.year,
        "month": _time.month,
      },
    };
    try {
      PageBean pb = await ApiAccount.businessMasterMonthPage(m);
      if (pb != null) {
        var l = pb.data.map((e) => e as MasterMonthRes).toList();
        if (l != null && l.isNotEmpty) _res = l.first;
        setState(() {});
      }
    } catch (e) {
      Log.error("分页查询大师月度账单出现异常：$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CusAppBar(text: "月度账单"),
      body: _buildFb(),
      backgroundColor: primary,
    );
  }

  Widget _buildFb() {
    return FutureBuilder(
      future: _future,
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return Center(child: CircularProgressIndicator());
        }
        return ScrollConfiguration(
          behavior: CusBehavior(),
          child: _lv(),
        );
      },
    );
  }

  Widget _lv() {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: S.w(10)),
      children: <Widget>[
        SizedBox(height: S.h(10)),
        _chTime(),
        if (_res == null)
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(top: 200),
            child: Text(
              "当月暂无账单",
              style: TextStyle(color: t_gray, fontSize: S.sp(15)),
            ),
          ),
      ],
    );
  }

  /// 更换时间
  Widget _chTime() {
    return InkWell(
      onTap: () {
        TimePicker(
          context,
          pickMode: PickerMode.year_month,
          onConfirm: (val) async {
            setState(() => _time = val);
            await _fetch();
          },
        );
      },
      child: Row(
        children: [
          Text(
            "${_time.year}年${_time.month}月",
            style: TextStyle(color: t_gray, fontSize: S.sp(16)),
          ),
          Icon(FontAwesomeIcons.caretDown, color: t_gray),
        ],
      ),
    );
  }
}
