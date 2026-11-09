import 'package:revory/models/profile_details.dart';
import 'package:revory/services/attachment_service.dart';

/// Normalizes profile-editor input and selects profile photos.
class ProfileDetailsController {
  /// Creates profile-editor logic with an optional attachment override.
  new({AttachmentService? attachments})
    : attachments = attachments ?? AttachmentService();

  /// Platform attachment dependency used to select a profile photo.
  final AttachmentService attachments;

  /// Selects a profile image path, or returns null when cancelled.
  Future<String?> pickPhoto() => attachments.pickPhoto();

  /// Creates profile details, defaulting a blank name to Driver.
  ProfileDetails create(String name, String? photoPath) =>
      ProfileDetails(name.trim().isEmpty ? 'Driver' : name.trim(), photoPath);
}
