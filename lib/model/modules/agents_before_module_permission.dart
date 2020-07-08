import 'module_permissions.dart';

/// Разрешения для модуля агентов ДО
class AgentsBeforePermissions extends ModulePermissions {
  /// изменение агентов
  bool manageAgentsBefore;

  AgentsBeforePermissions({this.manageAgentsBefore});

  factory AgentsBeforePermissions.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;

    return AgentsBeforePermissions(manageAgentsBefore: json['manageAgents']);
  }

  Map<String, bool> get json => {'manageAgents': manageAgentsBefore}
    ..removeWhere((key, value) => value == null);
}
