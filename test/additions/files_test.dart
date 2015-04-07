library additions.files_test;

import 'package:dart_pad/additions/files.dart';
import 'package:unittest/unittest.dart';

void defineTests() {
    group('files', () {
      test('Source file name', () {
        expect(getSourceFileName("a/b/c/d.efg"), "d");
      });
      test('No path, file name', () {
        expect(getSourceFileName("a.bcd"), "a");
      });
      test('No extension, file name', () {
        expect(getSourceFileName("a/b/c/d"), "d");
      });
      test('Name contains spaces.', () {
        expect(getSourceFileName("a/b/c/s p a c es.d"), "s p a c es");
      });
    });
}
