import 'dart:core';

abstract class Searcher<T> {
  Function(List<T>) get onDataFiltered;
  Future<List<T>> get data;
}
