import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:movies_db_bloc/data/common/secret_components.dart';
import 'package:movies_db_bloc/data/data_providers/movies_provider_api.dart';
import 'package:movies_db_bloc/data/repositories/movies_repository.dart';
import 'package:movies_db_bloc/domain/providers/app_provider.dart';
import 'package:rxdart/rxdart.dart';

export 'package:movies_db_bloc/data/data_providers/movies_provider_api.dart';

class MoviesBloc {
  final MoviesRepository _repo;
  int _page = 1;

  PublishSubject<MoviesEvent> _eventController = PublishSubject<MoviesEvent>();
  final _itemsOutput = BehaviorSubject<List<Movies>>();

  //getter sink
  Function(MoviesEvent) get emitEvent => _eventController.sink.add;

  //getter stream
  Observable<List<Movies>> get outMovies =>
      _itemsOutput.stream.asBroadcastStream();

  MoviesBloc(this._repo) {
//    _eventController.pipe(_itemsOutput);
  }

  Future<List<Movies>> fetchMovies() async {
    ListMoviesSchema moviesSchema = await _repo.fetchItem(page: _page++);
    return moviesSchema.results;
  }

  dispose() {
    print('dispose moviesBloc');
    _eventController.close();
    _itemsOutput.close();
  }
}

abstract class MoviesEvent {}

@immutable
class FetchMoviesEvent extends MoviesEvent {
  FetchMoviesEvent();
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
