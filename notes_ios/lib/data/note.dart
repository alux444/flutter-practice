import 'package:notes_ios/data/note_history.dart';
import 'package:notes_ios/data/note_run.dart';
import 'package:notes_ios/data/rope_node.dart';

class Note {
  RopeNode? root;
  NoteHistory history;

  Note() : root = null, history = NoteHistory();

  bool get canUndo {
    return history.undo.isNotEmpty;
  }

  bool get canRedo {
    return history.redo.isNotEmpty;
  }

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

  String toText() {
    if (root == null) return '';
    return _nodeToText(root!);
  }

  String _nodeToText(RopeNode node) {
    if (node.run != null) {
      return node.run!.text;
    }
    String leftText = node.left != null ? _nodeToText(node.left!) : '';
    String rightText = node.right != null ? _nodeToText(node.right!) : '';
    return leftText + rightText;
  }

  void fromText(String text) {
    String currentText = toText();
    if (currentText == text) {
      return;
    }
    
    if (text.isEmpty) {
      if (root != null) {
        history.undo.add(root);
        history.redo.clear();
      }
      root = null;
      return;
    }
    history.undo.add(root);
    history.redo.clear();

    root = RopeNode.leaf(NoteRun(text: text, style: {TextStyle.regular}));
  }
}
