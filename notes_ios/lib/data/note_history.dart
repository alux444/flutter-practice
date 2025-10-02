import 'package:notes_ios/data/rope_node.dart';

class NoteHistory {
  final List<RopeNode?> undo = [];
  final List<RopeNode?> redo = [];
}