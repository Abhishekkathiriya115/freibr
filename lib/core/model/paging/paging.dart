class PagingModel<T> {
  PagingModel({
    this.status,
    this.statusCode,
    this.message,
    this.data,
  });

  bool status;
  int statusCode;
  String message;
  PageModel<T> data;

  factory PagingModel.fromJson(
          Map<String, dynamic> json, Function fromJsonModel) =>
      PagingModel(
        status: json["status"],
        statusCode: json["statusCode"],
        message: json["message"],
        data: PageModel.fromJson(json["data"], fromJsonModel),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "statusCode": statusCode,
        "message": message,
        "data": data.toJson(),
      };
}
// To parse this JSON data, do
//
//     final pageModel = pageModelFromJson(jsonString);

class PageModel<T> {
  PageModel({
    this.currentPage,
    this.firstPageUrl,
    this.from,
    this.lastPage,
    this.data,
    this.lastPageUrl,
    this.nextPageUrl,
    this.isLastPage,
    this.path,
    this.perPage,
    this.prevPageUrl,
    this.to,
    this.total,
  });

  int currentPage;
  String firstPageUrl;
  bool isLastPage;
  List<T> data;
  int from;
  int lastPage;
  String lastPageUrl;
  dynamic nextPageUrl;
  String path;
  String perPage;
  String prevPageUrl;
  int to;
  int total;

  factory PageModel.fromJson(
          Map<String, dynamic> json, Function fromJsonModel) =>
      PageModel(
        currentPage: json["current_page"],
        firstPageUrl: json["first_page_url"],
        data: List<T>.from(json["data"].map((x) => fromJsonModel(x))),
        from: json["from"],
        isLastPage: json["current_page"] == json["last_page"],
        lastPage: json["last_page"],
        lastPageUrl: json["last_page_url"],
        nextPageUrl: json["next_page_url"],
        path: json["path"],
        perPage: json["per_page"].toString(),
        prevPageUrl: json["prev_page_url"],
        to: json["to"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "current_page": currentPage,
        "first_page_url": firstPageUrl,
        "from": from,
        "last_page": lastPage,
        "last_page_url": lastPageUrl,
        "next_page_url": nextPageUrl,
        "path": path,
        "per_page": perPage,
        "prev_page_url": prevPageUrl,
        "to": to,
        "total": total,
      };
}
