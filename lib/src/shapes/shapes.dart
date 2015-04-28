const String _staticShapesLibrarySourceCode =
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

  Surface() {
    _canvas = darthtml.querySelector("#area");
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
    context.save();

    context.clearRect(0, 0, width, height);

    context..fillStyle = "white"
           ..fillRect(0, 0, width, height)
           ..strokeStyle = "black"
           ..setLineDash([2,2]);

    for (int i = 0; i <= width; i = i + 50) {
      context..beginPath()
             ..moveTo(i, 0)
             ..lineTo(i, height)
             ..stroke()
             ..closePath();
    }
    for (int i = 0; i <= height; i = i + 50) {
      context..beginPath()
             ..moveTo(0, i)
             ..lineTo(width, i)
             ..stroke()
             ..closePath();
    }

    context.restore();
  }

  void _drawShapes(darthtml.CanvasRenderingContext2D context) {
    _shapes.forEach((s) {
      context.save();
      s.draw(context);
      context.restore();
    });
  }
}

abstract class Shape {
  num x;
  num y;

  /// [x] and [y] refer to the (x,y) coordinates of the center of the shape
  Shape(this.x, this.y);

  /// Draws this shape on a canvas.
  void draw(darthtml.CanvasRenderingContext2D context);

  void _drawCenterMark(darthtml.CanvasRenderingContext2D context) {
    context.save();

    context..beginPath()
           ..fillStyle = "black"
           ..arc(x, y, 4, 0, dartmath.PI * 2, false)
           ..fill()
           ..closePath();

    context.restore();
  }
}

class Diamond extends Shape {
  num width;
  num height;
  String color;

  /**
   * [x] and [y] refer to the (x,y) coordinates of the center of the shape.
   * The size of the shape is specified using [width] and [height].
   * [color] can be a string like "green", "red", "blue" etc.
   */
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
           ..moveTo(x-(width/2), y)
           ..lineTo(x, y-(height/2))
           ..lineTo(x+(width/2), y)
           ..lineTo(x, y+(height/2))
           ..fill()
           ..closePath();
    _drawCenterMark(context);
  }
}

class Circle extends Shape {
  num radius;
  String color;

  /**
   * [x] and [y] refer to the (x,y) coordinates of the center of the shape.
   * Size of the circle is specified using [radius].
   * [color] can be a string like "green", "red", "blue" etc.
   */
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
    _drawCenterMark(context);
  }
}

class Rectangle extends Shape {
  num height;
  num width;
  String color;

