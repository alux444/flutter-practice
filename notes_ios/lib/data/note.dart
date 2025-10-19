import 'package:flutter/cupertino.dart';
import 'package:notes_ios/data/note_history.dart';
import 'package:notes_ios/data/note_span.dart';

class Note {
  List<NoteSpan> spans;
  NoteHistory history;

  Note() : spans = [], history = NoteHistory();

  bool get canUndo => history.undo.isNotEmpty;
  bool get canRedo => history.redo.isNotEmpty;

  void undo() {
    if (!canUndo) return;
    history.redo.add(List.from(spans));
    spans = history.undo.removeLast();
  }

  void redo() {
    if (!canRedo) return;
    history.undo.add(List.from(spans));
    spans = history.redo.removeLast();
  }

  void fromText(String text) {
    if (text.isEmpty) {
      spans = [];
      return;
    }
    spans = [NoteSpan(text: text)];
  }

  String toText() => spans.map((span) => span.text ?? '').join();

  TextSpan toTextSpan() {
    return TextSpan(
      children: spans.map((span) {
        return TextSpan(
          text: span.text,
          style: TextStyle(
            fontWeight: span.isBold ? FontWeight.bold : null,
            fontStyle: span.isItalic ? FontStyle.italic : null,
            decoration: span.isUnderlined ? TextDecoration.underline : null,
          ),
        );
      }).toList(),
    );
  }

  void fromTextSpans(List<NoteSpan> newSpans) {
    if (spans == newSpans) return;
    history.undo.add(List.from(spans));
    history.redo.clear();
    spans = newSpans;
  }
}
