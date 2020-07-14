import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:kiouttest/model/dadata_address.dart';
import 'package:kiouttest/services/property_controller.dart';
import 'package:flutter/widgets.dart';
import 'package:quiver/strings.dart';
import 'package:rxdart/rxdart.dart';
import 'package:worker_manager/runnable.dart';
import 'package:worker_manager/worker_manager.dart';

/// Имплементация протокола работы с сервисом dadata
class DadataComponent<T> {
  static const inputKey = 'input';
  static const addressUrl =
      'https://suggestions.dadata.ru/suggestions/api/4_1/rs/suggest/address';
  static const fioUrl =
      'https://suggestions.dadata.ru/suggestions/api/4_1/rs/suggest/fio';
  static final dadataApiKey = 'f5e7a88e0f65b42ef923d86fa8df27115870cda0';

  Task2<String, String, List<T>> task;

  final _input = StreamController<String>();
  final _output = BehaviorSubject<List<T>>();
  final _loadingOutput = BehaviorSubject<bool>();
  bool _disposed = false;

  DadataComponent(
      {@required
          String url,
      @required
          Future<List<T>> Function(String url, String input)
              remoteCallProcessor,
      int debounce = 700}) {
    _input.stream
        .debounceTime(Duration(milliseconds: debounce))
        .distinct()
        .listen((inputData) {
      if (!_disposed) {
        if (task != null) {
          task.cancel();
          task = null;
          _loadingOutput.sink.add(false);
        }
        if (isEmpty(inputData)) {
          _output.add([]);
        } else {
          task = Task2<String, String, List<T>>(
              runnable: Runnable(
                  fun2: remoteCallProcessor, arg1: url, arg2: inputData));
          _loadingOutput.sink.add(true);
          final subscription =
              Executor().addTask(task: task).listen((response) async {
            _output.add(response);
            task = null;
          });
          subscription.onError((error) {
            // ignore errors
          });
          subscription.onDone(() {
            _loadingOutput.sink.add(false);
          });
        }
      }
    });
  }

  Sink<String> get input => _input;

  Stream<List<T>> get output => _output;

  Stream<bool> get loadingOutput => _loadingOutput;

  void dispose() {
    _disposed = true;
    _input.close();
    _output.close();
    _loadingOutput.close();
    task?.cancel();
    task = null;
  }
}

Future<List<DadataAddress>> invokeAddressSuggestions(
    String url, String input) async {
  final queryBody = <String, dynamic>{'query': input, 'count': 10};
  final valueMapper =
      (Map<String, dynamic> resultJson) => DadataAddress.fromJson(resultJson);
  return _invokeSuggestions<DadataAddress>(url, queryBody, valueMapper);
}

Future<List<String>> invokeFirstNameSuggestions(String url, String input) =>
    _invokeFioSuggestions(url, input, ValueType.firstName);

Future<List<String>> invokeLastNameSuggestions(String url, String input) =>
    _invokeFioSuggestions(url, input, ValueType.lastName);

Future<List<String>> invokePatronymicSuggestions(String url, String input) =>
    _invokeFioSuggestions(url, input, ValueType.patronymic);

Future<List<String>> _invokeFioSuggestions(
    String url, String input, ValueType valueType) async {
  final queryBody = <String, dynamic>{
    'query': input,
    'parts': [
      if (valueType == ValueType.firstName) 'NAME',
      if (valueType == ValueType.lastName) 'SURNAME',
      if (valueType == ValueType.patronymic) 'PATRONYMIC'
    ],
    'count': 10
  };
  final valueMapper =
      (Map<String, dynamic> resultJson) => resultJson['value'] as String;
  return _invokeSuggestions<String>(url, queryBody, valueMapper);
}

Future<List<T>> _invokeSuggestions<T>(
    String url,
    Map<String, dynamic> queryBody,
    T Function(Map<String, dynamic>) valueMapper) async {
  final httpClient = HttpClient();
  try {
    final httpRequest = await httpClient.postUrl(Uri.parse(url));
    httpRequest.headers.add('Content-Type', 'application/json; charset=utf-8');
    httpRequest.headers.add('Accept', 'application/json');
    httpRequest.headers.add('Authorization', 'Token ${DadataComponent.dadataApiKey}');
    httpRequest.write(json.encode(queryBody));
    final httpResponse = await httpRequest.close();
    final result = <T>[];
    if (httpResponse.statusCode == HttpStatus.ok) {
      final resultBody =
          (await httpResponse.transform(utf8.decoder).toList()).join();
      final responseJson = json.decode(resultBody) as Map<String, dynamic>;
      (responseJson['suggestions'] as List).forEach((suggestionJson) {
        if (suggestionJson is Map<String, dynamic>) {
          result.add(valueMapper(suggestionJson));
        }
      });
    } else {
      throw HttpException(httpResponse.reasonPhrase);
    }
    return result;
  } finally {
    httpClient.close();
  }
}
