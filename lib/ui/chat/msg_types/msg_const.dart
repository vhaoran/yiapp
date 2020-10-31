// ------------------------------------------------------
// author：suxing
// date  ：2020/10/31 10:55
// usage ：MsgBody 中的 msg_type 和 body_type 对应的数字
// ------------------------------------------------------

// ---------------------- msg_type 类型 ----------------------
const int msg_chat = 1; // 聊天消息
const int msg_system = 4; // 系统通知类消息

// ---------------------- body_type 类型 ----------------------

// msg_chat = 1 (聊天消息) 的 body_type
const int body_text = 0; // 普通文本
const int body_image = 1; // 图片
const int body_file = 2; // 文件
const int body_voice = 3; // 语音聊天
const int body_video = 4; // 视频聊天
const int body_emoji = 5; // 表情
