import 'package:yiapp/service/api/api_base.dart';

import 'msg_body.dart';

// ------------------------------------------------------
// comment：suxing 备注
// date  ：2020/7/28 14:20
// usage ：最近收到的消息的 Model 类
// ------------------------------------------------------

class InfoRecent {
  int id;
  String name;
  String icon;
  String created_at;
  bool top;
  bool no_disturb;
  int not_read_count;
  int type;
  dynamic msgData;

  InfoRecent();

  factory InfoRecent.from(MsgBody src) {
    if (src == null) {
      return null;
    }

    InfoRecent bean = new InfoRecent();
    //todo
    //--------- id / name            ---------------
    //---------int type(1:private 2:group 3:bulletion)            ---------------
    if (src.to_gid > 0) {
      bean.id = src.to_gid;
      bean.name = src.to_gname;
      bean.type = 2;
      bean.icon = src.to_gicon;
    } else if (src.from_uid > 0 && src.to_uid > 0) {
      bean.type = 1;
      //cast to me,show from_uid
      if (src.to_uid == ApiBase.uid) {
        bean.id = src.from_uid;
        bean.name = src.from_nick;
        bean.icon = src.from_icon;
      } else {
        // cast to other,other
        bean.id = src.to_uid;
        bean.name = src.to_nick;
        bean.icon = src.to_icon;
      }
    } //bulletin
    else {
      // todo whr 公众号上线时处理
      bean.id = 0;
      bean.name = "公众号-未处理的代码";
      bean.type = 3;
      //bean.icon =
    }
    //---------bool top;            ---------------
    bean.top = src.on_top == 1;
    //---------bool no_disturb;     ---------------
    bean.no_disturb = src.no_disturb == 1;
    //---------int not_read_count;  ---------------
    bean.not_read_count = src.not_read_count;
    bean.created_at = src.created_at;

    //---------dynamic msgData;     ---------------
    bean.msgData = src.body;
    return bean;
  }
}
