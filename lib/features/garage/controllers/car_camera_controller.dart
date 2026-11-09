import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';

/// Owns camera initialization, capture, and resource cleanup.
class CarCameraController extends ChangeNotifier {
  /// Initialized camera used to render the preview, or null while loading.
  CameraController? camera;

  /// User-facing failure message, or null when no failure occurred.
  String? error;
  bool _disposed = false;
  bool _capturing = false;

  /// Opens the rear camera, falling back to the first available camera.
  Future<void> start() async {
    CameraController? next;
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        error = 'No camera is available on this device.';
        notifyListeners();
        return;
      }
      final description = cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );
      next = CameraController(
        description,
        ResolutionPreset.high,
        enableAudio: false,
      );
      await next.initialize();
      if (_disposed) {
        await next.dispose();
        return;
      }
      camera = next;
      notifyListeners();
    } on CameraException {
      await next?.dispose();
      if (_disposed) return;
      error = 'Camera is unavailable. Check camera permission.';
      notifyListeners();
    }
  }

  /// Captures a photo and returns its path; returns null on failure or overlap.
  Future<String?> capture() async {
    final current = camera;
    if (current == null || !current.value.isInitialized || _capturing) {
      return null;
    }
    _capturing = true;
    try {
      return (await current.takePicture()).path;
    } on CameraException {
      if (!_disposed) {
        error = 'Could not take the photo. Please try again.';
        notifyListeners();
      }
      return null;
    } finally {
      _capturing = false;
    }
  }

  @override
  void dispose() {
    _disposed = true;
    final current = camera;
    if (current != null) unawaited(current.dispose());
    super.dispose();
  }
}
