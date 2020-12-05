import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/global/cus_fn.dart';
import 'package:yiapp/cus/cus_route.dart';
import 'package:yiapp/func/snap_done.dart';
import 'package:yiapp/util/screen_util.dart';
import 'package:yiapp/model/complex/address_result.dart';
import 'package:yiapp/service/api/api_base.dart';
import 'package:yiapp/service/api/api_user.dart';
import 'package:yiapp/ui/mine/address/user_addr.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/10/15 10:09
// usage ：订单中的收货地址
// ------------------------------------------------------

class ProOrderAddress extends StatefulWidget {
  final AddressResult addr;
  final FnAddr onChanged; // 选择收货地址后的回调

  ProOrderAddress({this.addr, this.onChanged, Key key}) : super(key: key);

  @override
  _ProOrderAddressState createState() => _ProOrderAddressState();
}

class _ProOrderAddressState extends State<ProOrderAddress> {
  AddressResult _res;
  var _future;

  @override
  void initState() {
    _future = _fetch();
    super.initState();
  }

  _fetch() async {
    try {
      var res = await ApiUser.userAddrList(ApiBase.uid);
      if (res != null && res?.isNotEmpty) {
        _res = res.first; // 第一个为默认地址
        if (widget.onChanged != null) {
          widget.onChanged(_res);
        }
      }
    } catch (e) {
      Log.error("确认订单时，获取用户地址出现异常：$e");
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
        return _addrTip();
      },
    );
  }

  /// 有地址则显示，无地址则提示
  Widget _addrTip() {
    return Container(
      child: InkWell(
        onTap: () => CusRoute.push(
          context,
          UserAddressPage(event: true),
        ).then((val) {
          if (val != null) {
            _res = val;
            if (widget.onChanged != null) {
              widget.onChanged(_res);
            }
            setState(() {});
          }
        }),
        child: Container(
          color: fif_primary,
          padding: EdgeInsets.all(S.w(10)),
          child: _res == null
              ? Center(
                  child: Text(
                    "暂未添加收货地址，点击添加",
                    style: TextStyle(color: t_gray, fontSize: S.sp(15)),
                  ),
                )
              : _addrData(),
        ),
      ),
    );
  }

  /// 显示收货地址
  Widget _addrData() {
    return Row(
      children: <Widget>[
        Icon(FontAwesomeIcons.mapMarker, color: t_yi),
        SizedBox(width: S.w(20)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(
                    _res.contact_person, // 收件人
                    style: TextStyle(color: t_gray, fontSize: S.sp(15)),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: S.w(15)),
                    child: Text(
                      _res.mobile,
                      style: TextStyle(color: t_gray, fontSize: S.sp(15)),
                    ),
                  ), // 手机号
                  if (_res.is_default == 1) // 显示默认收件地址
                    Text(
                      "默认",
                      style: TextStyle(color: t_primary, fontSize: S.sp(15)),
                    ),
                ],
              ),
              Text(
                _res.detail, // 收货地址
                style: TextStyle(color: t_gray, fontSize: S.sp(15)),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ],
          ),
        )
      ],
    );
  }
}
