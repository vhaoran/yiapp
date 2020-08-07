import 'dart:convert';

/// page_no : 1
/// pages_count : 1
/// rows_count : 2
/// rows_per_page : 2
/// where : {"uid":1}

class PageBean<T> {
  PageBean({int pageNo, int rowsPerPage, dynamic where});

  int pageNo;
  int pagesCount;
  int rowsCount;
  int rowsPerPage;
  dynamic where;

  List<T> data;

  static PageBean fromMap<T>(Map<String, dynamic> map) {
    if (map == null) return null;
    PageBean pageBeanBean = PageBean();
    pageBeanBean.pageNo = map['page_no'];
    pageBeanBean.pagesCount = map['pages_count'];
    pageBeanBean.rowsCount = map['rows_count'];
    pageBeanBean.rowsPerPage = map['rows_per_page'];
    pageBeanBean.where = map["where"];

    return pageBeanBean;
  }

  Map toJson() => {
        "page_no": pageNo,
        "pages_count": pagesCount,
        "rows_count": rowsCount,
        "rows_per_page": rowsPerPage,
        "where": jsonEncode(where),
        "data": jsonEncode(data),
      };
}

/// uid : 1
