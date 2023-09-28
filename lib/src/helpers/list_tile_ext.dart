import 'dart:math';

import 'package:a_star_algorithm/src/models/tile.dart';

extension ListTileConverter on List<Tile> {
  List<Point<int>> toPoints() =>
      map((tile) => Point<int>(tile.point.x, tile.point.y)).toList();
}
