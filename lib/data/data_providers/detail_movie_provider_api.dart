import 'package:dio/dio.dart';
import 'package:movies_db_bloc/data/common/secret_components.dart';
import 'package:movies_db_bloc/data/models/api/movie_detail_schema.dart';
import 'package:movies_db_bloc/data/repositories/movie_details_repository.dart';

export 'package:movies_db_bloc/data/models/api/movie_detail_schema.dart';

class DetailMovieProviderApi  implements MovieDetailInterface {
  final Dio _dio;
  final SecretLoader _secretLoader;
  final String _urlDetailrMovie = "/movie";

  DetailMovieProviderApi(this._dio, this._secretLoader);


  Future<MovieDetailSchema> getDetailMovie(int movieId) async {
    try {

      Secret secret = await _secretLoader.load();
      Response response = await _dio.get(_urlDetailrMovie+"/$movieId", queryParameters: {"api_key": secret.apiKey, "language": "en-US"});
      return MovieDetailSchema.fromJson(response.data);
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return MovieDetailSchema.withError(error.toString());
    }
  }
}
