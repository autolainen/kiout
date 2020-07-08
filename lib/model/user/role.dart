import 'package:data_model/data_model.dart';

/// Роль пользователя
///
/// возможные роли пользователя:
/// * accountant - бухгалтер
/// * agent - агент
/// * b2b_manager - B2B менеджер
/// * contractor_manager - менеджер подрядчика
/// * contractor_worker - исполнитель подрядчика
/// * crematory_manager - менеджер крематория
/// * halls_agent - агент зала прощания
/// * operator_cc - оператор крематория
/// * process_manager - менеджер процессов
/// * product_manager - менеджер продуктов
/// * referrer - внешний агент
/// * referrers_manager - менеджер внешних агентов
/// * screen - экран зала крематория
/// * super_manager - супер менеджер
/// * operator_bс - оператор базы комплектации
class Role implements JsonEncodable {
  /// Бухгалтер
  static const Role accountant = Role._('accountant');

  /// Агент
  static const Role agent = Role._('agent');

  /// B2B менеджер
  static const Role b2bManager = Role._('b2b_manager');

  /// Менеджер подрядчика
  static const Role contractorManager = Role._('contractor_manager');

  /// Исполнитель подрядчика
  static const Role contractorWorker = Role._('contractor_worker');

  /// Менеджер крематория
  static const Role crematoryManager = Role._('crematory_manager');

  /// Агент зала прощания
  static const Role hallsAgent = Role._('halls_agent');

  /// Оператор крематория
  static const Role operatorCC = Role._('operator_cc');

  /// Менеджер процессов
  static const Role processManager = Role._('process_manager');

  /// Менеджер продуктов
  static const Role productManager = Role._('product_manager');

  /// Внешний агент
  static const Role referrer = Role._('referrer');

  /// Менеджер внешних агентов
  static const Role referrersManager = Role._('referrers_manager');

  /// Экран зала крематория
  static const Role screen = Role._('screen');

  /// Супер менеджер
  static const Role superManager = Role._('super_manager');

  /// Оператор базы комплектации
  static const Role operatorBC = Role._('operator_bc');

  final String _role;

  // Создает роль пользователя
  const Role._(String role) : _role = role;

  factory Role(String role) {
    if (role == null) return null;
    Role _curRole = Role._(role);
    if (values.contains(_curRole)) {
      return _curRole;
    } else {
      throw ArgumentError('Unknown user role: ${role}.');
    }
  }

  final Map<String, String> _roleStr = const {
    'accountant': 'Бухгалтер',
    'agent': 'Агент',
    'b2b_manager': 'B2B менеджер',
    'contractor_manager': 'Менеджер подрядчика',
    'contractor_worker': 'Исполнитель подрядчика',
    'crematory_manager': 'Менеджер крематория',
    'halls_agent': 'Агент зала прощания',
    'operator_cc': 'Оператор крематория',
    'process_manager': 'Менеджер процессов',
    'product_manager': 'Менеджер продуктов',
    'referrer': 'Внешний агент',
    'referrers_manager': 'Менеджер внешних агентов',
    'screen': 'Экран зала крематория',
    'super_manager': 'Супер менеджер',
    'operator_bc': 'Оператор баз комплектации'
  };

  final Map<String, String> _rolePrefixStr = const {
    'accountant': 'AC-',
    'agent': 'A-',
    'b2b_manager': 'M-',
    'contractor_manager': 'CR-',
    'contractor_worker': 'CW-',
    'crematory_manager': 'M-',
    'halls_agent': 'HA-',
    'operator_cc': 'ОC-',
    'process_manager': 'M-',
    'product_manager': 'M-',
    'referrer': 'R-',
    'referrers_manager': 'RM-',
    'screen': 'SCR-',
    'super_manager': 'M-',
    'operator_bc': 'OB-'
  };

  String get value => _role;
  static List get values => [
        accountant,
        agent,
        b2bManager,
        contractorManager,
        contractorWorker,
        crematoryManager,
        hallsAgent,
        operatorCC,
        processManager,
        productManager,
        referrer,
        referrersManager,
        screen,
        superManager,
        operatorBC
      ];

  @override
  bool operator ==(dynamic other) {
    if (other is Role) {
      return other._role == _role;
    }
    return false;
  }

  @override
  int get hashCode => _role.hashCode;

  String get json => _role;

  String get prefix => _rolePrefixStr[_role];

  @override
  String toString() => _roleStr[_role];
}
