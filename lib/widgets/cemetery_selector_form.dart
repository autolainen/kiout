import 'package:aahitest/model/geo/point.dart';
import 'package:aahitest/services/form_data.dart';
import 'package:aahitest/widgets/cemetery_selector.dart';
import 'package:aahitest/widgets/error_message_widget.dart';
import 'package:flutter/material.dart';

/// Форма выбора кладбища
class CemeterySelectorForm extends StatelessWidget {
  final CemeterySelectorFormData _cemeterySelectorFormData;
  final Point geoPosition;

  const CemeterySelectorForm(
      CemeterySelectorFormData cemeterySelectorFormData, this.geoPosition,
      {Key key})
      : _cemeterySelectorFormData = cemeterySelectorFormData,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        CemeterySelector(
          geoPosition: geoPosition,
          initialValue: _cemeterySelectorFormData.cemeteryId.value,
          orderType: _cemeterySelectorFormData.orderType,
          onChanged: (newValue) {
            _cemeterySelectorFormData.cemeteryId.input.add(newValue);
          },
        ),
        StreamBuilder<String>(
          builder: (context, snapshot) {
            return snapshot.data == null
                ? Container()
                : Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: ErrorMessageWidget(
                        errorMessage: ErrorMessage(
                            title: snapshot.data,
                            onClose: () {
                              _cemeterySelectorFormData.showValidationMsg =
                                  false;
                            })));
          },
          stream: _cemeterySelectorFormData.cemeteryId.validationMsg,
        )
      ],
    );
  }
}
