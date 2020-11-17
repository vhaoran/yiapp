// ------------------------------------------------------
// author：suxing
// date  ：2020/9/14 17:45
// usage ：用户是否是admin、master、broker、游客
// ------------------------------------------------------

class ApiState {
  // 是否游客登录(非会员、大师、运营商、系统管理员)
  static bool is_guest = true;

  // 是否大师
  static bool is_master = false;

  // 是否运营商管理员
  // 运营商可以作为运营商管理员的一员，所以可以据此判断是否运营商,两者部分UI是一样的
  static bool is_broker_admin = false;

  // 是否已经绑定过服务码，绑定过服务码的被称为会员
  static bool is_vip = false;

  // 代理 id
  static num broker_id = 0;

  // 是否闪断帖
  static bool isFlash = false;
}
