import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class HumanFormats {
  static Future<void> init() async {
    Intl.defaultLocale = 'es';
    await initializeDateFormatting('es', null);
    await initializeDateFormatting('en', null);
  }

  static String formatDouble(double value) {
    return NumberFormat('0.#').format(value);
  }

  static String formatDate(DateTime date, {String format = 'yyyy-MM-dd'}) {
    return DateFormat(format).format(date);
  }
}
