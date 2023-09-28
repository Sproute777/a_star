import 'dart:math';

import 'package:a_star_algorithm/a_star_algorithm.dart';
import 'package:a_star_algorithm/src/models/tile.dart';

// what this needed
// extension GreateGridWithFreeExt on AStar {
//   /// Method that create the grid using barriers
//   List<List<Tile>> createGridWithFree(
//     List<Point<int>> freeSpaces,
//   ) {
//     List<List<Tile>> newGrid = [];
//     List.generate(columns, (x) {
//       List<Tile> rowList = [];
//       List.generate(rows, (y) {
//         // any more faster then where
//         bool isFreeSpace = freeSpaces.any((element) {
//           return element.x == x && element.y == y;
//         });
//         final point = isFreeSpace ? WeightedPoint(x, y) : BarrierPoint(x, y);

//         rowList.add(
//           Tile(
//             point,
//             [],
//           ),
//         );
//       });
//       newGrid.add(rowList);
//     });
//     return newGrid;
//   }
// }
