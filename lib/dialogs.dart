// Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library dartpad.dialogs;

import 'dart:async';
import 'dart:html';

import 'elements/elements.dart';
import 'core/keys.dart';

/**
 * Show an OK / Cancel dialog, and return the option that the user selected.
 */
Future<bool> confirm(String title, String message,
    {String okText: 'OK', String cancelText: 'Cancel'}) {

  OkCancelDialog dialog = new OkCancelDialog(
      title, message, okText: okText, cancelText: cancelText);
  dialog.show();
  return dialog.future;
}

class OkCancelDialog extends DDialog {
  Completer<bool> _completer = new Completer();

  OkCancelDialog(String title, String message,
      {String okText: 'OK', String cancelText: 'Cancel'}) : super(title: title) {
    content.add(new ParagraphElement()..text = message);

    DButton cancelButton = buttonArea.add(new DButton.button(text: cancelText));
    buttonArea.add(new SpanElement()..attributes['flex'] = '');
    cancelButton.onClick.listen((_) => hide());

    DButton okButton = buttonArea.add(
        new DButton.button(text: okText, classes: 'default'));
    okButton.onClick.listen((_) {
      _completer.complete(true);
      hide();
    });
  }

  void hide() {
    if (!_completer.isCompleted) _completer.complete(false);

    super.hide();
  }

  Future<bool> get future => _completer.future;
}

class KeysDialog extends DDialog {

  Map<Action, Set<String>> keyMap;

  KeysDialog(this.keyMap) : super(title: 'Keyboard shortcuts') {
    element.classes.toggle('keys-dialog', true);
    content.add(keyMapToHtml);
  }

  DListElement get keyMapToHtml {
    DListElement dl = new DListElement();
    keyMap.forEach((action, keys) {
      String string = "";
      keys.forEach((key) {
        if (makeKeyPresentable(key) != null) {
          string += "<span>${makeKeyPresentable(key)}</span>";
        }
      });
      dl.innerHtml += "<dt>$action</dt><dd>${string}</dd>";
    });
    return dl;
  }

  // TODO: expose options
  //  DListElement get optionMapToHtml {
  //    DListElement dl = new DListElement();
  //    optionMap.forEach((key, value) {
  //      dl.innerHtml += "<dt>${capitalize(key.replaceAll("_"," "))}</dt>"
  //      '<dd><input type="checkbox" id="$key" ${options.getValueBool(key) ? "checked" : ""}></dd>';
  //    });
  //    return dl;
  //  }
}
