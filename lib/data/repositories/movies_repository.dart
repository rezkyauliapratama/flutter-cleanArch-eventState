
import 'package:movies_db_bloc/data/models/api/list_movies_schema.dart';

class MoviesRepository {
  final List<MovieInterface> sources;

  MoviesRepository({this.sources});

  Future<ListMoviesSchema> fetchItem() async {
    ListMoviesSchema item;
    MovieInterface source;

    for (source in sources) {
      item = await source.getListMovies();
      if (item != null) {
        break;
      }
    }

    return item;
  }

}

abstract class MovieInterface {
  Future<ListMoviesSchema> getListMovies();
}
