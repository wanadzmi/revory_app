/// Display name and optional local image path for a user profile.
class ProfileDetails {
  /// Creates a profile value for display or editor results.
  const new(this.nickname, this.photoPath);

  /// Name displayed in the profile and garage heading.
  final String nickname;

  /// Local profile image path, or null when no image is selected.
  final String? photoPath;
}
