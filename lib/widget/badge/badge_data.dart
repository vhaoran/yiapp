// ------------------------------------------------------
// author：suxing
// date  ：2020/12/1 下午6:53
// usage ：badge 中的数据
// ------------------------------------------------------

enum SuBadgeShape {
  circle,
  square,
  spot,
}

enum SuBadgePosition {
  topRight,
  topLeft,
  bottomRight,
  bottomLeft,
}

class BadgeRadius {
  static const double square_radius = 1;
  static const double spot_radius = 4;
  static const double badge_size = 18;
  static const double def_radius = -1;
}
