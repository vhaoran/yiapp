import 'package:flutter/material.dart';
import 'package:left_scroll_actions/left_scroll_actions.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/tools/adapt.dart';
import 'package:yiapp/complex/tools/cus_callback.dart';
import 'package:yiapp/complex/tools/cus_routes.dart';
import 'package:yiapp/complex/widgets/flutter/cus_dialog.dart';
import 'package:yiapp/complex/widgets/flutter/cus_text.dart';
import 'package:yiapp/complex/widgets/flutter/cus_toast.dart';
import 'package:yiapp/complex/widgets/small/cus_loading.dart';
import 'package:yiapp/model/complex/address_result.dart';
import 'package:yiapp/service/api/api_user.dart';
import 'package:yiapp/ui/mine/address/add_or_ch.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/9/9 11:43
// usage ：封装的单个收货地址组件
// ------------------------------------------------------

class AddrItem extends StatelessWidget {
  final AddressResult res;
  final VoidCallback onChanged;
  final FnAddr onAddr; // 下单时更改收货地址

  AddrItem({
    this.res,
    this.onChanged,
    this.onAddr,
    Key key,
  }) : super(key: key);

  bool _isDefault = false; // 是否默认收件地址

  @override
  Widget build(BuildContext context) {
    _isDefault = res.is_default == 1 ? true : false;
    return InkWell(
      onTap: () {
        if (onAddr != null) onAddr(res);
      },
      child: Card(
        margin: EdgeInsets.only(bottom: Adapt.px(5)),
        color: fif_primary,
        elevation: 1,
        shadowColor: Colors.white,
        child: CupertinoLeftScroll(
          closeOnPop: false,
          key: Key(res.id.toString()),
          closeTag: LeftScrollCloseTag('address'),
          child: _addr(context),
          buttons: _leftScroll(context),
        ),
      ),
    );
  }

  /// 地址
  Widget _addr(context) {
    return ListTile(
      title: Row(
        children: <Widget>[
          CusText(res.contact_person, t_gray, 30), // 收件人
          SizedBox(width: Adapt.px(30)),
          CusText(res.mobile, t_gray, 30), // 手机号
          if (_isDefault) // 显示默认收件地址
            Padding(
              padding: EdgeInsets.only(left: Adapt.px(30)),
              child: CusText("默认", t_primary, 28),
            ),
        ],
      ),
      subtitle: Text(
        res.detail, // 地址详情
        style: TextStyle(color: t_gray, fontSize: Adapt.px(26)),
        overflow: TextOverflow.ellipsis,
        maxLines: 2,
      ),
      trailing: InkWell(
        child: CusText("编辑", CusColors.systemGrey2(context), 28),
        onTap: () =>
            CusRoutes.push(context, AddChAddrPage(res: res)).then((val) {
          if (onChanged != null) onChanged();
        }),
      ),
      dense: true,
    );
  }

  /// 左滑功能
  List<Widget> _leftScroll(context) {
    return <Widget>[
      LeftScrollItem(
        text: "删除",
        color: Colors.red,
        textColor: Colors.white,
        onTap: () => _doRmAddr(context),
      ),
      if (!_isDefault)
        LeftScrollItem(
          text: "设为默认",
          color: CusColors.systemGrey2(context),
          textColor: Colors.black,
          onTap: () => _doSetDefault(context),
        ),
    ];
  }

  /// 删除地址
  void _doRmAddr(context) {
    CusDialog.err(
      context,
      title: "确定要删除该地址吗", // 移除收件地址
      onApproval: () async {
        var m = {"id": res.id};
        try {
          bool ok = await ApiUser.userAddrRm(m);
          print(">>>删除 id 为 ${res.id}的收件地址结果：$ok");
          if (ok) {
            CusToast.toast(context, text: "删除成功");
            if (onChanged != null) onChanged();
          }
        } catch (e) {
          print("<<<移除 id 为 ${res.id}的收件地址出现异常：$e");
        }
      },
    );
  }

  /// 设置为默认地址
  void _doSetDefault(context) async {
    var m = {"id": res.id};
    SpinKit.threeBounce(context);
    try {
      bool ok = await ApiUser.userAddrSetDefault(m);
      print(">>>设置 id 等于 ${res.id}为默认地址的结果：$ok");
      if (ok) {
        Navigator.pop(context);
        CusToast.toast(context, text: "设置成功");
        if (onChanged != null) onChanged();
      }
    } catch (e) {
      print("<<<设置 id 等于 ${res.id}为默认地址出现异常：$e");
    }
  }
}
