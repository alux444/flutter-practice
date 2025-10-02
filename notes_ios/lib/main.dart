import 'package:flutter/cupertino.dart';
import 'package:notes_ios/pages/note_page.dart';
import 'package:notes_ios/pages/note_selection_page.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      title: 'Notes',
      theme: CupertinoThemeData(
        primaryColor: CupertinoColors.systemPurple,
        brightness: Brightness.dark,
      ),
      home: App(),
    );
  }
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.folder),
            label: 'Notes',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.search),
            label: 'Note',
          ),
        ],
        activeColor: CupertinoColors.activeBlue,
      ),
      tabBuilder: (context, index) {
        return CupertinoTabView(
          builder: (context) {
            switch (index) {
              case 0:
                return NoteSelectionPage(folderTitle: 'Notes');
              case 1:
                return NotePage();
              default:
                return NoteSelectionPage(folderTitle: 'Notes');
            }
          },
        );
      },
    );
  }
}
