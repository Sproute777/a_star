// /**
//  * canvas-astar.dart
//  * MIT licensed
//  *
//  * Created by Daniel Imms, http://www.growingwiththeweb.com
//  */

class Array2d<T> {
  late final List<List<T>> array;
  T? defaultValue;
  List<List<T>>? defaultArray;

  Array2d(int width, int height, {this.defaultValue, this.defaultArray}) {
    if (defaultValue != null) {
      array = <List<T>>[];
      this.width = width;
      this.height = height;
    }
    if (defaultArray != null) {
      array = defaultArray!;
    }
  }

  List<T> operator [](int x) => array[x];

  get first => array.first;
  get length => array.length;

  set width(int v) {
    while (array.length > v) {
      array.removeLast();
    }
    while (array.length < v) {
      final List<T> newList = [];
      if (array.isNotEmpty) {
        for (int y = 0; y < array.first.length; y++) {
          newList.add(defaultValue as T);
        }
      }
      array.add(newList);
    }
  }

  set height(int v) {
    while (array.first.length > v) {
      for (int x = 0; x < array.length; x++) {
        array[x].removeLast();
      }
    }
    while (array.first.length < v) {
      for (int x = 0; x < array.length; x++) {
        array[x].add(defaultValue as T);
      }
    }
  }
}
