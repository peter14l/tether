import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';

abstract class ISettingsRepository {
  Future<Either<Failure, void>> setString(String key, String value);
  Future<Either<Failure, String?>> getString(String key);
  Future<Either<Failure, void>> setBool(String key, bool value);
  Future<Either<Failure, bool?>> getBool(String key);
}
