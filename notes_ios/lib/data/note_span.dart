class NoteSpan {
  final String text;
  final bool isBold;
  final bool isItalic;
  final bool isUnderlined;

  NoteSpan({
    required this.text,
    this.isBold = false,
    this.isItalic = false,
    this.isUnderlined = false,
  });

  NoteSpan copyWith({
    String? text,
    bool? isBold,
    bool? isItalic,
    bool? isUnderlined,
  }) {
    return NoteSpan(
      text: text ?? this.text,
      isBold: isBold ?? this.isBold,
      isItalic: isItalic ?? this.isItalic,
      isUnderlined: isUnderlined ?? this.isUnderlined,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'isBold': isBold,
      'isItalic': isItalic,
      'isUnderlined': isUnderlined,
    };
  }

  factory NoteSpan.fromJson(Map<String, dynamic> json) {
    return NoteSpan(
      text: json['text'] as String,
      isBold: json['isBold'] as bool? ?? false,
      isItalic: json['isItalic'] as bool? ?? false,
      isUnderlined: json['isUnderlined'] as bool? ?? false,
    );
  }
}
