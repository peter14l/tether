import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/error/failures.dart';
import '../../domain/repositories/settings_repository.dart';

@LazySingleton(as: ISettingsRepository)
class SharedPrefsSettingsRepository implements ISettingsRepository {
  final SharedPreferences _prefs;

  SharedPrefsSettingsRepository(this._prefs);

  @override
  Future<Either<Failure, String?>> getString(String key) async {
    try {
      return Right(_prefs.getString(key));
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> setString(String key, String value) async {
    try {
      await _prefs.setString(key, value);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool?>> getBool(String key) async {
    try {
      return Right(_prefs.getBool(key));
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> setBool(String key, bool value) async {
    try {
      await _prefs.setBool(key, value);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}
