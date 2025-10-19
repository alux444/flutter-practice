import 'package:flutter/cupertino.dart';

class RichTextController extends TextEditingController {
  final List<TextSpan> _spans = [];
  final List<TextRange> _boldRanges = [];

  RichTextController({super.text});

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
