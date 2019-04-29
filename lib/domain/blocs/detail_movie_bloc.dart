import 'package:dio/dio.dart';
import 'package:movies_db_bloc/data/common/secret_components.dart';
import 'package:movies_db_bloc/data/data_providers/detail_movie_provider_api.dart';
import 'package:movies_db_bloc/data/models/api/movie_detail_schema.dart';
import 'package:movies_db_bloc/data/repositories/movie_details_repository.dart';
import 'package:movies_db_bloc/domain/providers/app_provider.dart';
import 'package:rxdart/rxdart.dart';

export 'package:movies_db_bloc/data/repositories/movie_details_repository.dart';

class DetailMoviesBloc {
  final MovieDetailsRepository _repo;

  //in stream
  final _inMovieDetails = PublishSubject<MovieDetailSchema>();

  //getter sink
  Observable<MovieDetailSchema> get outMovieDetails => _inMovieDetails.stream;

  DetailMoviesBloc(this._repo);

  void fetchDetailsMovie(int movieId) async {
    MovieDetailSchema item = await _repo.fetchDetailMovie(movieId);
    _inMovieDetails.sink.add(item);
  }

  dispose() {
    print('dispose detailMovieBloc');
    _inMovieDetails.close();
  }
}

DetailMoviesBloc buildMovieDetailsBloc(AppProvider appProvider) {
  SecretLoader secretLoader = appProvider.secretLoader;
  Dio dio = appProvider.dio;
  List<MovieDetailInterface> sources = <MovieDetailInterface>[
    DetailMovieProviderApi(dio, secretLoader)
  ];
  print('init buildMovieDetailsBloc');
  MovieDetailsRepository repo = MovieDetailsRepository(sources: sources);
  return DetailMoviesBloc(repo);
}
