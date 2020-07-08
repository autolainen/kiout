import 'package:aahitest/model/client.dart';
import 'package:aahitest/model/order/order_type.dart';
import 'package:aahitest/model/preorder/preorder.dart';
import 'package:aahitest/services/form_data.dart';
import 'package:aahitest/services/preorder_editor_bloc.dart';
import 'package:aahitest/services/validators.dart';

/// Объект бизнес-логики для создания предзаказа на захоронение и подзахоронение
class BurialPreorderEditorBloc extends PreorderEditorBloc {
  final OrderType _orderType;

  BurialPreorderEditorBloc.createBlank(OrderType orderType)
      : _orderType = orderType,
        assert(
            orderType == OrderType.burial || orderType == OrderType.subburial),
        super(PreorderEditorBlocMode.createBlank) {
    _addCommonFormData(_orderType, pagesData);
  }

  BurialPreorderEditorBloc.createByTemplate(
      OrderType orderType, Preorder preorder)
      : _orderType = orderType,
        assert(preorder != null),
        assert(orderType != null),
        assert(
            orderType == OrderType.burial || orderType == OrderType.subburial),
        super(PreorderEditorBlocMode.createByTemplate) {
    _addCommonFormData(_orderType, pagesData, preorder: preorder);
  }

  BurialPreorderEditorBloc.edit(Preorder preorder)
      : _orderType = preorder?.type,
        assert(preorder != null),
        assert(preorder?.type == OrderType.burial ||
            preorder?.type == OrderType.subburial),
        super(PreorderEditorBlocMode.edit) {
    _addCommonFormData(_orderType, pagesData, preorder: preorder);
  }

  void _addCommonFormData(OrderType orderType, List<FormData> pagesData,
      {Preorder preorder}) {
    final clientFormData = ClientFormData('Клиент',
        client: mode == PreorderEditorBlocMode.createByTemplate &&
                preorder?.type == OrderType.agentService
            ? Client.fromJson(preorder.representative?.json)
            : preorder?.client,
        phoneValidator: isNotBlankAndValidPhone);
    pagesData.add(clientFormData);

/*
    final deceasedFormData =
        DeceasedFormData('Усопший', deceased: preorder?.deceased);
    pagesData.add(deceasedFormData);
*/

    final cemeterySelectorFormData = CemeterySelectorFormData(
        'Кладбище', orderType,
        initValue: preorder?.cemetery);
    pagesData.add(cemeterySelectorFormData);

/*
    final packageSelectorFormData = PackageSelectorFormData('Пакет', orderType,
        cemeteryId: cemeterySelectorFormData.cemeteryId,
        initValue: preorder?.package, validator: (value) {
      return value == null ? 'Выберите пакет' : null;
    });
    pagesData.add(packageSelectorFormData);

    final plotSelectorFormData = PlotSelectorFormData(
        'Участок', orderType, cemeterySelectorFormData.cemeteryId.valueOutput,
        package: packageSelectorFormData.package.valueOutput, onSkip: () {
      page = ++currentPageIndex.value;
    },
        pointInitValue: preorder?.plotPosition,
        photosInitValue: preorder?.documents
            ?.map<Attachment<File>>(convertDocumentToAttachment)
            ?.toList());
    pagesData.add(plotSelectorFormData);

    final extraServiceSelectorFormData = ExtraServiceSelectorFormData(
        'Доп. товары "Кладбище"', orderType,
        itemsInitValue: preorder?.additionalItems);
    pagesData.add(extraServiceSelectorFormData);

    pagesData.add(SummaryFormData('Подтверждение', orderType, mode,
        preorderId: preorder?.id as PreorderId,
        // TODO Не должно быть приведения типов здесь
        clientFormData: clientFormData,
        deceasedFormData: deceasedFormData,
        cemeterySelectorFormData: cemeterySelectorFormData,
        packageSelectorFormData: packageSelectorFormData,
        plotSelectorFormData: plotSelectorFormData,
        extraServiceSelectorFormData: extraServiceSelectorFormData,
        enableChanges: enableChanges));
*/
  }

  @override
  OrderType get orderType => _orderType;
}
