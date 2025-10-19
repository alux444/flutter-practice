import 'package:notes_ios/data/note_span.dart';

class NoteHistory {
  List<List<NoteSpan>> undo = [];
  List<List<NoteSpan>> redo = [];

  NoteHistory() : undo = [], redo = [];
}
