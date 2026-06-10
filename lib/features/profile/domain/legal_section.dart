class LegalSection {
  const LegalSection({
    required this.title,
    required this.paragraphs,
    this.bullets = const [],
  });

  final String title;
  final List<String> paragraphs;
  final List<String> bullets;
}
