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
}
