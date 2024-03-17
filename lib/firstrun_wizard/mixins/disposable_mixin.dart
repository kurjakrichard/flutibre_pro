import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:rxdart/rxdart.dart';

mixin DisposableMixin {
  final _dispose$ = PublishSubject<void>();

  Stream<void> get dispose$ => _dispose$.stream.asBroadcastStream();

  @mustCallSuper
  void dispose() {
    _dispose$
      ..add(null)
      ..close();
  }
}
