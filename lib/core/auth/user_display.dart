import 'package:sawaliyatrader/core/auth/models/login_response.dart';

class UserDisplay {
  const UserDisplay({
    required this.displayName,
    required this.initials,
  });

  final String displayName;
  final String initials;

  factory UserDisplay.fromSession(LoginResponse session) {
    final employee = session.employee;
    if (employee != null) {
      return UserDisplay(
        displayName: employee.displayName,
        initials: employee.initials,
      );
    }

    final firstName = session.firstName;
    final lastName = session.lastName;
    final fullName = session.fullName;

    if (firstName != null || lastName != null || fullName != null) {
      return UserDisplay(
        displayName: _combinedName(firstName, lastName, fullName),
        initials: _initialsFromNames(firstName, lastName, fullName),
      );
    }

    if (session.isSuperuser) {
      return const UserDisplay(displayName: 'Administrator', initials: 'AD');
    }

    return UserDisplay(
      displayName: 'User #${session.id}',
      initials: 'U',
    );
  }

  static String _combinedName(
    String? firstName,
    String? lastName,
    String? fullName,
  ) {
    final first = firstName?.trim();
    final last = lastName?.trim();
    if (first != null && first.isNotEmpty && last != null && last.isNotEmpty) {
      return '$first $last';
    }
    final full = fullName?.trim();
    if (full != null && full.isNotEmpty) return full;
    if (first != null && first.isNotEmpty) return first;
    return 'User';
  }

  static String _initialsFromNames(
    String? firstName,
    String? lastName,
    String? fullName,
  ) {
    final first = _initial(firstName) ?? _initial(_firstWord(fullName));
    final last = _initial(lastName) ?? _initial(_lastWord(fullName));
    if (first != null && last != null) return '$first$last';
    if (first != null) return first;
    return '?';
  }

  static String? _initial(String? value) {
    final text = value?.trim();
    if (text == null || text.isEmpty) return null;
    return text[0].toUpperCase();
  }

  static String? _firstWord(String? value) {
    final text = value?.trim();
    if (text == null || text.isEmpty) return null;
    return text.split(RegExp(r'\s+')).first;
  }

  static String? _lastWord(String? value) {
    final text = value?.trim();
    if (text == null || text.isEmpty) return null;
    final parts = text.split(RegExp(r'\s+'));
    if (parts.length < 2) return null;
    return parts.last;
  }
}
