import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:revory/models/profile_details.dart';
import 'package:revory/repositories/local_app_repository.dart';

/// Provides the saved display name and profile photo.
final profileControllerProvider =
    NotifierProvider<ProfileController, ProfileDetails>(ProfileController.new);

/// Manages profile changes and persistence.
class ProfileController extends Notifier<ProfileDetails> {
  @override
  ProfileDetails build() => const ProfileDetails('Driver', null);

  /// Restores profile fields, using Driver when no name is saved.
  Future<void> restore() async {
    final prefs = await ref.read(localAppRepositoryProvider).preferences;
    state = ProfileDetails(
      prefs.getString('nickname') ?? 'Driver',
      prefs.getString('profilePhotoPath'),
    );
  }

  /// Publishes and persists the display name and optional photo path.
  Future<void> updateProfile(String name, String? photo) async {
    state = ProfileDetails(name, photo);
    final repository = ref.read(localAppRepositoryProvider);
    await repository.writeString('nickname', name);
    await repository.writeString('profilePhotoPath', photo);
  }
}
