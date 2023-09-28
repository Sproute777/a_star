import 'dart:math';

sealed class AstarPoint extends Point<int>{
  const AstarPoint(super.x, super.y, {this.weight = 1});
  final int weight;

@override
operator ==(other){
 if(other is AstarPoint && x == other.x && y == other.y){
  return true;
 } 
 return false;
}

  @override
  int get hashCode => weight ^ x ^ y ; 
  
}
final class WeightedPoint extends AstarPoint {
  const WeightedPoint(super.x, super.y, {super.weight = 1});
}

final class BarrierPoint extends AstarPoint {
  const BarrierPoint(super.x, super.y);
}

final class StopPoint extends AstarPoint {
  const StopPoint(super.x, super.y,{super.weight = 1});
}
