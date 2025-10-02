import 'package:notes_ios/data/note_history.dart';
import 'package:notes_ios/data/rope_node.dart';

class Note {
  RopeNode? root;
  NoteHistory history;

  Note() : root = null, history = NoteHistory();

  void undo() {
    if (history.undo.isEmpty) {
      return;
    }
    history.redo.add(root);
    root = history.undo.removeLast();
  }

  void redo() {
    if (history.redo.isEmpty) {
      return;
    }
    history.undo.add(root);
    root = history.redo.removeLast();
  }
}
