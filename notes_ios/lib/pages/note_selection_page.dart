import 'package:flutter/cupertino.dart';

class NoteSelectionPage extends StatefulWidget {
  const NoteSelectionPage({super.key, required this.folderTitle});

  final String folderTitle;

  @override
  State<NoteSelectionPage> createState() => _NoteSelectionPageState();
}

class _NoteSelectionPageState extends State<NoteSelectionPage> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(middle: Text(widget.folderTitle)),
      child: Center(
        child: Text(
          'Hi',
          style: CupertinoTheme.of(context).textTheme.textStyle,
        ),
      ),
    );
  }
}
