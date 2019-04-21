import 'package:dio/dio.dart';
import 'package:movies_db_bloc/data/common/secret_components.dart';
import 'package:movies_db_bloc/data/models/api/list_movies_schema.dart';
import 'package:movies_db_bloc/data/repositories/movies_repository.dart';

export '../models/api/list_movies_schema.dart';

class MoviesProviderApi implements MovieInterface {
  final Dio _dio;
  final SecretLoader _secretLoader;
  final String _urlPopularMovies = "/movie/popular";

  MoviesProviderApi(this._dio, this._secretLoader);

  Future<ListMoviesSchema> getListMovies() async {
    try {

      Secret secret = await _secretLoader.load();
      Response response = await _dio.get(_urlPopularMovies, queryParameters: {"api_key": secret.apiKey, "language": "en-US"});
      return ListMoviesSchema.fromJson(response.data);
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return ListMoviesSchema.withError(error.toString());
    }
  }
}
