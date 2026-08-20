class StringUtils {
  static String truncateToWord(String input, int limit) {
    if (input.length <= limit) {
      return input;
    }

    final slice = input.substring(0, limit);
    final lastSpace = slice.lastIndexOf(' ');

    if (lastSpace > 0) {
      return slice.substring(0, lastSpace).trimRight();
    } else {
      return '${slice.trimRight()}...';
    }
  }
}
