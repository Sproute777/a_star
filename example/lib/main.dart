import 'dart:math';

import 'package:a_star_algorithm/a_star_algorithm.dart';
import 'package:flutter/material.dart';
import 'package:timing/timing.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

enum TypeInput {
  START_POINT,
  BARRIERS,
  TARGETS,
  WATER,
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TypeInput _typeInput = TypeInput.START_POINT;

  // benchmark timing
  AsyncTimeTracker? timeTracker;

  bool _showDoneList = true;
  bool _withDiagonals = true;
  AstarPoint start = WeightedPoint(0, 0);
  List<Tile> tiles = [];
  final List<AstarPoint> points = [];
  List<WeightedPoint> river = List.generate(
    17,
    (index) => WeightedPoint(8, index, weight: 5),
  );
 List<BarrierPoint> barriers = List.generate(
    4,
    (index) => BarrierPoint(index, 4),
  );
  List<Point<int>> targets = [];
  int rows = 20;
  int columns = 20;

  @override
  void initState() {
    super.initState();
    List.generate(rows, (y) {
      List.generate(columns, (x) {
        final point = WeightedPoint(x, y);
        tiles.add(
          Tile(point),
        );
      });
    });
    points..addAll(river)..addAll(barriers);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('A* double tap to find path'),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 40,
            child: Row(
              children: [
                if (_showDoneList)
                  Text(
                    'done list ${tiles.where((i) => i.done).length},\npath length ${tiles.where((i) => i.selected).length} ${_getBenchmark()}',
                  )
              ],
            ),
          ),
          Row(
            children: [
              Text('with diagonals'),
              Switch(
                value: _withDiagonals,
                onChanged: (value) {
                  setState(() {
                    _withDiagonals = value;
                  });
                },
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _typeInput = TypeInput.START_POINT;
                    });
                  },
                  style: ButtonStyle(
                    backgroundColor: _getColorSelected(TypeInput.START_POINT),
                  ),
                  child: Text('START'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _typeInput = TypeInput.WATER;
                    });
                  },
                  style: ButtonStyle(
                    backgroundColor: _getColorSelected(TypeInput.WATER),
                  ),
                  child: Text('WATER'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _typeInput = TypeInput.BARRIERS;
                    });
                  },
                  style: ButtonStyle(
                    backgroundColor: _getColorSelected(TypeInput.BARRIERS),
                  ),
                  child: Text('BARRIES'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _typeInput = TypeInput.TARGETS;
                    });
                  },
                  style: ButtonStyle(
                    backgroundColor: _getColorSelected(TypeInput.TARGETS),
                  ),
                  child: Text('TARGETS'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      points.clear();
                      _cleanTiles();
                    });
                  },
                  child: Text('CLEAN'),
                )
              ],
            ),
          ),
          Expanded(
            child: GridView.count(
              crossAxisCount: columns,
              children: tiles.map((e) {
                return _buildItem(e);
              }).toList(),
            ),
          ),
          Row(
            children: [
              Switch(
                value: _showDoneList,
                onChanged: (value) {
                  setState(() {
                    _showDoneList = value;
                  });
                },
              ),
              Text('Show done list')
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildItem(Tile e) {
    final index =
        points.indexWhere((i) => i.x == e.position.x && i.y == e.position.y);
    Color color = Colors.white;
    String text = '1';
    if (index != -1) {
      final point = points[index];
      switch (point) {
        case WeightedPoint(weight: 5):
          text = '5';
          color = Colors.blue[100]!;
        case WeightedPoint():
        case StopPoint():
          text = '${point.weight}';
        case BarrierPoint():
          text = 'barrier';
          color = Colors.red;
      }
    }

    if (e.done) {
      color = Colors.black.withOpacity(.2);
    }
    if (e.selected && _showDoneList) {
      color = Colors.green.withOpacity(.7);
    }
    if (targets.contains(e.position)) {
      color = Colors.purple.withOpacity(.7);
      text = text + '\ntarget';
    }

    if (e.position == start) {
      color = Colors.yellow.withOpacity(.7);
      text = text + '\nstart';
    }

    return Ink(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black54, width: 1.0),
        color: color,
      ),
      height: 10,
      child: InkWell(
        child: Text(
          text,
          style: TextStyle(fontSize: 9, color: Colors.black),
        ),
        onDoubleTap: () => _start(e.position),
        onTap: () {
          if (_typeInput == TypeInput.START_POINT) {
            start = WeightedPoint(e.position.x, e.position.y);
          }

          if (_typeInput == TypeInput.BARRIERS) {
            final pointIndex = points
                .indexWhere((i) => i.x == e.position.x && i.y == e.position.y);
            switch (pointIndex) {
              case -1:
                continue addBarrier;
              case int():
                final point = points[pointIndex];
                if (point is BarrierPoint) {
                  points.removeAt(pointIndex);
                } else {
                  continue addBarrier;
                }
              // it's not dead
              addBarrier:
              // ignore: dead_code
              default:
                points.add(BarrierPoint(e.position.x, e.position.y));
            }
          }

          if (_typeInput == TypeInput.WATER) {
            final pointIndex = points
                .indexWhere((i) => i.x == e.position.x && i.y == e.position.y);
            switch (pointIndex) {
              case -1:
                continue addWater;
              case int():
                final point = points[pointIndex];
                if (point case WeightedPoint(weight: 5)) {
                  points.removeAt(pointIndex);
                } else {
                  continue addWater;
                }
              // it's not dead
              addWater:
              // ignore: dead_code
              default:
                points
                    .add(WeightedPoint(e.position.x, e.position.y, weight: 5));
            }
          }
          setState(() {});
        },
      ),
    );
  }

  String _getBenchmark() {
    if (timeTracker == null) return '';
    if (!timeTracker!.isFinished) return '';
    final duration = timeTracker!.duration;
    return 'benchmark: inMicro: ${duration.inMicroseconds} inMilli: ${duration.inMilliseconds}';
  }

  MaterialStateProperty<Color> _getColorSelected(TypeInput input) {
    return MaterialStateProperty.all(
      _typeInput == input ? _getColorByType(input) : Colors.grey,
    );
  }

  Color _getColorByType(TypeInput input) {
    switch (input) {
      case TypeInput.START_POINT:
        return Colors.yellow;
      case TypeInput.BARRIERS:
        return Colors.red;
      case TypeInput.TARGETS:
        return Colors.purple;
      case TypeInput.WATER:
        return Colors.blue;
    }
  }

  void _start(AstarPoint target) {
    _cleanTiles();
    List<Point<int>> done = [];
    late Iterable<Point<int>> result;

    timeTracker = AsyncTimeTracker()
      ..track(() {
        result = TileGrid(
                rows: rows,
                columns: columns,
                start: start,
                end: target,
                withDiagonal: _withDiagonals,
                points: points)
            .findThePath(doneList: (doneList) {
          done = doneList;
        });
      });

    for (var element in result) {
      done.remove(element);
    }

    done.remove(start);

    setState(() {
      for (var element in tiles) {
        element.selected = result.any((r) {
          return r.x == element.position.x && r.y == element.position.y;
        });

        if (_showDoneList) {
          element.done = done.where((r) {
            return r == element.position;
          }).isNotEmpty;
        }
      }
    });
  }

  void _cleanTiles() {
    for (var element in tiles) {
      element.selected = false;
      element.done = false;
    }
  }
}

class Tile {
  final AstarPoint position;
  bool selected = false;
  bool done = false;

  Tile(this.position);
}
