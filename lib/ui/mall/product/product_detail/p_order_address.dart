import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:yiapp/complex/class/debug_log.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/tools/adapt.dart';
import 'package:yiapp/complex/tools/cus_callback.dart';
import 'package:yiapp/complex/tools/cus_routes.dart';
import 'package:yiapp/complex/type/bool_utils.dart';
import 'package:yiapp/complex/widgets/flutter/cus_text.dart';
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
      Debug.logError("出现异常：$e");
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
        return Container(
          child: InkWell(
            onTap: () => CusRoutes.push(
              context,
              UserAddressPage(event: true),
            ).then((val) => setState(
                  () {
                    _res = val;
                    if (widget.onChanged != null) {
                      widget.onChanged(_res);
                    }
                  },
                )),
            child: _addrCtr(),
          ),
        );
      },
    );
  }

  /// 显示收货地址
  Widget _addrCtr() {
    return Container(
      color: fif_primary,
      padding: EdgeInsets.all(Adapt.px(20)),
      child: Row(
        children: <Widget>[
          Icon(FontAwesomeIcons.mapMarker, color: t_yi),
          SizedBox(width: Adapt.px(40)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    CusText(_res.contact_person, t_gray, 30), // 收件人
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: Adapt.px(30)),
                      child: CusText(_res.mobile, t_gray, 30),
                    ), // 手机号
                    if (_res.is_default == 1) // 显示默认收件地址
                      CusText("默认", t_primary, 28)
                  ],
                ),
                Text(
                  _res.detail, // 收货地址
                  style: TextStyle(color: t_gray, fontSize: Adapt.px(28)),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
