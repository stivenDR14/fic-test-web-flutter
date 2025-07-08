/// Utility functions for the application
class AppHelpers {
  /// Formats fund names by replacing underscores and hyphens with spaces
  static String formatFundName(String fundName) {
    if (fundName.isEmpty) return fundName;

    return fundName
        .replaceAll('_', ' ')
        .replaceAll('-', ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  static String formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return 'Hace ${difference.inMinutes} min.';
      }
      return 'Hace ${difference.inHours}h.';
    } else if (difference.inDays == 1) {
      return 'Ayer';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} días atrás';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
