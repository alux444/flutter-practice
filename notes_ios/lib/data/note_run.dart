enum TextStyle {
  regular,
  bold,
  italics,
  underline,
  strikethrough,
  title,
  heading,
}

class NoteRun {
  final String text;
  final Set<TextStyle> style;

  NoteRun({required this.text, required this.style});
}
