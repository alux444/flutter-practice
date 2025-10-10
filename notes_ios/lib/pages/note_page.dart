import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
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
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _note = widget.note ?? Note();
    _textController = TextEditingController(text: _getNoteText());
    _textController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _textController.removeListener(_onTextChanged);
    _textController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  String _getNoteText() {
    return _note.toText();
  }

  void _onTextChanged() {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(Duration(milliseconds: 500), () {
      setState(() {
        _note.fromText(_textController.text);
      });
    });
  }

  void _goBack() {
    Navigator.of(context).pop(_note);
  }

  void _undo() {
    setState(() {
      _note.undo();
      _textController.text = _note.toText();
      // moves cursor to end of text
      _textController.selection = TextSelection.collapsed(
        offset: _textController.text.length,
      );
    });
  }

  void _redo() {
    setState(() {
      _note.redo();
      _textController.text = _note.toText();
      _textController.selection = TextSelection.collapsed(
        offset: _textController.text.length,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        leading: CupertinoButton(
          child: Icon(CupertinoIcons.back),
          onPressed: _goBack,
        ),
        trailing: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            CupertinoButton(
              onPressed: _note.canUndo ? _undo : null,
              disabledColor: CupertinoColors.inactiveGray,
              child: Icon(CupertinoIcons.arrow_uturn_left),
            ),
            SizedBox(width: 5),
            CupertinoButton(
              onPressed: _note.canRedo ? _redo : null,
              disabledColor: CupertinoColors.inactiveGray,
              child: Icon(CupertinoIcons.arrow_uturn_right),
            ),
          ],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: CupertinoTextField(
                    controller: _textController,
                    placeholder: 'Start typing here...',
                    maxLines: null,
                    minLines: 20,
                    textAlignVertical: TextAlignVertical.top,
                    style: CupertinoTheme.of(context).textTheme.textStyle,
                    decoration: BoxDecoration(border: null),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
