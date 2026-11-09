import 'package:revory/models/profile_details.dart';
import 'package:revory/services/attachment_service.dart';

class ProfileDetailsController {
  ProfileDetailsController({AttachmentService? attachments})
    : attachments = attachments ?? AttachmentService();
  final AttachmentService attachments;
  Future<String?> pickPhoto() => attachments.pickPhoto();
  ProfileDetails create(String name, String? photoPath) =>
      ProfileDetails(name.trim().isEmpty ? 'Driver' : name.trim(), photoPath);
}
