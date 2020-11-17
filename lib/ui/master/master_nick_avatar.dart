import 'dart:io';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:yiapp/complex/class/debug_log.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/provider/master_state.dart';
import 'package:yiapp/complex/tools/api_state.dart';
import 'package:yiapp/complex/tools/cus_routes.dart';
import 'package:yiapp/complex/tools/cus_tool.dart';
import 'package:yiapp/complex/widgets/small/cus_avatar.dart';
import 'package:yiapp/complex/widgets/flutter/cus_bottom_sheet.dart';
import 'package:yiapp/complex/widgets/flutter/cus_text.dart';
import 'package:yiapp/complex/widgets/flutter/cus_toast.dart';
import 'package:yiapp/model/dicts/master-info.dart';
import 'package:yiapp/service/api/api-master.dart';
import 'ch_master_nick.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/9/17 19:10
// usage ：大师昵称、头像
// ------------------------------------------------------

class MasterNickAvatar extends StatefulWidget {
  final MasterInfo m; // 大师个人信息

  MasterNickAvatar({this.m, Key key}) : super(key: key);

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
            onTap: ApiState.is_master
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
            child: CusText(widget.m.nick ?? "", t_primary, 30),
            onTap: ApiState.is_master
                ? () => CusRoutes.push(
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
      String url = await CusTool.fileUrl(file);
      Debug.log("这里的url是：$url");
      var m = {
        "id": widget.m.id,
        "M": {"icon": url}
      };
      bool ok = await ApiMaster.masterInfoCh(m);
      if (ok) {
        Debug.log("修改大师头像成功");
        context.read<MasterInfoState>().chIcon(url);
        CusToast.toast(context, text: "修改成功");
      }
    } catch (e) {
      Debug.logError("修改大师头像出现异常：$e");
    }
  }
}
