import 'package:flutter/material.dart';
import 'package:movies_db_bloc/domain/blocs/detail_movie_bloc.dart';
import 'package:movies_db_bloc/domain/providers/base_provider.dart';
import 'package:shimmer/shimmer.dart';

class MoviesDetail extends StatelessWidget {
  final int _movieId;

  MoviesDetail(this._movieId);

  @override
  Widget build(BuildContext context) {
    final movieDetailsBloc = Provider.of<DetailMoviesBloc>(context);
    movieDetailsBloc.fetchDetailsMovie(_movieId);

    return Scaffold(
        body: StreamBuilder(
            stream: movieDetailsBloc.outMovieDetails,
            builder: (BuildContext context,
                AsyncSnapshot<MovieDetailSchema> snapshot) {
              if (snapshot.hasData) {
                return _BodyMoviesDetail(snapshot.data);
              } else {
                return _LoadingPage();
              }
            }));
  }
}

class _BodyMoviesDetail extends StatelessWidget {
  final MovieDetailSchema _movie;

  _BodyMoviesDetail(this._movie);

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          SliverAppBar(
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                title: Text(_movie.title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                    )),
                background: _backgroundPoster()),
          ),
        ];
      },
      body: _body(),
    );
  }

  Widget _body() {
    List<Widget> children = [
      Text(
        "Overview",
        textAlign: TextAlign.start,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 2.0),
      ),
      Text(
        _movie.overview,
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.justify,
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 2.0),
      ),
      Text(
        "Vote : ${_movie.voteAverage} / 10",
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.justify,
        style: TextStyle(fontStyle: FontStyle.italic),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
      ),
    ];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget _backgroundPoster() {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Shimmer.fromColors(
            baseColor: Colors.grey[300],
            highlightColor: Colors.grey[100],
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.white,
            )),
        Image.network(
          "http://image.tmdb.org/t/p/w780/" + _movie.backdropPath,
          fit: BoxFit.cover,
        )
      ],
    );
  }
}

class _LoadingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _loadingPage(context);
  }

  Widget _loadingPage(BuildContext context) {
    return NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: 200.0,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                  background: Shimmer.fromColors(
                      baseColor: Colors.grey[300],
                      highlightColor: Colors.grey[100],
                      child: Container(
                        height: 200,
                        width: 200,
                        color: Colors.white,
                      ))),
            ),
          ];
        },
        body: Container(
          width: double.infinity,
          alignment: Alignment.topLeft,
          child: Shimmer.fromColors(
              baseColor: Colors.grey[300],
              highlightColor: Colors.grey[100],
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: 80.0,
                      height: 8.0,
                      color: Colors.white,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2.0),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [0, 1, 2, 3, 4, 5, 7, 8]
                          .map((_) =>
                          Column(
                            children: [
                              Container(
                                width: double.infinity,
                                height: 8.0,
                                color: Colors.white,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 2.0),
                              ),
                            ],
                          ))
                          .toList(),
                    ),
                  ],
                ),
              )),
        ));
  }
}
