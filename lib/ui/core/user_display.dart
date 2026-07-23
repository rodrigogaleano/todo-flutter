abstract final class UserDisplay {
  static String initials(String? displayName, String? email) {
    final name = displayName?.trim() ?? '';
    if (name.isNotEmpty) {
      final parts = name.split(RegExp(r'\s+'));
      final first = parts.first[0];
      final last = parts.length > 1 ? parts.last[0] : '';
      return (first + last).toUpperCase();
    }
    final address = email?.trim() ?? '';
    if (address.isNotEmpty) return address[0].toUpperCase();
    return '?';
  }

  static String name(String? displayName, String? email) {
    final name = displayName?.trim() ?? '';
    if (name.isNotEmpty) return name;
    final address = email?.trim() ?? '';
    if (address.isNotEmpty) return address.split('@').first;
    return '?';
  }

  static String email(String? email) => email?.trim() ?? '';
}
