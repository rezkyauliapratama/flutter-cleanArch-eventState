import 'package:flutter/material.dart';
import 'package:movies_db_bloc/domain/blocs/detail_movie_bloc.dart';
import 'package:movies_db_bloc/domain/providers/base_provider.dart';

class MoviesDetail extends StatelessWidget {
  final int _movieId;

  MoviesDetail(this._movieId);

  @override
  Widget build(BuildContext context) {
    final movieDetailsBloc = Provider.of<DetailMoviesBloc>(context);
    movieDetailsBloc.fetchDetailsMovie(_movieId);

    return Scaffold(
      appBar: AppBar(
        title: Text("Movie Detail"),
      ),
      body: StreamBuilder(
          stream: movieDetailsBloc.outMovieDetails,
          builder: (BuildContext context,
              AsyncSnapshot<MovieDetailSchema> snapshot) {
            if (snapshot.hasData){
              return _BodyMoviesDetail(snapshot.data);
            }else{
              return Center(
                child: Container(),
              );
            }
          }),
    );
  }
}

class _BodyMoviesDetail extends StatelessWidget {
  final MovieDetailSchema _movie;

  _BodyMoviesDetail(this._movie);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text("Movies Detail ${_movie.title}"),
      ),
    );
  }
}
