import 'dart:async';

/**
 * dataloader for pages.
 */
abstract class Loader<T> {
  Future<List<T>> loadData();
}