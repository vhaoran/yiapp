import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/tools/adapt.dart';
import 'package:yiapp/complex/widgets/admin/search_admin.dart';
import 'package:yiapp/complex/widgets/flutter/cus_appbar.dart';
import 'package:yiapp/complex/widgets/flutter/cus_text.dart';
import 'icon_member.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/9/19 17:01
// usage ：通用的添加管理员选择页面
// ------------------------------------------------------

typedef FnMemberFlush = void Function(List<SearchAdminData> l);

class GroupBatchPage extends StatefulWidget {
  final List<SearchAdminData> l; // 从好友中选择要添加的
  final List<num> uids; // 已经添加过的uid数组
  final String buttonTitle;
  final String barTitle; // AppBar 标题
  final FnMemberFlush onClick; // 动作按钮的回调

  GroupBatchPage({
    this.l,
    this.uids,
    this.buttonTitle = "保存",
    this.barTitle = "成员管理",
    this.onClick,
  }) : assert(l != null);

  @override
  GroupBatchPageState createState() => GroupBatchPageState();
}

class GroupBatchPageState extends State<GroupBatchPage> {
  List<SearchAdminData> _sel = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBarCtr(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // 已选择成员
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: Adapt.px(25), vertical: Adapt.px(20)),
            child: _choicesCtl(),
          ),
          // 搜索输入框以及显示好友区域
          Expanded(child: _searchCtl()),
        ],
      ),
      backgroundColor: primary,
    );
  }

  Widget _choicesCtl() {
    return Wrap(
      alignment: WrapAlignment.start,
      runSpacing: Adapt.px(15),
      spacing: Adapt.px(25),
      children: _sel
          .map((e) => SizedBox(
                width: Adapt.px(120),
                child: IconMember(
                  uid: e.uid,
                  nick: e.nick,
                  url: e.url,
                  horizontal: false,
                  onIconTap: (int uid) {
                    int i = _sel.indexWhere((e) => e.uid == uid);
                    if (i >= 0) {
                      _sel.removeAt(i);
                    }
                    setState(() {});
                  },
                ),
              ))
          .toList(),
    );
  }

  Widget _searchCtl() {
    return SearchUserPanel(
      l: widget.l,
      uids: widget.uids,
      isSelected: (int uid) {
        if (_sel == null) {
          return false;
        }
        return _sel.indexWhere((e) => e.uid == uid) != -1;
      },
      onCheckStateChanged: (int uid, bool checked) {
        if (checked) {
          _addOfUid(uid);
          return;
        }
        _rmOfUid(uid);
      },
    );
  }

  /// 添加到搜索结果
  _addOfUid(int uid) {
    SearchAdminData bean =
        widget.l.firstWhere((e) => e.uid == uid, orElse: () => null);
    if (bean != null) {
      if (_sel.indexWhere((e) => e.uid == bean.uid) == -1) {
        _sel.add(bean);
      }
      setState(() {});
    }
  }

  /// 从搜索结果中移除
  _rmOfUid(int uid) {
    int i = _sel.indexWhere((e) => e.uid == uid);
    if (i >= 0 && i < _sel.length) {
      _sel.removeAt(i);
      setState(() {});
    }
  }

  Widget _appBarCtr() {
    return CusAppBar(
      text: widget.barTitle,
      actions: <Widget>[
        FlatButton(
          child: CusText(widget.buttonTitle, t_gray, 28),
          onPressed: () {
            if (widget.onClick != null) {
              widget.onClick(_sel);
            }
          },
        )
      ],
    );
  }
}