  /**
   * [x] and [y] refer to the (x,y) coordinates of the center of the shape.
   * The size of the shape is specified using [width] and [height].
   * [color] can be a string like "green", "red", "blue" etc.
   */
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
           ..moveTo(x-(width/2), y-(height/2))
           ..lineTo(x+(width/2), y-(height/2))
           ..lineTo(x+(width/2), y+(height/2))
           ..lineTo(x-(width/2), y+(height/2))
           ..fill()
           ..closePath();
    _drawCenterMark(context);
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

const String _dynamicShapesLibrarySourceCode =
"""
// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

/**
 * A surface on which to draw shapes.
 *
 * Use [addShape] and [addShapes] to add [Shape] objects to the surface and then use [draw] to draw the added shapes.
 */
class Surface {
  var _canvas;

  var width;
  var height;

  var _shapes;

  Surface() {
    _canvas = darthtml.querySelector("#area");
    clearShapes();
  }

  void clearShapes() {
    _shapes = new List();
  }

  /// Adds a shape on to the surface.
  void addShape(var shape) {
    _shapes.add(shape);
  }

  /// Adds shapes on to the surface.
  void addShapes(var shapes) {
    _shapes.addAll(shapes);
  }

  /// Returns all shapes on the surface.
  dynamic allShapes() {
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

  void _drawBackground(var context) {
    context.save();

    context.clearRect(0, 0, width, height);

    context..fillStyle = "white"
           ..fillRect(0, 0, width, height)
           ..strokeStyle = "black"
           ..setLineDash([2,2]);

    for (var i = 0; i <= width; i = i + 50) {
      context..beginPath()
             ..moveTo(i, 0)
             ..lineTo(i, height)
             ..stroke()
             ..closePath();
    }
    for (var i = 0; i <= height; i = i + 50) {
      context..beginPath()
             ..moveTo(0, i)
             ..lineTo(width, i)
             ..stroke()
             ..closePath();
    }

    context.restore();
  }

  void _drawShapes(var context) {
    _shapes.forEach((s) {
      context.save();
      s.draw(context);
      context.restore();
    });
  }
}

abstract class Shape {
  var x;
  var y;

  /// [x] and [y] refer to the (x,y) coordinates of the center of the shape
  Shape(this.x, this.y);

  /// Draws this shape on a canvas.
  void draw(var context);

  void _drawCenterMark(var context) {
    context.save();

    context..beginPath()
           ..fillStyle = "black"
           ..arc(x, y, 4, 0, dartmath.PI * 2, false)
           ..fill()
           ..closePath();

    context.restore();
  }
}

class Diamond extends Shape {
  var width;
  var height;
  var color;

  /**
   * [x] and [y] refer to the (x,y) coordinates of the center of the shape.
   * The size of the shape is specified using [width] and [height].
   * [color] can be a string like "green", "red", "blue" etc.
   */
  Diamond(var x, var y, this.width, this.height, [var color]) : super(x, y) {
    if (color == null || color == "")
      this.color = "black";
    else
      this.color = color;
  }

  @override
  void draw(var context) {
    context..lineWidth = 0.5
           ..fillStyle = this.color
           ..strokeStyle = this.color
           ..beginPath()
           ..moveTo(x-(width/2), y)
           ..lineTo(x, y-(height/2))
           ..lineTo(x+(width/2), y)
           ..lineTo(x, y+(height/2))
           ..fill()
           ..closePath();
    _drawCenterMark(context);
  }
}

class Circle extends Shape {
  var radius;
  var color;

  /**
   * [x] and [y] refer to the (x,y) coordinates of the center of the shape.
   * Size of the circle is specified using [radius].
   * [color] can be a string like "green", "red", "blue" etc.
   */
  Circle(var x, var y, this.radius, [var color]) : super(x, y) {
    if (color == null || color == "")
      this.color = "black";
    else
      this.color = color;
  }

  @override
  void draw(var context) {
    context..lineWidth = 0.5
           ..fillStyle = this.color
           ..strokeStyle = this.color
           ..beginPath()
           ..arc(x, y, radius, 0, dartmath.PI * 2, false)
           ..fill()
           ..closePath();
    _drawCenterMark(context);
  }
}

class Rectangle extends Shape {
  var height;
  var width;
  var color;

  /**
   * [x] and [y] refer to the (x,y) coordinates of the center of the shape.
   * The size of the shape is specified using [width] and [height].
   * [color] can be a string like "green", "red", "blue" etc.
   */
  Rectangle(var x, var y, this.width, this.height, [var color]) : super(x, y) {
    if (color == null || color == "")
      this.color = "black";
    else
      this.color = color;
  }

  @override
  void draw(var context) {
    context..lineWidth = 0.5
           ..fillStyle = this.color
           ..strokeStyle = this.color
           ..beginPath()
           ..moveTo(x-(width/2), y-(height/2))
           ..lineTo(x+(width/2), y-(height/2))
           ..lineTo(x+(width/2), y+(height/2))
           ..lineTo(x-(width/2), y+(height/2))
           ..fill()
           ..closePath();
    _drawCenterMark(context);
  }
}

/**
 * An [Animation] consits of zero or more [AnimationFrame]s. Each frame consists of a number of [Shape]s.
 *
 * - Use [animate] to draw each [AnimationFrame] on [surface] in succession.
 * - Use [animateForever] to animate indefinitely.
 */
class Animation {
  var animationFrames;
  var surface;

  /// [surface] is the [Surface] which the animation is drawn on.
  Animation(this.surface) {
    animationFrames = new List();
  }

  /// Adds an [AnimationFrame] to the the animation.
  void addAnimationFrame(var animationFrame) {
    animationFrames.add(animationFrame);
  }

  /// Draws each [AnimationFrame]s on [surface] in succession.
  void animate() {
    var frameIterator = animationFrames.iterator;

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

  /// Animate indefinitely.
  void animateForever() {
    var frameIterator = animationFrames.iterator;

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

/**
 * Each frame consists of a number of [Shape]s.
 */
class AnimationFrame {
  var shapesInFrame;

  AnimationFrame() {
    shapesInFrame = new List();
  }

  void addShape(var shape) {
    shapesInFrame.add(shape);
  }

  void addShapes(var shapes) {
    shapesInFrame.addAll(shapes);
  }
}
""";

const String _staticInitialCode =
"""
// Mandatory imports
import 'dart:html' as darthtml;
import 'dart:math' as dartmath;
import 'dart:async' as dartasync;
// End of mandatory imports

main(){
  Surface surface = new Surface();
  // Add your code here ...
  surface.draw();
}
""";

const String _dynamicInitialCode =
"""
// Mandatory imports
import 'dart:html' as darthtml;
import 'dart:math' as dartmath;
import 'dart:async' as dartasync;
// End of mandatory imports

main(){
  var surface = new Surface();
  // Add your code here ...
  surface.draw();
}
""";


const bool useStaticVersion = true;

String shapesInitialCode(){
  if (useStaticVersion)
    return _staticInitialCode;

  return _dynamicInitialCode;
}

String shapesLibrarySourceCode() {
  if (useStaticVersion)
    return _staticShapesLibrarySourceCode;

  return _dynamicShapesLibrarySourceCode;
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
