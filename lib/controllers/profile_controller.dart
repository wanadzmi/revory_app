import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:revory/models/profile_details.dart';
import 'package:revory/repositories/local_app_repository.dart';

final profileControllerProvider =
    NotifierProvider<ProfileController, ProfileDetails>(ProfileController.new);

class ProfileController extends Notifier<ProfileDetails> {
  @override
  ProfileDetails build() => const ProfileDetails('Driver', null);
  Future<void> restore() async {
    final prefs = await ref.read(localAppRepositoryProvider).preferences;
    state = ProfileDetails(
      prefs.getString('nickname') ?? 'Driver',
      prefs.getString('profilePhotoPath'),
    );
  }

  Future<void> updateProfile(String name, String? photo) async {
    state = ProfileDetails(name, photo);
    final repository = ref.read(localAppRepositoryProvider);
    await repository.writeString('nickname', name);
    await repository.writeString('profilePhotoPath', photo);
  }
}
