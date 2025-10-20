import 'package:flutter/cupertino.dart';
import 'package:notes_ios/data/note.dart';
import 'package:notes_ios/data/note_span.dart';

class RichTextController extends TextEditingController {
  final List<TextRange> _boldRanges = [];
  Note? _note;
  String _previousText = '';

  RichTextController({super.text, Note? note}) {
    _note = note;
    _loadBoldRangesFromNote();
    _previousText = text;
    addListener(_onTextChanged);
  }

  @override
  void dispose() {
    removeListener(_onTextChanged);
    super.dispose();
  }

  void _onTextChanged() {
    final currentText = text;
    final previousText = _previousText;
    if (currentText == previousText) return;

    int changeStart = 0;
    while (changeStart < currentText.length &&
        changeStart < previousText.length &&
        currentText[changeStart] == previousText[changeStart]) {
      changeStart++;
    }

    int changeEndCurrent = currentText.length;
    int changeEndPrevious = previousText.length;
    while (changeEndCurrent > changeStart &&
        changeEndPrevious > changeStart &&
        currentText[changeEndCurrent - 1] ==
            previousText[changeEndPrevious - 1]) {
      changeEndCurrent--;
      changeEndPrevious--;
    }

    final lengthDiff =
        (changeEndCurrent - changeStart) - (changeEndPrevious - changeStart);
    _adjustBoldRanges(changeEndPrevious, lengthDiff);
    _previousText = currentText;
    _saveBoldRangesToNote();
  }

  void _adjustBoldRanges(int changePosition, int lengthDiff) {
    for (int i = 0; i < _boldRanges.length; i++) {
      final range = _boldRanges[i];
      if (range.start >= changePosition) {
        // range starts after change, shift both start end
        _boldRanges[i] = TextRange(
          start: range.start + lengthDiff,
          end: range.end + lengthDiff,
        );
      } else if (range.end > changePosition) {
        // range contains the change position so shift the end
        _boldRanges[i] = TextRange(
          start: range.start,
          end: range.end + lengthDiff,
        );
      }
    }
    _boldRanges.removeWhere((range) => range.end <= range.start);
  }

  void setNote(Note note) {
    _note = note;
    _loadBoldRangesFromNote();
    text = _note!.toText();
  }

  void _loadBoldRangesFromNote() {
    if (_note == null) return;

    _boldRanges.clear();
    int currentPos = 0;

    for (final span in _note!.spans) {
      if (span.isBold) {
        _boldRanges.add(
          TextRange(start: currentPos, end: currentPos + span.text.length),
        );
      }
      currentPos += span.text.length;
    }
  }

  void _saveBoldRangesToNote() {
    if (_note == null) return;

    final newSpans = <NoteSpan>[];
    int currentIndex = 0;
    final sortedRanges = List<TextRange>.from(_boldRanges)
      ..sort((a, b) => a.start.compareTo(b.start));

    for (final range in sortedRanges) {
      if (currentIndex < range.start) {
        newSpans.add(
          NoteSpan(
            text: text.substring(currentIndex, range.start),
            isBold: false,
          ),
        );
      }

      newSpans.add(
        NoteSpan(text: text.substring(range.start, range.end), isBold: true),
      );

      currentIndex = range.end;
    }

    if (currentIndex < text.length) {
      newSpans.add(NoteSpan(text: text.substring(currentIndex), isBold: false));
    }
    _note!.fromTextSpans(newSpans);
  }

  void toggleBold(TextSelection selection) {
    if (!selection.isValid || selection.isCollapsed) return;

    final range = TextRange(start: selection.start, end: selection.end);
    final newRanges = <TextRange>[];

    bool wasBold = false;

    for (final r in _boldRanges) {
      if (r.end <= range.start || r.start >= range.end) {
        // No overlap
        newRanges.add(r);
      } else {
        wasBold = true;
        // partial overlap → keep non-overlapping parts
        if (r.start < range.start) {
          newRanges.add(TextRange(start: r.start, end: range.start));
        }
        if (r.end > range.end) {
          newRanges.add(TextRange(start: range.end, end: r.end));
        }
      }
    }

    if (!wasBold) newRanges.add(range);
    _boldRanges
      ..clear()
      ..addAll(newRanges);

    _saveBoldRangesToNote();
    notifyListeners();
  }

  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) {
    if (_boldRanges.isEmpty) {
      return TextSpan(text: text, style: style);
    }

    final children = <TextSpan>[];
    int currentIndex = 0;
    _boldRanges.sort((a, b) => a.start.compareTo(b.start));

    for (final range in _boldRanges) {
      if (currentIndex < range.start) {
        children.add(
          TextSpan(
            text: text.substring(currentIndex, range.start),
            style: style,
          ),
        );
      }

      children.add(
        TextSpan(
          text: text.substring(range.start, range.end),
          style:
              style?.copyWith(fontWeight: FontWeight.bold) ??
              const TextStyle(fontWeight: FontWeight.bold),
        ),
      );

      currentIndex = range.end;
    }

    if (currentIndex < text.length) {
      children.add(TextSpan(text: text.substring(currentIndex), style: style));
    }

    return TextSpan(children: children);
  }
}
