import 'package:aahitest/pages/wizard_page.dart';
import 'package:aahitest/services/customizable_popup_route.dart';
import 'package:aahitest/services/form_data.dart';
import 'package:aahitest/services/property_controller.dart';
import 'package:aahitest/widgets/immutable_text_form_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Форма по списку контроллеров в объекте [FormData]
class PropertiesListForm extends StatelessWidget {
  final FormData formData;

  const PropertiesListForm(this.formData, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      if (formData.formDescription != null)
        buildFormDescription(formData.formDescription),
      ...formData.controllers.asMap().map<int, Widget>((index, controller) {
        return MapEntry<int, Widget>(
            index, _createFormField(index, controller));
      }).values
    ]);
  }

  Widget _createFormField(
      int fieldIndex, PropertyController propertyController) {
    return StreamBuilder<String>(
        stream: propertyController.validationMsg,
        builder: (context, errorSnapshot) {
          return StreamBuilder<String>(
              initialData: propertyController.formattedValue.value,
              stream: propertyController.formattedValue,
              builder: (context, valueSnapshot) {
                return ImmutableTextFormField(
                    decoration: InputDecoration(
                        labelText: propertyController.caption,
                        errorText: errorSnapshot.data),
                    value: valueSnapshot.data,
                    onTap: () {
                      Navigator.of(context).push(CustomizablePopupRoute<void>(
                          builder: (BuildContext context) => WizardPage(
                                controllers: formData.controllers,
                                fieldIndex: fieldIndex,
                              )));
                    });
              });
        });
  }
}

Widget buildFormDescription(String formDescription) {
  const formDescriptionStyle =
      TextStyle(fontSize: 14, color: Color(0xFF808080));
  return Padding(
      padding: const EdgeInsets.only(top: 14, bottom: 12),
      child: Text(formDescription ?? '',
          textAlign: TextAlign.center, style: formDescriptionStyle));
}
