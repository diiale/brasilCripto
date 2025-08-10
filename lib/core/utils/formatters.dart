import 'package:intl/intl.dart';

class BrFormat {
  // Moeda: R$ 12.345,67
  static final NumberFormat _moeda = NumberFormat.currency(
    locale: 'pt_BR',
    symbol: 'R\$',
  );

  // Percentual: 1,23 (você adiciona o % depois)
  static final NumberFormat _percent = NumberFormat.decimalPattern('pt_BR');

  // Valores compactos: R$ 1,2 mi / R$ 3,4 bi (para market cap/volume)
  static final NumberFormat _moedaCompact = NumberFormat.compactCurrency(
    locale: 'pt_BR',
    symbol: 'R\$',
  );

  static String moeda(num value) => _moeda.format(value);
  static String percent(num value) => '${_percent.format(value)}%';
  static String moedaCompact(num value) => _moedaCompact.format(value);

  // Datas (se precisar em algum lugar)
  static String dataHora(DateTime dt) =>
      DateFormat('dd/MM/yyyy HH:mm', 'pt_BR').format(dt);
}
