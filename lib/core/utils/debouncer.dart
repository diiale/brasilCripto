import 'dart:async';

// Debouncer simples para busca reativa.
class Debouncer {
  final Duration delay;
  Timer? _timer;
  Debouncer({required this.delay});

  void call(void Function() action) {
    _timer?.cancel();
    _timer = Timer(delay, action);
  }

  void dispose() => _timer?.cancel();
}
