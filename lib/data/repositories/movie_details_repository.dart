import 'package:movies_db_bloc/data/models/api/movie_detail_schema.dart';
export 'package:movies_db_bloc/data/models/api/movie_detail_schema.dart';

class MovieDetailsRepository {
  final List<MovieDetailInterface> sources;

  MovieDetailsRepository({this.sources});

  Future<MovieDetailSchema> fetchDetailMovie(int movieId) async {
    MovieDetailSchema item;
    MovieDetailInterface source;

    for (source in sources) {
      item = await source.getDetailMovie(movieId);
      if (item != null) {
        break;
      }
    }
    return item;
  }
}

abstract class MovieDetailInterface {
  Future<MovieDetailSchema> getDetailMovie(int movieId);
}
