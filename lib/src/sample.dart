// Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library dart_pad.sample;

final String dartCode = r'''
import 'dart:html' as darthtml;
import 'dart:math' as dartmath;
import 'dart:async' as dartasync;

void main() {
  darthtml.CanvasElement canvas = darthtml.querySelector("#area");

  Surface surface = new Surface(canvas);
  Animation animation = new Animation(surface);

  AnimationFrame firstFrame = new AnimationFrame();
  firstFrame.addShape(new Rectangle(50, 100, 50, 50, "red"));
  animation.addAnimationFrame(firstFrame);

  AnimationFrame secondFrame = new AnimationFrame();
  secondFrame.addShape(new Rectangle(100, 100, 50, 50, "red"));
  animation.addAnimationFrame(secondFrame);

  AnimationFrame thirdFrame = new AnimationFrame();
  thirdFrame.addShape(new Rectangle(150, 100, 50, 50, "red"));
  animation.addAnimationFrame(thirdFrame);

  animation.animateForever();
}
''';

final String htmlCode = r'''
<h2>Dart Sample</h2>

<p id="output">Hello world!<p>
<canvas id="area" height="400px" width="400px"></canvas>
''';

final String cssCode = r'''
p {
  color: #888;
}
''';
