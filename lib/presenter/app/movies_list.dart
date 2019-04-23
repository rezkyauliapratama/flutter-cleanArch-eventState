import 'package:flutter/material.dart';
import 'package:movies_db_bloc/data/models/api/list_movies_schema.dart';
import 'package:movies_db_bloc/data/models/api/movie_schema.dart';
import 'package:movies_db_bloc/domain/blocs/movies_bloc.dart';
import 'package:movies_db_bloc/domain/providers/base_provider.dart';
import 'package:movies_db_bloc/presenter/widgets/pagination_list_widget.dart';

class MoviesListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('MoviesListView');
    final moviesBloc = Provider.of<MoviesBloc>(context);

    moviesBloc.emitEvent(FetchMoviesEvent());

    return buildList(moviesBloc);
  }

  Widget buildList(MoviesBloc moviesBloc) {
    return Scaffold(
        appBar: AppBar(title: Text('Movies DB')),
        body: PaginationList(
          pageBuilder: (int currentListSize) {
            return moviesBloc.fetchMovies();
          },
          itemBuilder: (int index, item) {
            return moviesListTile(item);
          },
        ));
  }

  Widget moviesListTile(Movies item) {
    return Column(
      children: <Widget>[
        ListTile(
          onTap: () {
            print("movie title : ${item.title}");
          },
          title: Text(item.title),
          subtitle: Text('${item.popularity} populers'),
          trailing: Column(
            children: <Widget>[
              Icon(Icons.star),
              Text(item.voteCount.toString())
            ],
          ),
        ),
        Divider(
          height: 8.0,
        ),
      ],
    );
  }
}
