import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class VerifyEmailUseCase {
  VerifyEmailUseCase(this._repository);

  final AuthRepository _repository;

  Future<Either<Failure, UserEntity>> call({required String token}) {
    return _repository.verifyEmail(token: token);
  }
}
