import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class RefreshTokenUseCase {
  RefreshTokenUseCase(this._repository);

  final AuthRepository _repository;

  Future<Either<Failure, UserEntity>> call() => _repository.refreshSession();
}
