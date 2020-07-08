import 'dart:html';
import './attachment.dart';
import './attachment_url.dart';

Attachment createAttachment(
        {AttachmentUrl url,
        String mimeType,
        DateTime createdAt,
        String name,
        file}) =>
    BrowserAttachment(
        url: url,
        mimeType: mimeType,
        createdAt: createdAt,
        name: name,
        file: file);

/// Вложение для web-приложений
///
/// В качестве файла вложения используется объект типа [File] из библиотеки `dart:html`
class BrowserAttachment extends Attachment<File> {
  BrowserAttachment({
    AttachmentUrl url,
    String mimeType,
    DateTime createdAt,
    String name,
    File file,
  }) : super.createAttachment(
            url: url,
            mimeType: mimeType,
            name: name,
            createdAt: createdAt,
            file: file);
}
