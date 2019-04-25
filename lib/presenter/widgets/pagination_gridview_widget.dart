import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

/// Signature for a function that returns a Future List of type 'T' i.e. list
/// of items in a particular page that is being asynchronously called.
///
/// Used by [PaginationGrid] widget.
typedef PaginationBuilder<T> = Future<List<T>> Function(int currentListSize);

/// Signature for a function that creates a widget for a given item of type 'T'.
typedef ItemWidgetBuilder<T> = Widget Function(int index, T item);

/// A scrollable list which implements pagination.
///
/// When scrolled to the end of the list [PaginationGrid] calls [pageBuilder] which
/// must be implemented which returns a Future List of type 'T'.
///
/// [itemBuilder] creates widget instances on demand.
class PaginationGrid<T> extends StatefulWidget {
  /// Creates a scrollable, paginated, linear array of widgets.
  ///
  /// The arguments [pageBuilder], [itemBuilder] must not be null.
  PaginationGrid(
      {Key key,
      @required this.pageBuilder,
      @required this.itemBuilder,
      this.scrollDirection = Axis.vertical,
      this.progress,
      this.onError,
      this.reverse = false,
      this.controller,
      this.primary,
      this.physics,
      this.padding,
      this.itemExtent,
      this.cacheExtent,
      this.semanticChildCount,
      this.mainAxisSpacing = 0.0,
      this.crossAxisSpacing = 0.0,
      this.childAspectRatio = 1.0})
      : assert(pageBuilder != null),
        assert(itemBuilder != null),
        super(key: key);

  /// Called when the list scrolls to an end
  ///
  /// Function should return Future List of type 'T'
  final PaginationBuilder<T> pageBuilder;

  /// Called to build children for [PaginationGrid]
  ///
  /// Function should return a widget
  final ItemWidgetBuilder<T> itemBuilder;

  /// Scroll direction of list view
  final Axis scrollDirection;

  /// When non-null [progress] widget is called to show loading progress
  final Widget progress;

  /// Handle error returned by the Future implemented in [pageBuilder]
  final Function(dynamic error) onError;

  final bool reverse;
  final ScrollController controller;
  final bool primary;
  final ScrollPhysics physics;
  final bool shrinkWrap = false;
  final EdgeInsetsGeometry padding;
  final double itemExtent;
  final bool addAutomaticKeepAlives = true;
  final bool addRepaintBoundaries = true;
  final bool addSemanticIndexes = true;
  final double cacheExtent;
  final int semanticChildCount;
  final double childAspectRatio;
  final double crossAxisSpacing;
  final double mainAxisSpacing;

  @override
  _PaginationGridState<T> createState() => _PaginationGridState<T>();
}

class _PaginationGridState<T> extends State<PaginationGrid<T>> {
  final List<T> _list = List();
  bool _isLoading = false;
  bool _isEndOfList = false;

  void fetchMore() {
    if (!_isLoading) {
      setState(() {
        _isLoading = true;
      });

      widget.pageBuilder(_list.length).then((list) {
        _isLoading = false;
        if (list.isEmpty) {
          _isEndOfList = true;
        }
        setState(() {
          _list.addAll(list);
        });
      }).catchError((error) {
        setState(() {
          _isEndOfList = true;
        });
        print(error);
        if (widget.onError != null) {
          widget.onError(error);
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchMore();
  }

  @override
  Widget build(BuildContext context) {
    return _buildGridView();
  }

  Widget _buildGridView() {
    return NotificationListener(
        onNotification: (ScrollNotification scrollInfo) {
          if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
            fetchMore();
          }
        },
        child: Stack(
          children: <Widget>[
            StaggeredGridView.countBuilder(
              itemCount: _list.length+1,
              itemBuilder: (context, position) {
                if(position < _list.length){
                  return widget.itemBuilder(position, _list[position]);
                }else{
                  return widget.progress ?? _defaultLoading();
                }
              },
             crossAxisCount: 8,
              staggeredTileBuilder: (int index) {
                if (index < _list.length) {
                  return StaggeredTile.count(4, 4);
                }else{
                  return StaggeredTile.count(8, 1);
                }
              },
            )
          ],
        ));
  }
}

Widget _defaultLoading() {
  return Align(
    child: SizedBox(
      height: 40,
      width: 40,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: CircularProgressIndicator(),
      ),
    ),
  );
}
