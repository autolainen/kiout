import 'package:aahitest/pages/wizard_page.dart';
import 'package:aahitest/services/dadata_component.dart';
import 'package:aahitest/services/property_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SuggestionField<T> extends StatefulWidget {
  final PropertyController<T> propertyController;

  final T Function(String) stringToValueMapper;
  final double horizontalPadding;
  final bool autofocus;
  final String url;
  final Future<List<T>> Function(String url, String input) remoteCallProcessor;
  final TextInputAction textInputAction;
  final ValueChanged<String> onSubmitted;
  final TextCapitalization textCapitalization;
  final List<TextInputFormatter> inputFormatters;
  final bool autocorrect;

  const SuggestionField(
      {Key key,
      @required this.propertyController,
      @required this.stringToValueMapper,
      this.autofocus = false,
      @required this.url,
      @required this.remoteCallProcessor,
      this.textInputAction = TextInputAction.next,
      this.onSubmitted,
      this.textCapitalization,
      this.inputFormatters,
      this.horizontalPadding = 16,
      this.autocorrect = false})
      : super(key: key);

  @override
  _SuggestionFieldState<T> createState() => _SuggestionFieldState<T>();
}

class _SuggestionFieldState<T> extends State<SuggestionField<T>> {
  DadataComponent<T> _dadataComponent;
  final focusNode = FocusNode();
  TextEditingController textController;

  @override
  void initState() {
    super.initState();
    _dadataComponent = DadataComponent(
        url: widget.url, remoteCallProcessor: widget.remoteCallProcessor);
    var formattedValue = widget.propertyController?.formattedValue?.value;
    textController = TextEditingController.fromValue(
        TextEditingValue(text: formattedValue ?? ''));
    _dadataComponent.input.add(formattedValue);
    textController.addListener(() {
      final text = textController.text.trim();
      widget.propertyController?.input?.add(widget.stringToValueMapper(text));
      _dadataComponent.input.add(text);
    });
    // Поле не всегда получает фокус при autofocus=true
    // https://github.com/flutter/flutter/issues/47235
    if (widget.autofocus) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        focusNode?.requestFocus();
      });
    }
  }

  @override
  void dispose() {
    focusNode.dispose();
    textController.dispose();
    _dadataComponent?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final horizontalPadding =
        EdgeInsets.symmetric(horizontal: widget.horizontalPadding);

/*
    const fieldBorder = OutlineInputBorder();
    var focusedFieldBorder = fieldBorder.copyWith(
        borderSide: BorderSide(color: Theme.of(context).accentColor, width: 2));
*/

    return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
              padding: horizontalPadding,
              child: TextField(
                  inputFormatters: widget.inputFormatters,
                  focusNode: focusNode,
                  maxLines: 2,
                  minLines: 1,
                  autocorrect: widget.autocorrect,
                  textCapitalization: widget.textCapitalization,
                  controller: textController,
                  textInputAction: widget.textInputAction,
                  onSubmitted: widget.onSubmitted,
                  decoration: InputDecoration(
                      labelText: widget.propertyController.caption
                  )
              )),
          buildFieldErrorMessage(widget.propertyController),
          Expanded(
              child: Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: StreamBuilder<bool>(
                      stream: _dadataComponent.loadingOutput,
                      initialData: false,
                      builder: (context, snapshot) {
                        final isLoading = snapshot.hasData && snapshot.data;
                        return Stack(children: <Widget>[
                          if (isLoading)
                            Center(child: CircularProgressIndicator()),
                          Offstage(
                              offstage: isLoading,
                              child: _createSuggestionsList())
                        ]);
                      })))
        ]);
  }

  Widget _createSuggestionsList() {
    final horizontalPadding =
        EdgeInsets.symmetric(horizontal: widget.horizontalPadding);
    return StreamBuilder<List<T>>(
        stream: _dadataComponent.output,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final divider = Divider(indent: 16, endIndent: 16, height: 1);
            final tilePadding = horizontalPadding;
            return ListView.separated(
                itemBuilder: (context, index) {
                  return ListTile(
                      contentPadding: tilePadding,
                      title: Text(snapshot.data[index].toString()),
                      onTap: () {
                        widget.propertyController.input
                            .add(snapshot.data[index]);
                        final valueString = snapshot.data[index].toString();
                        textController.value = TextEditingValue(
                            text: valueString,
                            selection: TextSelection.fromPosition(
                                TextPosition(offset: valueString.length)));
                      });
                },
                separatorBuilder: (context, index) => divider,
                itemCount: snapshot.data.length);
          } else {
            return Container();
          }
        });
  }
}
