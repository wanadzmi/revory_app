import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';

/// Selects local photos and receipt files through platform pickers.
class AttachmentService {
  /// Returns the selected gallery image path, or null when cancelled.
  Future<String?> pickPhoto() async => (await ImagePicker().pickImage(
    source: ImageSource.gallery,
    imageQuality: 85,
  ))?.path;

  /// Returns a selected image/PDF filename, or null when cancelled.
  Future<String?> pickReceipt() async {
    final files = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
    );
    return files.isEmpty ? null : files.single.name;
  }
}
