import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:revory/core/services/photo_processing_service.dart';

/// Selects local photos and receipt files through platform pickers.
class AttachmentService {
  /// Creates attachment selection with an optional photo-processing override.
  new({PhotoProcessingService? photos})
    : _photos = photos ?? PhotoProcessingService();

  final PhotoProcessingService _photos;

  /// Returns a compressed, durable gallery image path, or null when cancelled.
  Future<String?> pickPhoto({
    PhotoPurpose purpose = PhotoPurpose.vehicle,
  }) async {
    final photo = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (photo == null) return null;
    return await _photos.process(photo.path, purpose: purpose);
  }

  /// Returns a selected image/PDF filename, or null when cancelled.
  Future<String?> pickReceipt() async {
    final files = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
    );
    return files.isEmpty ? null : files.single.name;
  }
}
