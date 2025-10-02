import 'package:notes_ios/data/note_run.dart';

class RopeNode {
  int weight; // number of characters in the left subtree
  RopeNode? left;
  RopeNode? right;
  NoteRun? run; // for leaf node

  RopeNode.leaf(this.run)
    : weight = run!.text.length,
      left = null,
      right = null;

  RopeNode.internal(this.left, this.right)
    : run = null,
      weight = (left?.length ?? 0);

  int get length {
    if (run != null) {
      return run!.text.length;
    }
    return (left?.length ?? 0) + (right?.length ?? 0);
  }
}
