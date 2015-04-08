library dart_pad.shapes_test;

import 'package:dart_pad/src/shapes/shapes.dart';
import 'package:unittest/unittest.dart';

void defineTests() {
  group('function found', () {
    test('from place with space after paren', () {
      expect(
          locateDefinition("foo", "String foo() { }"),
          7);
    });

    test('from place no space', () {
      expect(
          locateDefinition("foo", "String foo(){ }"),
          7);
    });

    test('from place with space before paren', () {
      expect(
          locateDefinition("foo", "String foo (){ }"),
          7);
    });

    test('get a function with arguments', () {
      expect(
          locateDefinition("foo", "String foo(int b) { }"),
          7);
    });

    test('function same as variable after', () {
      expect(
          locateDefinition("foo", "String foo() { var foo; } "),
          7);
    });

    test('function same as variable before', () {
      expect(
          locateDefinition("foo", "var foo; String foo() { }"),
          16);
    });

    test('check on actual shapes source', () {
      expect(
          locateDefinition("Diamond") != -1, true);
    });
  });

  group('function not found', () {
    test('', () {
      expect(
          locateDefinition("bar", "String foo() { }"),
          -1);
    });

    test('var available', () {
      expect(
          locateDefinition("bar", "var bar; String foo() { }"),
          -1);
    });

    test('compound available', () {
      expect(
          locateDefinition("bar", "var bar; String foobar() { }"),
          -1);
    });
  });

}
