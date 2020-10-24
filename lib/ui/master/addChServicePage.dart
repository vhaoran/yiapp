import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:yiapp/complex/class/debug_log.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/const/const_list.dart';
import 'package:yiapp/complex/tools/adapt.dart';
import 'package:yiapp/complex/widgets/flutter/cus_appbar.dart';
import 'package:yiapp/complex/widgets/flutter/cus_text.dart';
import 'package:yiapp/complex/widgets/flutter/cus_toast.dart';
import 'package:yiapp/complex/widgets/flutter/rect_field.dart';
import 'package:yiapp/complex/widgets/fn/fn_dialog.dart';
import 'package:yiapp/model/dicts/master-cate.dart';
import 'package:yiapp/service/api/api-master.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/9/16 11:12
// usage ：添加、修改大师服务共用页面
// ------------------------------------------------------

class AddChServicePage extends StatefulWidget {
  final MasterCate res;

  AddChServicePage({this.res, Key key}) : super(key: key);

  @override
  _AddChServicePageState createState() => _AddChServicePageState();
}

class _AddChServicePageState extends State<AddChServicePage> {
  var _priceCtrl = TextEditingController(); // 服务价格
  var _commentCtrl = TextEditingController(); // 服务介绍
  String _nameErr; // 项目名称错误信息提示
  String _commentErr; // 服务介绍错误信息提示
  String _priceErr; // 服务价格错误提示信息
  String _cate_name; // 服务项目名称
  int _cate_id = 0; // 服务项目id
  bool _isAdd = true; // 是否为添加新服务项目

  @override
  void initState() {
    _isAdd = widget.res == null ? true : false;
    _cate_name = _isAdd ? null : widget.res.yi_cate_name;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBarCtr(),
      body: ListView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: Adapt.px(50)),
        children: <Widget>[
          ..._lv(), // 输入框
        ],
      ),
      backgroundColor: primary,
    );
  }

  /// 添加服务
  void _doAddService() async {
    var m = {
      "yi_cate_id": _cate_id,
      "yi_cate_name": _cate_name,
      "comment": _commentCtrl.text.trim(),
      "price": num.parse(_priceCtrl.text),
    };
    try {
      MasterCate res = await ApiMaster.masterItemAdd(m);
      if (res != null) {
        CusToast.toast(context, text: "添加成功");
        Navigator.of(context).pop("");
      }
    } catch (e) {
      Debug.logError("添加大师服务出现异常：$e");
    }
  }

  /// 修改服务
  void _doChService() async {
    var m = {
      "id": widget.res.id,
      "M": {
        "yi_cate_id": _cate_id,
        "yi_cate_name": _cate_name,
        "comment": _commentCtrl.text.trim(),
        "price": num.parse(_priceCtrl.text),
      }
    };
    try {
      bool ok = await ApiMaster.masterItemCh(m);
      if (ok) {
        CusToast.toast(context, text: "修改成功");
        Navigator.of(context).pop("");
      }
    } catch (e) {
      Debug.logError("修改大师服务出现异常：$e");
    }
  }

  /// 输入框
  List<Widget> _lv() {
    return <Widget>[
      SizedBox(height: Adapt.px(30)),
      _tip("项目名称"),
      InkWell(
        onTap: () => FnDialog(context, l: c_service, groupValue: _cate_id,
            fnPair: (int sex, int select, String name) {
          if (select != null) _cate_id = select;
          if (name != null) _cate_name = name;
          if (_nameErr != null) _nameErr = null;
          setState(() {});
          Navigator.pop(context);
        }),
        child: CusRectField(
          enable: false,
          hintText: _cate_name,
          errorText: _nameErr,
        ),
      ),
      _tip("服务简介"),
      CusRectField(
        controller: _commentCtrl, // 服务简介
        errorText: _commentErr,
        autofocus: false,
        pdHor: 0,
        maxLines: 8,
        fromValue: _isAdd ? null : widget.res.comment,
      ),
      _tip("服务价格"),
      CusRectField(
        controller: _priceCtrl, // 服务价格输入框
        errorText: _priceErr,
        autofocus: false,
        maxLines: 1,
        onlyNumber: true,
        fromValue: _isAdd ? null : widget.res.price.toString(),
      ),
    ];
  }

  Widget _appBarCtr() {
    return CusAppBar(
      text: _isAdd ? "添加服务" : "修改服务",
      actions: <Widget>[
        FlatButton(
          child: CusText("保存", Colors.orangeAccent, 28),
          onPressed: () {
            setState(() {
              _nameErr = _cate_name == null ? "项目名称不能为空" : null;
              if (_nameErr != null) return;
              _commentErr = _commentCtrl.text.isEmpty ? "服务简介不能为空" : null;
              if (_commentErr != null) return;
              _priceErr = _priceCtrl.text.isEmpty ? "服务价格不能为空" : null;
              if (_priceCtrl != null) return;
            });
            if (_nameErr == null && _commentErr == null && _priceErr == null) {
              _isAdd ? _doAddService() : _doChService();
            }
          },
        ),
      ],
    );
  }

  Widget _tip(String tip) {
    return Padding(
      padding: EdgeInsets.only(top: Adapt.px(25), bottom: Adapt.px(10)),
      child: CusText(tip, t_primary, 30),
    );
  }
}
