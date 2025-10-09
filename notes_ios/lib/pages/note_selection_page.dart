import 'package:flutter/cupertino.dart';
import 'package:notes_ios/data/note.dart';
import 'package:notes_ios/pages/note_page.dart';

class NoteSelectionPage extends StatefulWidget {
  const NoteSelectionPage({super.key, required this.folderTitle});

  final String folderTitle;

  @override
  State<NoteSelectionPage> createState() => _NoteSelectionPageState();
}

class _NoteSelectionPageState extends State<NoteSelectionPage> {
  final List<Note> _notes = [];

  void _createNewNote() async {
    Note newNote = Note();
    final result = await Navigator.of(context).push<Note>(
      CupertinoPageRoute(builder: (context) => NotePage(note: newNote)),
    );

    if (result != null && result.toText().isNotEmpty) {
      setState(() {
        _notes.add(result);
      });
    }
  }

  void _openNote(Note note) async {
    final result = await Navigator.of(context).push<Note>(
      CupertinoPageRoute(builder: (context) => NotePage(note: note)),
    );
    if (result != null) {
      setState(() {}); // trigger rebuild
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(widget.folderTitle),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: Icon(CupertinoIcons.add),
          onPressed: _createNewNote,
        ),
      ),
      child: _notes.isEmpty
          ? Center(child: Column(children: []))
          : ListView.builder(
              itemCount: _notes.length,
              itemBuilder: (context, index) {
                final note = _notes[index];
                final noteText = note.toText();
                final preview = noteText.length > 50
                    ? '${noteText.substring(0, 50)}...'
                    : noteText;

                return CupertinoListTile(
                  title: Text(
                    preview.isEmpty ? 'Empty Note' : preview.split('\n').first,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: noteText.length > 50
                      ? Text(
                          preview,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: CupertinoColors.inactiveGray),
                        )
                      : null,
                  trailing: Icon(CupertinoIcons.forward),
                  onTap: () => _openNote(note),
                );
              },
            ),
    );
  }
}
