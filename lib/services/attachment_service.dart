import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';

class AttachmentService {
  Future<String?> pickPhoto() async => (await ImagePicker().pickImage(
    source: ImageSource.gallery,
    imageQuality: 85,
  ))?.path;
  Future<String?> pickReceipt() async {
    final files = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
    );
    return files.isEmpty ? null : files.single.name;
  }
}
