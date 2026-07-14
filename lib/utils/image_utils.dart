import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

Future<File?> pickImage() async {
  final picker = ImagePicker();
  final picked = await picker.pickImage(source: ImageSource.gallery, maxWidth: 4000, maxHeight: 4000);
  if (picked == null) return null;
  return File(picked.path);
}

Future<ui.Image> loadImageFile(File file) async {
  final bytes = await file.readAsBytes();
  final codec = await ui.instantiateImageCodec(bytes);
  final frame = await codec.getNextFrame();
  return frame.image;
}

Future<ui.Image> loadImageFromBytes(Uint8List bytes) async {
  final codec = await ui.instantiateImageCodec(bytes);
  final frame = await codec.getNextFrame();
  return frame.image;
}

Future<Uint8List?> captureCanvas(GlobalKey key, {int width = 1000, int height = 1000}) async {
  try {
    final boundary = key.currentContext?.findRenderObject() as RenderRepaintBoundary?;
    if (boundary == null) return null;
    final image = await boundary.toImage(pixelRatio: width / boundary.size.width);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return byteData?.buffer.asUint8List();
  } catch (_) {
    return null;
  }
}

Future<File> saveImageToFile(Uint8List bytes, String name) async {
  final dir = await getApplicationDocumentsDirectory();
  final file = File('${dir.path}/$name');
  await file.writeAsBytes(bytes);
  return file;
}

String formatBytes(int bytes) {
  if (bytes < 1024) return '${bytes.round()} B';
  if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
  return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
}
