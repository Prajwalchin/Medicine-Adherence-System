import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/api_provider.dart';

class QuoteStateNotifier extends StateNotifier<ApiState> {
  QuoteStateNotifier() : super(ApiState.loading);

  setQuoteState(ApiState apiState) {
    state = apiState;
  }
}

final quoteStateProvider =
    StateNotifierProvider<QuoteStateNotifier, ApiState>((ref) {
  return QuoteStateNotifier();
});
