// ------------------------------------------------------
// author：suxing
// date  ：2020/10/31 10:40
// usage ：所有消息类型的基类
// ------------------------------------------------------

abstract class MsgBase {
  int msg_type;
  int body_type;
  Map<String, dynamic> toJson();
}

// msg_type

/**
 * msg_type = 1,
 * body_type = 0
 *
 * */
