import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';

/// Purpose-specific limits applied before a photo is stored or encoded.
enum PhotoPurpose {
  /// Profile image: at most 512 pixels on its longest edge and 100 KiB.
  profile(512, 100 * 1024),

  /// Vehicle image: at most 1280 pixels on its longest edge and 250 KiB.
  vehicle(1280, 250 * 1024);

  new(this.maxDimension, this.maxBytes);

  /// Maximum output width or height, preserving the source aspect ratio.
  final int maxDimension;

  /// Maximum compressed JPEG size before Base64 expansion.
  final int maxBytes;
}

/// Replaceable JPEG encoder for platform-independent pipeline tests.
typedef PhotoEncoder = Future<Uint8List?> Function(
  String path, {
  required int width,
  required int height,
  required int quality,
});

/// Recoverable failure while processing or storing a selected photo.
class PhotoProcessingException implements Exception {
  /// Creates a user-facing photo processing failure.
  const new();

  @override
  String toString() =>
      'Could not process this photo. Please try another image.';
}

/// Compresses photos to bounded JPEGs and stores them outside temporary caches.
class PhotoProcessingService {
  /// Creates processing with optional platform overrides for tests.
  new({PhotoEncoder? encoder, Future<Directory> Function()? documentsDirectory})
    : _encoder = encoder ?? _encode,
      _documentsDirectory =
          documentsDirectory ?? getApplicationDocumentsDirectory;

  final PhotoEncoder _encoder;
  final Future<Directory> Function() _documentsDirectory;

  /// Resizes and compresses a source, returning a durable local JPEG path.
  ///
  /// Reduces quality and dimensions until the purpose's byte limit is met.
  /// Never overwrites or deletes the source file. Throws on processing failure.
  Future<String> process(String path, {required PhotoPurpose purpose}) async {
    try {
      final buffer = await ui.ImmutableBuffer.fromFilePath(path);
      late final int sourceWidth;
      late final int sourceHeight;
      try {
        final descriptor = await ui.ImageDescriptor.encoded(buffer);
        try {
          sourceWidth = descriptor.width;
          sourceHeight = descriptor.height;
        } finally {
          descriptor.dispose();
        }
      } finally {
        buffer.dispose();
      }
      for (final factor in [1.0, 0.75, 0.5]) {
        final scale = math.min(
          1,
          purpose.maxDimension * factor / math.max(sourceWidth, sourceHeight),
        );
        final width = math.max(1, (sourceWidth * scale).floor());
        final height = math.max(1, (sourceHeight * scale).floor());
        for (final quality in [80, 65, 50]) {
          final bytes = await _encoder(
            path,
            width: width,
            height: height,
            quality: quality,
          );
          if (bytes == null || bytes.isEmpty) {
            throw const PhotoProcessingException();
          }
          if (bytes.lengthInBytes > purpose.maxBytes) continue;
          final root = await _documentsDirectory();
          final folder = await Directory('${root.path}/photos')
              .create(recursive: true);
          final destination = await folder.createTemp('${purpose.name}_');
          final file = await File('${destination.path}/photo.jpg')
              .writeAsBytes(bytes, flush: true);
          return file.path;
        }
      }
      throw const PhotoProcessingException();
    } on Exception {
      throw const PhotoProcessingException();
    }
  }

  /// Encodes a processed local JPEG for a future backend upload.
  Future<String> toBase64(String processedPath) async =>
      base64Encode(await File(processedPath).readAsBytes());

  static Future<Uint8List?> _encode(
    String path, {
    required int width,
    required int height,
    required int quality,
  }) => FlutterImageCompress.compressWithFile(
    path,
    minWidth: width,
    minHeight: height,
    quality: quality,
  );
}
