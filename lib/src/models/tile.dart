import 'package:a_star_algorithm/a_star_algorithm.dart';


class Tile {
  final AstarPoint point;
  Tile? parent;
  final List<Tile> neighbors;

  /// distanse from current to start
  int g = 0;

  /// distanse from current to end
  double h = 0;

  /// total distance
  double get f => g + h;
  bool get isBarrier => point is BarrierPoint;
  bool get isFree => point is WeightedPoint;
  bool get isStop => point is StopPoint;

  Tile(this.point, this.neighbors,
      {this.parent});

  @override
  bool operator ==(covariant Tile other) {
    if (identical(this, other)) return true;

    return other.point == point;
  }

  @override
  int get hashCode {
    return point.hashCode ^ point.hashCode;
  }
}
