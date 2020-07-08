import 'package:equatable/equatable.dart';

import '../module_permissions.dart';

/// Разрешения для пользователя модуля юридических лиц
class LegalPersonsModulePermissions extends ModulePermissions
    with EquatableMixin {
  /// Возможность создания ЮЛ
  ///
  /// Если `true`, то автоматически разрешается редактирование, не зависимо от
  /// значения [edit]
  bool create;

  /// Возможность редактирования
  ///
  /// Игнорировать при [create] == `true`
  bool edit;

  /// Возможность архивирования карточки ЮЛ
  ///
  /// Наличие этого права подразумевается только у администраторов
  bool archive;

  LegalPersonsModulePermissions({this.create, this.edit, this.archive});

  factory LegalPersonsModulePermissions.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;
    return LegalPersonsModulePermissions(
        create: json['create'], edit: json['edit'], archive: json['archive']);
  }

  @override
  Map<String, bool> get json => {
        'create': create ?? false,
        'edit': edit ?? false,
        'archive': archive ?? false
      };

  @override
  List<Object> get props => [create, edit, archive];
}
