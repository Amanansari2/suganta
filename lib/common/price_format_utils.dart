import 'package:intl/intl.dart';

class PriceFormatUtils {
  static String formatIndianAmount(num amount,
      {bool withRupee = true, int precision = 2}) {
    String formatted;

    if (amount >= 10000000) {
      double value = amount / 10000000;
      formatted = _formatNumber(value, precision) + ' Cr';
    } else if (amount >= 100000) {
      double value = amount / 100000;
      formatted = _formatNumber(value, precision) + ' Lakh';
    } else {
      final indianFormat = NumberFormat.decimalPattern('en_IN');
      formatted = indianFormat.format(amount);
    }

    return withRupee ? '₹$formatted' : formatted;
  }

  static String _formatNumber(double number, int precision) {
    String formatted = number.toStringAsFixed(precision);
    if (formatted.endsWith('.00')) {
      return formatted.substring(0, formatted.length - 3);
    }
    return formatted;
  }
}
