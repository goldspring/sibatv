import 'package:flutter_riverpod/flutter_riverpod.dart';

// 外部から変更可能なStateProviderを例に用います。
final tabPageProvider = StateProvider((ref) => 0);

final fullScreenProvider = StateProvider((ref) => false);

final recodingStartProvider = StateProvider((ref) => false);
final recodingStartCompleteProvider = StateProvider((ref) => false);

final recodingInProcessProvider = StateProvider((ref) => false);
