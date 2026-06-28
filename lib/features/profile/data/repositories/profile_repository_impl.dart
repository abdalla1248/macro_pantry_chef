import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_local_data_source.dart';
import '../../domain/entities/user_profile.dart';

/// Concrete implementation of [ProfileRepository] connecting domain to datasource.
class ProfileRepositoryImpl implements ProfileRepository {
  ProfileRepositoryImpl({required this.localDataSource});

  final ProfileLocalDataSource localDataSource;

  @override
  Future<UserProfile> getProfile() {
    return localDataSource.getProfile();
  }

  @override
  Future<void> saveProfile(UserProfile profile) {
    return localDataSource.saveProfile(profile);
  }
}
