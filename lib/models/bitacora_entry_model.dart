class BitacoraEntry{
  DateTime createdAt;
  String emoji;
  String feeling;
  String reason;
  String? extraText;

  BitacoraEntry({required this.createdAt, required this.emoji, required this.feeling, required this.reason, this.extraText});
}