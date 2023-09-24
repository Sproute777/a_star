import 'dart:math';

import 'package:flutter/cupertino.dart';

/// Class used to represent each cell
enum TileType { free,  barrier, target }

class Tile {
  final Point<int> position;
  Tile? parent;
  final List<Tile> neighbors;
  final TileType type;
  final int _weight;
  /// distanse from current to start
  int g = 0;
  /// distanse from current to end
  int h = 0;
  /// total distance 
  int get f => g + h;
  int get weight => _weight + _weight;
  bool get isBarrier => type == TileType.barrier;
  bool get isFree => type == TileType.free;

  Tile(this.position, this.neighbors,
      {this.parent, this.type = TileType.free, int weight = 1}): _weight = weight;

  @override
  bool operator ==(covariant Tile other) {
    if (identical(this, other)) return true;

    return other.position == position;
  }

  @override
  int get hashCode {
    return position.hashCode ^ type.hashCode;
  }
  
  
  
}

