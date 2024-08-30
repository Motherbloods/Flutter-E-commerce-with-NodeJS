class SearchSuggest {
  final String? id;
  final String? suggest;
  final String? date;

  SearchSuggest({this.id, this.suggest, this.date});

  factory SearchSuggest.fromJson(Map<String, dynamic> json) {
    return SearchSuggest(
        id: json["_id"], suggest: json['suggest'], date: json['date']);
  }
}
