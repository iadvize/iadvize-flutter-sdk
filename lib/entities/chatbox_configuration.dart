import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ChatboxConfiguration {
  ChatboxConfiguration({
    this.mainColor,
    this.navigationBarBackgroundColor,
    this.navigationBarMainColor,
    this.navigationBarTitle,
    this.fontName,
    this.fontSize,
    this.fontPath,
    this.automaticMessage,
    this.gdprMessage,
    this.incomingMessageAvatarImage,
    this.incomingMessageAvatarURL,
  });

  final Color? mainColor;
  final Color? navigationBarBackgroundColor;
  final Color? navigationBarMainColor;
  final String? navigationBarTitle;
  final String? fontName;
  final int? fontSize;
  final String? fontPath;
  final String? automaticMessage;
  final String? gdprMessage;
  final AssetImage? incomingMessageAvatarImage;
  final String? incomingMessageAvatarURL;

  Future<Map<String, dynamic>> toMap() async {
    final ByteData bytes = await rootBundle.load('assets/test.jpeg');
    final Uint8List list = bytes.buffer.asUint8List();
    return <String, dynamic>{
      if (mainColor != null) 'mainColor': mainColor!.toHexString(),
      if (navigationBarBackgroundColor != null)
        'navigationBarBackgroundColor':
            navigationBarBackgroundColor!.toHexString(),
      if (navigationBarMainColor != null)
        'navigationBarMainColor': navigationBarMainColor!.toHexString(),
      if (navigationBarTitle != null) 'navigationBarTitle': navigationBarTitle,
      if (fontName != null) 'fontName': fontName,
      if (fontSize != null) 'fontSize': fontSize,
      if (fontPath != null) 'fontPath': fontPath,
      if (automaticMessage != null) 'automaticMessage': automaticMessage,
      if (gdprMessage != null) 'gdprMessage': gdprMessage,
      if (incomingMessageAvatarImage != null)
        'incomingMessageAvatarImage': list,
      if (incomingMessageAvatarURL != null)
        'incomingMessageAvatarURL': incomingMessageAvatarURL,
    };
  }
}

extension ColorExt on Color {
  String toHexString({int? radix}) =>
      '#${value.toRadixString(16).padLeft(8, '0')}';
}
