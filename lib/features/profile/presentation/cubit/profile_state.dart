import 'package:equatable/equatable.dart';

import '../../domain/entities/user_profile.dart';

/// State representation for the [ProfileCubit].
class ProfileState extends Equatable {
  const ProfileState({
    this.profile = const UserProfile(),
    this.isLoading = false,
    this.errorMessage,
  });

  final UserProfile profile;
  final bool isLoading;
  final String? errorMessage;

  ProfileState copyWith({
    UserProfile? profile,
    bool? isLoading,
    String? errorMessage,
  }) {
    return ProfileState(
      profile: profile ?? this.profile,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [profile, isLoading, errorMessage];
}
