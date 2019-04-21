import 'package:flutter/material.dart';
import 'package:movies_db_bloc/domain/blocs/movies_bloc.dart';
import 'package:movies_db_bloc/domain/providers/app_provider.dart';
import 'package:movies_db_bloc/domain/providers/base_provider.dart';
import 'package:movies_db_bloc/presenter/app/movies_list.dart';

class App extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    print('App');
    AppProvider provider = AppProvider.of(context);
    MoviesBloc bloc = buildBloc(provider);
    return MaterialApp(
      title: 'Movies DB',
      home: BlocProvider<MoviesBloc>(
        builder: (BuildContext context, MoviesBloc bloc) =>
        bloc ?? buildBloc(provider),
        child: MoviesListView(),
        onDispose: (BuildContext context, MoviesBloc bloc) => bloc.dispose(),
      ),
    );
  }
}

