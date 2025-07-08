import 'package:flutter_test/flutter_test.dart';
import 'package:fic_test_flutter/core/utils/helpers.dart';

void main() {
  group('AppHelpers', () {
    group('formatFundName', () {
      test('should convert underscores to spaces', () {
        const input = 'FPV_BTG_PACTUAL_ECOPETROL';
        const expected = 'FPV BTG PACTUAL ECOPETROL';

        final result = AppHelpers.formatFundName(input);

        expect(result, equals(expected));
      });

      test('should convert hyphens to spaces', () {
        const input = 'FDO-ACCIONES';
        const expected = 'FDO ACCIONES';

        final result = AppHelpers.formatFundName(input);

        expect(result, equals(expected));
      });

      test('should format date', () {
        var input = DateTime(2025, 7, 8, 10, 0, 0);
        const expected = 'Hace 7h.';

        final result = AppHelpers.formatDate(input);

        expect(result, equals(expected));
      });
    });
  });
}
