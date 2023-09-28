import 'dart:math';

import 'package:a_star_algorithm/a_star_algorithm.dart';
import 'package:a_star_algorithm/src/models/tile.dart';

extension GreateGridWithBarrierExt on TileGrid{
  /// Method that create the grid using barriers
  List<List<Tile>> createGridWithBarriers() {
    List<List<Tile>> newGrid = [];
    List.generate(columns, (x) {
      List<Tile> rowList = [];
      List.generate(rows, (y) {
        final indexPoint = points.indexWhere((p)=> p.x == x && p.y == y);
        final point = indexPoint == -1 ? WeightedPoint(x, y) : points[indexPoint];
        rowList.add(
          Tile(
            point,
            [],
          ),
        );
      });
      newGrid.add(rowList);
    });
    return newGrid;
  }
}
