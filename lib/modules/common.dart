// Copyright (c) 2014, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library modules.common;

class Lines {
  List<int> _starts = [];

  Lines(String source) {
    List<int> units = source.codeUnits;
    for (int i = 0; i < units.length; i++) {
      if (units[i] == 10) _starts.add(i);
    }
  }

  /// Return the 0-based line number.
  int getLineForOffset(int offset) {
    for (int i = 0; i < _starts.length; i++) {
      if (offset <= _starts[i]) return i;
    }
    return _starts.length;
  }
}
