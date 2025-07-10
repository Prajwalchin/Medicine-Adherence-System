import 'package:flutter_riverpod/flutter_riverpod.dart';

class QuoteNotifier extends StateNotifier<String?> {
  QuoteNotifier() : super(null);

  setQuote(String? todaysSchedule) {
    state = todaysSchedule;
  }
}

final quoteProvider =
    StateNotifierProvider<QuoteNotifier, String?>((ref) {
  return QuoteNotifier();
});
