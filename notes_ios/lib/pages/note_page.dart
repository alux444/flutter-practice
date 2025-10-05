import 'package:flutter/cupertino.dart';
import 'package:notes_ios/data/note.dart';

class NotePage extends StatefulWidget {
  const NotePage({super.key, this.note});

  final Note? note;

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  late TextEditingController _textController;
  late Note _note;

  @override
  void initState() {
    super.initState();
    _note = widget.note ?? Note();
    _textController = TextEditingController(text: _getNoteText());
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  String _getNoteText() {
    // TODO: rope to text
    return '';
  }

  void _saveNote() {
    // TODO: text to rope
    // TODO: change to just autosave on run changes
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text('Note Saved'),
        content: Text('Your note has been saved successfully.'),
        actions: [
          CupertinoDialogAction(
            child: Text('OK'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Note page'),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: _saveNote,
          child: Text('Save'),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: CupertinoTextField(
                  controller: _textController,
                  placeholder: 'Start typing here...',
                  maxLines: null,
                  expands: true,
                  textAlignVertical: TextAlignVertical.top,
                  style: CupertinoTheme.of(context).textTheme.textStyle,
                  decoration: BoxDecoration(border: null),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
