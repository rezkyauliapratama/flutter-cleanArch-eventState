import 'package:movies_db_bloc/data/models/api/movie_schema.dart';
import 'package:movies_db_bloc/data/models/base/base_api.dart';
export 'movie_schema.dart';

class ListMoviesSchema extends BaseApi<ListMoviesSchema> {
  int page;
  int totalResults;
  int totalPages;
  List<Movies> results;

  ListMoviesSchema(
      {this.page, this.totalResults, this.totalPages, this.results});

  ListMoviesSchema.fromJson(Map<String, dynamic> json)
      : super(
            statusMessage: json['status_message'],
            success: json['success'],
            statusCode: json['status_code']) {
    this.page = json['page'];
    this.totalResults = json['total_results'];
    this.totalPages = json['total_pages'];
    this.results = (json['results'] as List) != null
        ? (json['results'] as List).map((i) => Movies.fromJson(i)).toList()
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['page'] = this.page;
    data['total_results'] = this.totalResults;
    data['total_pages'] = this.totalPages;
    data['results'] = this.results != null
        ? this.results.map((i) => i.toJson()).toList()
        : null;
    return data;
  }

  @override
  ListMoviesSchema init() {
    return ListMoviesSchema();
  }

  ListMoviesSchema.withError(String string) : super(statusMessage : string, success : false, statusCode : -1);
}
