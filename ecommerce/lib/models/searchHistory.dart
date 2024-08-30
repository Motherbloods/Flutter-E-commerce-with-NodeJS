class SearchHistory {
  final String? id;
  final String? searchValue;
  final String? userId;

  SearchHistory({this.id, this.searchValue, this.userId});

  factory SearchHistory.fromJson(Map<String, dynamic> json) {
    return SearchHistory(
        id: json['_id'],
        searchValue: json['searchValue'],
        userId: json['userId']);
  }
}
