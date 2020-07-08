import 'package:data_model/data_model.dart';

/// Статус пользователя
///
/// возможный статус пользователя:
/// * active - активен
/// * blocked - заблокирован
/// * archived - архив
class UserStatus implements JsonEncodable {
  /// Активен
  static const UserStatus active = UserStatus._('active');

  /// Заблокирован
  static const UserStatus blocked = UserStatus._('blocked');

  /// Архив
  static const UserStatus archived = UserStatus._('archived');

  final String _status;

  // Создает статус пользователя
  const UserStatus._(String status) : _status = status;

  factory UserStatus(String status) {
    if (status == null) return null;
    UserStatus _curStatus = UserStatus._(status);
    if (values.contains(_curStatus)) {
      return _curStatus;
    } else {
      throw ArgumentError('Unknown user status: ${status}.');
    }
  }

  final Map<String, String> _statusStr = const {
    'active': 'Активен',
    'blocked': 'Заблокирован',
    'archived': 'Архив'
  };

  String get value => _status;
  static List get values => [active, blocked, archived];

  @override
  bool operator ==(dynamic other) {
    if (other is UserStatus) {
      return other._status == _status;
    }
    return false;
  }

  @override
  int get hashCode => _status.hashCode;

  String get json => _status;

  @override
  String toString() => _statusStr[_status];
}
