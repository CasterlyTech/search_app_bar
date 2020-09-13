import 'dart:core';

abstract class Searcher<T> {
  Future<List<T>> search(String query);
}
