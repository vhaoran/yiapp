import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/tools/adapt.dart';
import 'package:yiapp/complex/widgets/cus_complex.dart';
import 'icon_member.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/9/19 15:44
// usage ：能用成员或好友搜索，需要传入搜索的内容
// ------------------------------------------------------

typedef FnSearchBool = bool Function(int uid);

class SearchAdminData {
  final int uid;
  final String user_code;
  final String nick;
  final String url;

  SearchAdminData({
    this.uid: 0,
    this.user_code: "",
    this.nick: "机器猫",
    this.url: "",
  });

//  SearchAdminData(int uid, String nick, String url) {
//    if (uid == null) {
//      uid = 0;
//    }
//    this.uid = uid;
//
//    if (nick == null) {
//      nick = "机器猫";
//    }
//    this.nick = nick;
//
//    if (url == null) {
//      url = "";
//    }
//    this.url = url;
//  }

  String str() {
    return "uid: $uid nick:$nick url:$url";
  }
}

class SearchUserPanel extends StatefulWidget {
  List<SearchAdminData> l;
  List<num> uids; // 已经添加过的uid数组
  FnCheckChanged onCheckStateChanged;
  FnSearchBool isSelected; // 判断项是否在选择列表中

  SearchUserPanel({
    this.l,
    this.uids,
    this.onCheckStateChanged,
    this.isSelected,
    Key key,
  }) : super(key: key);

  @override
  SearchUserPanelState createState() => new SearchUserPanelState();
}

class SearchUserPanelState extends State<SearchUserPanel> {
  String _dst = ""; // 搜索的内容
  List<SearchAdminData> _resList = []; // 搜索到的结果

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: Column(
        children: <Widget>[
          // 搜索输入框
          Container(
            decoration: BoxDecoration(
              color: fif_primary,
              borderRadius: BorderRadius.circular(5),
            ),
            child: TextField(
              style: TextStyle(fontSize: Adapt.px(30), color: t_gray),
              onChanged: _search,
              decoration: InputDecoration(
                hintText: '搜索',
                hintStyle: TextStyle(fontSize: Adapt.px(30), color: t_gray),
                contentPadding: EdgeInsets.all(Adapt.px(20)),
                prefixIcon: Icon(Icons.search, color: t_gray),
                border: cusOutlineBorder(),
                focusedBorder: cusOutlineBorder(color: Colors.white24),
                errorBorder: cusOutlineBorder(color: Colors.white24),
                focusedErrorBorder: cusOutlineBorder(color: Colors.white24),
              ),
            ),
          ),
          SizedBox(height: Adapt.px(40)),
          Expanded(
            child: ListView(
              children: _memberView(),
              physics: BouncingScrollPhysics(),
            ),
          ),
        ],
      ),
    );
  }

  /// 是否已选中某一成员
  bool _isSelected(int uid) {
    if (widget.uids?.contains(uid)) {
      return true;
    }
    if (widget.isSelected != null) {
      return widget.isSelected(uid);
    }
    return false;
  }

  /// 是否已经含有成员
  bool _contains(int uid) {
    if (widget.uids?.contains(uid)) {
      return true;
    }
    return false;
  }

  /// 显示当前成员
  List<SearchAdminData> _match() {
    // 未进行搜索或没有搜索结果时，显示传递进来的数组成员
    if (_resList.length == 0 || _dst == null || _dst.length == 0) {
      return widget.l;
    }
    // 有搜索结果则显示搜到的成员
    return _resList;
  }

  /// 根据输入的内容进行搜索
  _search(String src) {
    _dst = src;
    if (src == null || src.length == 0) {
      setState(() {});
      return;
    }
    _resList.clear();
    widget.l.forEach((e) {
      // 有搜索结果时,添加到 temp 数组中
      if (e.nick.indexOf(src) != -1) {
        _resList.add(e);
      }
      setState(() {});
    });
  }

  /// 显示成员数据
  List<Widget> _memberView() {
    return _match().map((e) {
      return IconMember(
        uid: e.uid,
        nick: e.nick,
        url: e.url,
        showCheckBox: true,
        disable: _contains(e.uid),
        checked: this._isSelected(e.uid),
        onCheckStateChanged: (uid, checked) {
          if (widget.onCheckStateChanged != null) {
            widget.onCheckStateChanged(uid, checked);
          }
        },
      );
    }).toList();
  }
}
