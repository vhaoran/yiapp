// ------------------------------------------------------
// author：suxing
// date  ：2020/8/6 10:30
// usage ：全局 int 类型
// ------------------------------------------------------

// ------------------------- 帖子状态 ------------------------
const int bbs_cancelled = -1; // 已取消
const int bbs_unpaid = 0; // 待付款
const int bbs_paid = 1; // 已付款
const int bbs_aim = 2; // 已抢单(悬赏帖无此状态)
const int bbs_ok = 3; // 已打赏(已完成)

// ------------------------- 大师订单状态 ------------------------
const int yiorder_unpaid = 0; // 待付款
const int yiorder_paid = 1; // 已付款
const int yiorder_ok = 3; // 已处理
const int yiorder_refund = 4; // 已退款

// ------------------------- 商城订单状态 ------------------------
const int mall_unpaid = 0; // 待付款
const int mall_paid = 1; // 已付款
const int mall_unreceived = 2; // 待收货
const int mall_received = 3; // 已收货
const int mall_cancelled = 4; // 已作废

// ------------------------- 提现类型 ------------------------
const int draw_await = 0; // 待审批
const int draw_cancelled = 1; // 取消或驳回
const int draw_ok = 4; // 审批通过

// ------------------------- 投诉状态 ------------------------
const int refund_await = 0; // 待审批
const int refund_b_pass = 1; // 运营商已审批
const int refund_p_pass = 4; // 平台已审批
const int refund_r = -1; // 平台已审批

// ------------------------- 可选悬赏帖类型 ------------------------
const int post_other = 0; // 其他类型
const int post_liuyao = 1; // 六爻类型
const int post_sizhu = 2; // 四柱类型
const int post_hehun = 3; // 合婚类型

// ------------------------- 评价类型 ------------------------
const int rate_best = 1; // 好评
const int rate_mid = 2; // 中评
const int rate_bad = 3; // 差评

// ------------------------- 六爻 ------------------------
const int shao_yin = 0; // 少阴 2背1字 3/8 概率
const int shao_yang = 1; // 少阳 1背2字 3/8 概率
const int lao_yin = 2; // 老阴 3字 1/8 概率
const int lao_yang = 3; // 老阳 3面 1/8 概率

// ------------------------- 性别 ------------------------
const int female = 0; // 女性
const int male = 1; // 男性

// ------------------------- 支付类型 ------------------------
const int pay_alipay = 0; // 支付宝
const int pay_wechat = 1; // 微信

// ------------------------- 启用停用大师 ------------------------
const int m_disable = 0; // 停用大师
const int m_enable = 1; // 启用大师

// ----------------------- 大师服务 -----------------------
const int ming_yun = 1; // 性格命运分析
const int shi_ye = 2; // 事业
const int hun_yin = 3; // 婚姻
const int cai_yun = 4; // 财运
const int jian_kang = 5; // 健康
const int shou_xiang = 6; // 手相
const int mian_xiang = 7; // 面相
const int mo_gu = 8; // 摸骨
const int qi_ming = 9; // 起名
const int hun_jia = 10; // 婚丧嫁娶吉日
const int he_hun = 11; // 合婚

// ----------------------- 消息类型 -----------------------
const int msg_text = 0; // 文本
const int msg_voice = 1; // 语音

// ------------------------- 时辰 ------------------------
const int zao_zi = 0; // 早子
const int chou_shi = 1; // 丑时
const int yin_shi = 2; // 寅时
const int mao_shi = 3; // 卯时
const int chen_shi = 4; // 辰时
const int si_shi = 5; // 巳时
const int wu_shi = 6; // 午时
const int wei_shi = 7; // 未时
const int shen_shi = 8; // 申时
const int you_shi = 9; // 酉时
const int xu_shi = 10; // 戌时
const int hai_shi = 11; // 亥时
const int wan_zi = 12; // 晚子
