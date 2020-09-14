// ------------------------------------------------------
// author：suxing
// date  ：2020/9/14 17:45
// usage ：用户是否是admin、master、broker、游客
// ------------------------------------------------------

class ApiState {
  // 是否游客登录
  static bool isGuest = true;

  // 是否管理员
  static bool isAdmin = false;

  // 是否大师
  static bool isMaster = false;

  // 是否代理
  static bool isBroker = false;

  // 是否代理管理员
  static bool isBrokerAdmin = false;
}
