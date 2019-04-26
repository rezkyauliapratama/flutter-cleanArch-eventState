import 'package:flutter/material.dart';
import 'package:movies_db_bloc/data/models/api/list_movies_schema.dart';
import 'package:movies_db_bloc/data/models/api/movie_schema.dart';
import 'package:movies_db_bloc/domain/blocs/movies_bloc.dart';
import 'package:movies_db_bloc/domain/providers/base_provider.dart';
import 'package:movies_db_bloc/presenter/widgets/pagination_gridview_widget.dart';

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
        body: PaginationGrid(
          pageBuilder: (int currentListSize) {
            return moviesBloc.fetchMovies();
          },
          itemBuilder: (int index, Movies item) {
            return moviesListTile(item);
          }, crossAxisCount: 2,
        ));
  }

  Widget moviesListTile(Movies item) {
    List<Widget> children = <Widget>[
      ClipRect(
        clipper: _SquareClipper(),
        child: Image.network(
            "http://image.tmdb.org/t/p/w185/" + item.posterPath,
            fit: BoxFit.cover),
      ),
      Container(
        decoration: _buildGradientBackground(),
        padding: const EdgeInsets.only(
          bottom: 16.0,
          left: 16.0,
          right: 16.0,
        ),
        child: _buildTextualInfo(item),
      ),
    ];

    return Card(
      child: Stack(
        fit: StackFit.expand,
        children: children,
      ),
    );
  }

  BoxDecoration _buildGradientBackground() {
    return const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
        stops: <double>[0.0, 0.7, 0.7],
        colors: <Color>[
          Colors.black,
          Colors.transparent,
          Colors.transparent,
        ],
      ),
    );
  }

  Widget _buildTextualInfo(Movies movieCard) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          movieCard.title,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 16.0,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 4.0),
        Text(
          movieCard.voteAverage.toString(),
          style: const TextStyle(
            fontSize: 12.0,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }
}

class _SquareClipper extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) {
    return new Rect.fromLTWH(0.0, 0.0, size.width, size.width);
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) {
    return false;
  }
}
