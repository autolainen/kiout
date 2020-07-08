/// Группа модулей
///
/// Состав групп фиксированный
class ModuleGroup {
  static const agentsServices =
      ModuleGroup._('agents_services', 'Агентские услуги');
  static const directories = ModuleGroup._('directories', 'Справочники');

  final String id;
  final String name;

  const ModuleGroup._(this.id, this.name);

  static final values = <ModuleGroup>[agentsServices, directories];
}
