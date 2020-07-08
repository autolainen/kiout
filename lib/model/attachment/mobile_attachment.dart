import 'dart:io';

import './attachment.dart';
import './attachment_url.dart';

Attachment createAttachment(
        {AttachmentUrl url,
        String mimeType,
        DateTime createdAt,
        String name,
        file}) =>
    MobileAttachment(
        url: url,
        mimeType: mimeType,
        createdAt: createdAt,
        name: name,
        file: file);

/// Вложение для мобильных и vm-приложений
///
/// В качестве файла вложения используется объект типа [File] из библиотеки `dart:io`
class MobileAttachment extends Attachment<File> {
  MobileAttachment({
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
