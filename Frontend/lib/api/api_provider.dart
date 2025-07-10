import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/api.dart';

enum ApiState { loading, done, error }

final apiProvider = Provider<ApiService>((ref) => ApiService(ref));

