import 'package:flutter/material.dart';
import 'package:movies_db_bloc/domain/blocs/detail_movie_bloc.dart';
import 'package:movies_db_bloc/domain/blocs/movies_bloc.dart';
import 'package:movies_db_bloc/domain/providers/app_provider.dart';
import 'package:movies_db_bloc/domain/providers/base_provider.dart';
import 'package:movies_db_bloc/presenter/app/movies_detail.dart';
import 'package:movies_db_bloc/presenter/app/movies_list.dart';

class App extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movies DB',
      onGenerateRoute: routes,
    );
  }

  Route routes(RouteSettings setting) {
    if (setting.name == '/') {
      return MaterialPageRoute(
        builder: (BuildContext context) {
          AppProvider provider = AppProvider.of(context);
          return BlocProvider<MoviesBloc>(
            builder: (BuildContext context, MoviesBloc bloc) =>
                bloc ?? buildBloc(provider),
            child: MoviesListView(),
            onDispose: (BuildContext context, MoviesBloc bloc) =>
                bloc.dispose(),
          );
        },
      );
    } else {
      return MaterialPageRoute(
        builder: (BuildContext context) {
          AppProvider provider = AppProvider.of(context);
          final movieId = int.parse(setting.name.replaceFirst('/', ''));
          return BlocProvider<DetailMoviesBloc>(
            builder: (BuildContext context, DetailMoviesBloc bloc) =>
                bloc ?? buildMovieDetailsBloc(provider),
            child: MoviesDetail(movieId),
            onDispose: (BuildContext context, DetailMoviesBloc bloc) {
              print("onDispose moviesDetail");
              bloc.dispose();
            },
          );

          MoviesDetail(movieId);
        },
      );
    }
  }
}
