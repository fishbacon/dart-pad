const String _shapesLibrarySourceCode =
"""
// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

/**
 * A surface on which to draw shapes.
 *
 * Use [addShape] and [addShapes] to add [Shape] objects to the surface and then use [draw] to draw the added shapes.
 */
class Surface {
  darthtml.CanvasElement _canvas;

  num width;
  num height;

  List<Shape> _shapes;

  Surface(this._canvas) {
    clearShapes();
  }

  void clearShapes() {
    _shapes = new List<Shape>();
  }

  /// Adds a shape on to the surface.
  void addShape(Shape shape) {
    _shapes.add(shape);
  }

  /// Adds shapes on to the surface.
  void addShapes(List<Shape> shapes) {
    _shapes.addAll(shapes);
  }

  /// Returns all shapes on the surface.
  List<Shape> allShapes() {
    return _shapes.toList();
  }

  /// Draws all added shapes on the surface.
  void draw() {
    var rect = _canvas.parent.client;
    width = rect.width;
    height = rect.height;

    _requestRedraw();
  }

  void _requestRedraw() {
    darthtml.window.requestAnimationFrame(_drawToContext);
  }

  void _drawToContext([_]) {
    var context = _canvas.context2D;
    _drawBackground(context);
    _drawShapes(context);
  }

  void _drawBackground(darthtml.CanvasRenderingContext2D context) {
    context.clearRect(0, 0, width, height);
  }

  void _drawShapes(darthtml.CanvasRenderingContext2D context) {
    _shapes.forEach((s) => s.draw(context));
  }
}

abstract class Shape {
  num x;
  num y;

  Shape(this.x, this.y);

  /// Draws this shape on a canvas.
  void draw(darthtml.CanvasRenderingContext2D context);

  moveRight(int i) {
    x = x + i;
  }

  moveLeft(int i) {
    x = x - i;
  }
}

class Diamond extends Shape {
  num width;
  num height;
  String color;

  Diamond(num x, num y, this.width, this.height, [String color]) : super(x, y) {
    if (color == null || color == "")
      this.color = "black";
    else
      this.color = color;
  }

  @override
  void draw(darthtml.CanvasRenderingContext2D context) {
    context..lineWidth = 0.5
           ..fillStyle = this.color
           ..strokeStyle = this.color
           ..beginPath()
           ..moveTo(x, y)
           ..lineTo(x+(width/2), y+(height/2))
           ..lineTo(x, y+height)
           ..lineTo(x-(width/2), y+(height/2))
           ..fill()
           ..closePath();
  }
}

class Circle extends Shape {
  num radius;
  String color;

  Circle(num x, num y, this.radius, [String color]) : super(x, y) {
    if (color == null || color == "")
      this.color = "black";
    else
      this.color = color;
  }

  @override
  void draw(darthtml.CanvasRenderingContext2D context) {
    context..lineWidth = 0.5
           ..fillStyle = this.color
           ..strokeStyle = this.color
           ..beginPath()
           ..arc(x, y, radius, 0, dartmath.PI * 2, false)
           ..fill()
           ..closePath();
  }
}

class Rectangle extends Shape {
  num height;
  num width;
  String color;

  Rectangle(num x, num y, this.width, this.height, [String color]) : super(x, y) {
    if (color == null || color == "")
      this.color = "black";
    else
      this.color = color;
  }

  @override
  void draw(darthtml.CanvasRenderingContext2D context) {
    context..lineWidth = 0.5
           ..fillStyle = this.color
           ..strokeStyle = this.color
           ..beginPath()
           ..rect(x, y, width, height)
           ..fill()
           ..closePath();
  }
}

/**
 * An [Animation] consits of zero or more [AnimationFrame]s. Each frame consists of a number of [Shape]s.
 *
 * - Use [animate] to draw each [AnimationFrame] on [surface] in succession.
 * - Use [animateForever] to animate indefinitely.
 */
class Animation {
  List<AnimationFrame> animationFrames;
  Surface surface;

  /// [surface] is the [Surface] which the animation is drawn on.
  Animation(this.surface) {
    animationFrames = new List<AnimationFrame>();
  }

  /// Adds an [AnimationFrame] to the the animation.
  void addAnimationFrame(AnimationFrame animationFrame) {
    animationFrames.add(animationFrame);
  }

  /// Draws each [AnimationFrame]s on [surface] in succession.
  void animate() {
    Iterator<AnimationFrame> frameIterator = animationFrames.iterator;

    void drawNextFrame() {
      if (frameIterator.moveNext()) {
        AnimationFrame frame = frameIterator.current;
        surface.clearShapes();
        surface.addShapes(frame.shapesInFrame);
        surface.draw();
        new dartasync.Timer(new Duration(seconds: 1), drawNextFrame);
      }
    }
    drawNextFrame();
  }

  /// Animate indefinitely.
  void animateForever() {
    Iterator<AnimationFrame> frameIterator = animationFrames.iterator;

    void drawNextFrame() {
      if (frameIterator.moveNext()) {
        AnimationFrame frame = frameIterator.current;
        surface.clearShapes();
        surface.addShapes(frame.shapesInFrame);
        surface.draw();
        new dartasync.Timer(new Duration(seconds: 1), drawNextFrame);
      } else {
        frameIterator = animationFrames.iterator;
        drawNextFrame();
      }
    }
    drawNextFrame();
  }
}

/**
 * Each frame consists of a number of [Shape]s.
 */
class AnimationFrame {
  List<Shape> shapesInFrame;

  AnimationFrame() {
    shapesInFrame = new List<Shape>();
  }

  void addShape(Shape shape) {
    shapesInFrame.add(shape);
  }

  void addShapes(List<Shape> shapes) {
    shapesInFrame.addAll(shapes);
  }
}
""";

// Unused
const String importsAndStuff =
"""
library shapes.base;

import 'dart:html' as darthtml;
import 'dart:math' as dartmath;
import 'dart:async' as dartasync;
""";

String shapesLibrarySourceCode() {
  return _shapesLibrarySourceCode;
}

int locateDefinition(String name, [String source]){
  var offset = -1;
  var function_re = new RegExp(r"\s"+"${name}" + r"\s*\(.*\)\s*\{");

  if(source == null){
    source = shapesLibrarySourceCode();
  }

  var m = function_re.firstMatch(source);
  if(m != null){
    offset = m.start+1;
  }

  return offset;
}
