/// Utility functions for date and time handling

/// Safely parses an ISO8601 date string to DateTime
/// Returns null if the string is null or cannot be parsed
DateTime? parseDateTimeSafe(String? dateString) {
  if (dateString == null) return null;
  try {
    return DateTime.parse(dateString);
  } catch (e) {
    return null;
  }
}
