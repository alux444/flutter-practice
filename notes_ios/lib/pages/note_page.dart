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
  Timer? _statusAnimationTimer;
  Timer? _statusClearTimer;
  // '' | 'Saving.' | 'Saving..' | 'Saving...' | 'Saved!'
  String _saveStatus = '';

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
    _statusAnimationTimer?.cancel();
    _statusClearTimer?.cancel();
    super.dispose();
  }

  String _getNoteText() {
    return _note.toText();
  }

  void _startSaveAnimation() {
    _statusAnimationTimer?.cancel();
    int dotCount = 1;

    setState(() {
      _saveStatus = 'Saving.';
    });

    _statusAnimationTimer = Timer.periodic(Duration(milliseconds: 200), (
      timer,
    ) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      dotCount = (dotCount % 3) + 1;
      setState(() {
        _saveStatus = 'Saving${'.' * dotCount}';
      });
    });
  }

  void _onTextChanged() {
    _debounceTimer?.cancel();
    _statusClearTimer?.cancel();
    _startSaveAnimation();

    _debounceTimer = Timer(Duration(milliseconds: 500), () {
      setState(() {
        _note.fromText(_textController.text);
        _saveStatus = 'Saved!';
      });

      Timer(Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            _saveStatus = '';
          });
        }
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
          onPressed: _goBack,
          child: Icon(CupertinoIcons.back),
        ),
        middle: _saveStatus.isNotEmpty
            ? Text(
                _saveStatus,
                style: TextStyle(
                  fontSize: 14,
                  color: CupertinoColors.secondaryLabel,
                ),
              )
            : null,
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
