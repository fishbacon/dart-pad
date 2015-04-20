// Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library dart_pad.sample;

final String dartCode = r'''
// Mandatory imports
import 'dart:html' as darthtml;
import 'dart:math' as dartmath;
import 'dart:async' as dartasync;
// End of mandatory imports

main() {
  //
  // This is a short introduction to Dart. Feel free to delete it when
  // you have read it.
  //

  // Anonymous functions, or lambdas, can be written like so:
  var greet = (thing){
    return "hello " + thing;
  };
  // Lambdas which are only one logical line can be defined using the "=>"
  // arrow syntax, making more compact.

  print(greet("world"));

  // Generics work just like in C# and Java:
  var dict = new Map<String, int>();

  // We can store integer values at string indexes:
  dict['99'] = 00;
  dict['world'] = 99;

  print(dict);

  // Optional typing is a central part of Dart.
  // This tutorial has already used both static and dynamic typing.

  // The two statements below are equivalent (for i and j).
  String i = "hello world from i";
  var j = "hello world from j";

  // Assigning an integer value to a String variable results in a warning:
  i = 1; // <- Warning
  j = 1;

  // But warnings do not stop the program from working.
  print(i);
  print(j);

  // The cascading operator ".." is a useful tool when working with lists:
  var l = [];
  l..add("These")
   ..add("are")
   ..add("words")
   ..add("in")
   ..add("a list");

  // This is equivalent to calling the 'add()' method on the 'l' variable five times.
  // It is a useful for setters and other mutating methods.

  // Concatenation is done automatically if bare strings are placed next
  // to each other.
  String sentence = "This " "sentence " "is "
    "constructed " "by " "concatenation.";

  print(sentence);

  // Finally Dart has string interpolation. Using $NAME or ${STATEMENT}.
  print("${l.join(' ')} and $i is a number.");

}

// Some practical information about classes:
class PracticalClass{
  // Underscores mean private, both for methods and fields.
  // It is not enforced but should be respected.
  int _i = 99;
  var _name;

  // getters and setters are regular function but typically defined as
  // one-liners using the arrow "=>" syntax.
  set i(int n) => _i = n;
  int get i => _i;
  // Both can be called like a field:
  // practicalInstance.i = 99
  // practicalInstance.i

  // Constructor writing has a convenient syntax "this" which allows you
  // to assign directly to a name when constructing.
  PracticalClass(this._name, int this._i);
}
''';

final String htmlCode = r'''
<canvas id="area" height="300px" width="400px"></canvas>
''';

final String cssCode = r'''
p {
  color: #888;
}
''';
