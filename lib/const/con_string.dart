// ------------------------------------------------------
// author：suxing
// date  ：2020/8/24 17:28
// usage ：全局 String 类型
// ------------------------------------------------------

/// 本地数据库表名称 tb table
const String tb_login = "tb_login"; // 本地登录信息表名

/// 本地存储的键
const String kv_jwt = "/login/jwt"; // 本地存储jwt的键
const String kv_tmp_pwd = "tmp_pwd"; // 保存临时密码
const String kv_liuyao = "liu_yao"; // 存储六爻数据
const String kv_shop = "shop"; // 本地购物车键
const String kv_order = "order"; // 提交大师订单的数据(避免多个页面传值)

/// 微服务类型前缀
const String w_yi_cms = "/yi/cms/";
const String w_yi_user = "/yi/user/";
const String w_yi_trade = "/yi/trade/";
const String w_yi_msg = "/yi/msg/";

/// 业务类型(business)
const String b_recharge = "recharge"; // 充值
// 这里名称中有的是下划线，有的是中间杠 如 bbs-prize 和 bbs_prize
const String b_mall = "mall"; // 商城订单付款
const String b_yi_order = "yi-order"; // 大师订单付款
const String b_bbs_prize = "bbs-prize"; // 悬赏帖付款
const String b_bbs_vie = "bbs-vie"; // 闪断帖付款
const String b_master_draw_money = "master-draw-money"; // 大师提现

/// 命名路由名称 r 是 route 的缩写
const String r_con_pair = "con_pair"; // 星座配对
const String r_zodiac_pair = "zodiac_pair"; // 生肖配对
const String r_blood_pair = "blood_pair"; // 血型配对
const String r_birth_pair = "birth_pair"; // 生日配对
const String r_com_draw = "com_draw"; // 共用的免费抽灵签页面
const String r_liu_yao = "liu_yao"; // 六爻排盘
const String r_sizhu = "sizhu"; // 四柱测算
const String r_he_hun = "he_hun"; // 合婚测算
const String r_article = "article"; // 文章
const String r_zhou_gong = "zhou_gong"; // 周公

/// 综合
const String jwt_134 = "test/134"; // jwt = 134;
const String ali_font = "AliIcon"; // 阿里图标字体
const String post_comment = "post_comment"; // 回帖事件
const String yuan_bao = "元宝"; // 目前先以元宝为货币单位
