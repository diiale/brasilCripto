class CoinDetail {
  final String id;
  final String description;
  final List<List<num>> prices; // [timestamp(ms), price]
  const CoinDetail({
    required this.id,
    required this.description,
    required this.prices,
  });
}