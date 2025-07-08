import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/entities/fund.dart';

final selectedFundProvider = StateProvider<Fund?>((ref) => null);
