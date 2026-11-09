import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter_test/flutter_test.dart';
import 'package:revory/core/services/photo_processing_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory sandbox;
  late File source;

  setUp(() async {
    sandbox = await Directory.systemTemp.createTemp('revory_photo_test_');
    final recorder = ui.PictureRecorder();
    ui.Canvas(recorder)
        .drawPaint(ui.Paint()..color = const ui.Color(0xff123456));
    final picture = recorder.endRecording();
    final image = await picture.toImage(1600, 800);
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    source = await File('${sandbox.path}/source.png')
        .writeAsBytes(bytes!.buffer.asUint8List());
    image.dispose();
    picture.dispose();
  });

  tearDown(() async {
    await sandbox.delete(recursive: true);
  });

  test(
    'profile compression retries and stores a durable Base64-ready file',
    () async {
      final sizes = <(int, int, int)>[];
      final payload = Uint8List.fromList([0xff, 0xd8, 0xff, 0xd9]);
      final documents = Directory('${sandbox.path}/documents');
      final service = PhotoProcessingService(
        documentsDirectory: () async => documents,
        encoder:
            (path, {required width, required height, required quality}) async {
              sizes.add((width, height, quality));
              return sizes.length == 1
                  ? Uint8List(PhotoPurpose.profile.maxBytes + 1)
                  : payload;
            },
      );
      final saved = await service.process(
        source.path,
        purpose: PhotoPurpose.profile,
      );
      expect(sizes, [(512, 256, 80), (512, 256, 65)]);
      expect(saved, startsWith('${documents.path}/photos/'));
      expect(saved, endsWith('.jpg'));
      await source.delete();
      final restarted = PhotoProcessingService();
      expect(await restarted.toBase64(saved), base64Encode(payload));
      expect(await File(saved).readAsBytes(), payload);
    },
  );

  test(
    'vehicle processing preserves aspect ratio and uses unique files',
    () async {
      final sizes = <(int, int)>[];
      final service = PhotoProcessingService(
        documentsDirectory: () async => sandbox,
        encoder:
            (path, {required width, required height, required quality}) async {
              sizes.add((width, height));
              return Uint8List.fromList([0xff, 0xd8, 0xff, 0xd9]);
            },
      );
      final first = await service.process(
        source.path,
        purpose: PhotoPurpose.vehicle,
      );
      final second = await service.process(
        source.path,
        purpose: PhotoPurpose.vehicle,
      );
      expect(sizes, [(1280, 640), (1280, 640)]);
      expect(first, isNot(second));
      expect(source.existsSync(), isTrue);
    },
  );

  test('rejects photos when retries cannot meet the size budget', () async {
    var attempts = 0;
    final service = PhotoProcessingService(
      documentsDirectory: () async => sandbox,
      encoder:
          (path, {required width, required height, required quality}) async {
            attempts++;
            return Uint8List(PhotoPurpose.profile.maxBytes + 1);
          },
    );
    await expectLater(
      service.process(source.path, purpose: PhotoPurpose.profile),
      throwsA(isA<PhotoProcessingException>()),
    );
    expect(attempts, 9);
    expect(Directory('${sandbox.path}/photos').existsSync(), isFalse);
  });
}
