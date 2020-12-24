import 'dart:io';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/ui/provider/master_state.dart';
import 'package:yiapp/cus/cus_route.dart';
import 'package:yiapp/util/screen_util.dart';
import 'package:yiapp/widget/small/cus_avatar.dart';
import 'package:yiapp/widget/flutter/cus_bottom_sheet.dart';
import 'package:yiapp/widget/flutter/cus_toast.dart';
import 'package:yiapp/model/dicts/master-info.dart';
import 'package:yiapp/service/api/api-master.dart';
import 'package:yiapp/util/file_util.dart';
import 'ch_master_nick.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/9/17 19:10
// usage ：大师昵称、头像
// ------------------------------------------------------

class MasterNickAvatar extends StatefulWidget {
  final bool isSelf;
  final MasterInfo m; // 大师个人信息

  MasterNickAvatar({this.isSelf: false, this.m, Key key}) : super(key: key);

  @override
  _MasterNickAvatarState createState() => _MasterNickAvatarState();
}

class _MasterNickAvatarState extends State<MasterNickAvatar> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Align(
          alignment: Alignment(0, 0.2), // 头像
          child: InkWell(
            child: CusAvatar(url: widget.m.icon ?? "", circle: true),
            onTap: widget.isSelf
                ? () => CusBottomSheet(context, OnFile: (file) {
                      if (file != null) _doChIcon(file);
                      setState(() => {});
                    })
                : null,
          ),
        ),
        Align(
          alignment: Alignment(0, 0.75),
          child: InkWell(
            child: Text(
              widget.m.nick ?? "",
              style: TextStyle(
                color: t_primary,
                fontSize: S.sp(16),
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: widget.isSelf
                ? () => CusRoute.push(
                    context, ChMasterNick(nick: widget.m.nick, id: widget.m.id))
                : null,
          ),
        ),
      ],
    );
  }

  /// 修改大师头像
  void _doChIcon(File file) async {
    if (file == null) return;
    try {
      String url = await FileUtil.singleFile(file);
      Log.info("这里的url是：$url");
      var m = {
        "id": widget.m.id,
        "M": {"icon": url}
      };
      bool ok = await ApiMaster.masterInfoCh(m);
      if (ok) {
        Log.info("修改大师头像成功");
        context.read<MasterInfoState>().chIcon(url);
        CusToast.toast(context, text: "修改成功");
      }
    } catch (e) {
      Log.error("修改大师头像出现异常：$e");
    }
  }
}
