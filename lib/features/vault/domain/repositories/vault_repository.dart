import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/vault_item.dart';

abstract class IVaultRepository {
  Future<Either<Failure, List<VaultItemEntity>>> getVaultItems(String circleId);
  Future<Either<Failure, void>> addVaultItem(VaultItemEntity item);
  Future<Either<Failure, void>> deleteVaultItem(String itemId);
  Stream<List<VaultItemEntity>> streamVaultItems(String circleId);
}
