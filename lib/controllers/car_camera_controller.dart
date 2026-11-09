import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';

class CarCameraController extends ChangeNotifier {
  CameraController? camera;
  String? error;
  bool _disposed = false;
  bool _capturing = false;
  Future<void> start() async {
    CameraController? next;
    try {
      final cameras = await availableCameras();
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
    } catch (_) {
      await next?.dispose();
      if (_disposed) return;
      error = 'Camera is unavailable. Check camera permission.';
      notifyListeners();
    }
  }

  Future<String?> capture() async {
    final current = camera;
    if (current == null || !current.value.isInitialized || _capturing) {
      return null;
    }
    _capturing = true;
    try {
      return (await current.takePicture()).path;
    } catch (_) {
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
    camera?.dispose();
    super.dispose();
  }
}
