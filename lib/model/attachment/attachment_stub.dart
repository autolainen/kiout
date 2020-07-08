import './attachment.dart';
import './attachment_url.dart';

Attachment createAttachment(
        {DateTime createdAt,
        AttachmentUrl url,
        String mimeType,
        String name,
        file}) =>
    throw UnsupportedError(
        'Cannot create a attachment without dart:html or dart:io.');
