import 'dart:async';

import 'package:dio/dio.dart';
import 'package:movies_db_bloc/data/common/secret_components.dart';
import 'package:movies_db_bloc/data/data_providers/movies_provider_api.dart';
import 'package:movies_db_bloc/data/repositories/movies_repository.dart';
import 'package:movies_db_bloc/domain/providers/app_provider.dart';

export 'package:movies_db_bloc/data/data_providers/movies_provider_api.dart';

class MoviesBloc {
  final MoviesRepository repo;

  StreamController<ListMoviesSchema> _streamController = StreamController<ListMoviesSchema>.broadcast();
  Sink<ListMoviesSchema> get _inMoviesStream => _streamController.sink;
  Stream<ListMoviesSchema> get outMoviesStream => _streamController.stream;

  MoviesBloc(this.repo);

  fetchMovies() async {
    final listMovies = await repo.fetchItem();
    _inMoviesStream.add(listMovies);
  }

  void dispose() {
    print("Dispose of Information Bloc");
    _streamController.close();
  }
}

MoviesBloc buildBloc(AppProvider appProvider) {
  SecretLoader secretLoader = appProvider.secretLoader;
  Dio dio = appProvider.dio;
  List<MovieInterface> sources = <MovieInterface>[
    MoviesProviderApi(dio, secretLoader)
  ];
  MoviesRepository repo = MoviesRepository(sources: sources);
  return MoviesBloc(repo);
}
