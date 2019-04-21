import 'package:flutter/material.dart';
import 'package:movies_db_bloc/data/models/api/list_movies_schema.dart';
import 'package:movies_db_bloc/data/models/api/movie_schema.dart';
import 'package:movies_db_bloc/domain/blocs/movies_bloc.dart';
import 'package:movies_db_bloc/domain/providers/base_provider.dart';

class MoviesListView extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    print('MoviesListView');
    final bloc = Provider.of<MoviesBloc>(context);
    bloc.fetchMovies();

    return buildList(bloc);
  }

  Widget buildList(MoviesBloc bloc) {
    return Scaffold(
      appBar: AppBar(title: Text('Movies DB')),
      body: StreamBuilder(
        stream: bloc.outMoviesStream,
        builder:
            (BuildContext context, AsyncSnapshot<ListMoviesSchema> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView.builder(
              itemCount: snapshot.data.results.length,
              itemBuilder: (context, int index) {
                return moviesListTile(snapshot.data.results[index]);
              });
        },
      ),
    );
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
        )
      ],
    );
  }

}