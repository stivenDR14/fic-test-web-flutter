import 'package:flutter/material.dart';
import '../../../../core/utils/helpers.dart';
import '../../../../shared/domain/entities/fund.dart';
import '../../../../config/theme/app_colors.dart';

Widget buildFundCard(Fund fund) {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: AppColors.itemsBackground,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Fund name and category
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                AppHelpers.formatFundName(fund.nombre),
                style: const TextStyle(
                  color: AppColors.itemsText,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.itemsText.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                fund.categoria,
                style: const TextStyle(
                  color: AppColors.itemsText,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Minimum investment
        Row(
          children: [
            const Icon(
              Icons.monetization_on_outlined,
              color: AppColors.itemsText,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              'Inversión mínima: ${fund.montoMinimo}',
              style: const TextStyle(
                color: AppColors.itemsText,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
