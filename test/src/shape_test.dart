library dart_pad.shapes_test;

import 'package:dart_pad/src/shapes/shapes.dart';
import 'package:unittest/unittest.dart';

void defineTests() {
  group('function locater', () {
    test('get a function from place', () {
      expect(locateFunction("foo", "String foo() { }"), 8);
    });
  });
