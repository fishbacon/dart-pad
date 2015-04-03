const String _shapesLibrarySourceCode =
"""
// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

class Surface {
  darthtml.CanvasElement _canvas;

  num width;
  num height;

  List<Shape> _shapes;

  Surface(this._canvas) {
    clearShapes();
  }

  void draw() {
    var rect = _canvas.parent.client;
    width = rect.width;
    height = rect.height;

    requestRedraw();
  }

  void requestRedraw() {
    darthtml.window.requestAnimationFrame(drawToContext);
  }

  void drawToContext([_]) {
    var context = _canvas.context2D;
    drawBackground(context);
    drawShapes(context);
  }

  void drawBackground(darthtml.CanvasRenderingContext2D context) {
    context.clearRect(0, 0, width, height);
  }

  void drawShapes(darthtml.CanvasRenderingContext2D context) {
    _shapes.forEach((s) => s.draw(context));
  }

  void clearShapes() {
    _shapes = new List<Shape>();
  }

  void addShape(Shape shape) {
    _shapes.add(shape);
  }

  void addShapes(List<Shape> shapes) {
    _shapes.addAll(shapes);
  }

  List<Shape> allShapes() {
    return _shapes.toList();
  }
}

abstract class Shape {
  num x;
  num y;

  Shape(this.x, this.y);

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

  Diamond(x, y, this.width, this.height, [color]) : super(x, y) {
    if (color == null || color == "")
      this.color = "black";
    else
      this.color = color;
  }

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

  Circle(x, y, this.radius, [color]) : super(x, y) {
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

  Rectangle(x, y, this.width, this.height, [color]) : super(x, y) {
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

class Animation {
  List<AnimationFrame> animationFrames;
  Surface surface;

  Animation(Surface this.surface) {
    animationFrames = new List<AnimationFrame>();
  }

  void addAnimationFrame(AnimationFrame animationFrame) {
    animationFrames.add(animationFrame);
  }

  void animate() {
    Iterator frameIterator = animationFrames.iterator;

    void drawNextFrame() {
      if (frameIterator.moveNext()) {
        var frame = frameIterator.current;
        surface.clearShapes();
        surface.addShapes(frame.shapesInFrame);
        surface.draw();
        new dartasync.Timer(new Duration(seconds: 1), drawNextFrame);
      }
    }
    drawNextFrame();
  }

  void animateForever() {
    Iterator frameIterator = animationFrames.iterator;

    void drawNextFrame() {
      if (frameIterator.moveNext()) {
        var frame = frameIterator.current;
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

import 'dart:html';
import 'dart:math' as dartmath;
import 'dart:async' as dartasync;
""";

String shapesLibrarySourceCode() {
  return _shapesLibrarySourceCode;
}
