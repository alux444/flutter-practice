import 'package:notes_ios/data/note_history.dart';

class Note {
  List<String> lines;
  NoteHistory history;

  Note() : lines = [], history = NoteHistory();

  bool get canUndo => history.undo.isNotEmpty;
  bool get canRedo => history.redo.isNotEmpty;

  void undo() {
    if (!canUndo) return;
    history.redo.add(List.from(lines));
    lines = history.undo.removeLast();
  }

  void redo() {
    if (!canRedo) return;
    history.undo.add(List.from(lines));
    lines = history.redo.removeLast();
  }

  String toText() => lines.join('\n');

  void fromText(String text) {
    if (toText() == text) return;

    history.undo.add(List.from(lines));
    history.redo.clear();
    lines = text.isEmpty ? [] : text.split('\n');
  }
}
