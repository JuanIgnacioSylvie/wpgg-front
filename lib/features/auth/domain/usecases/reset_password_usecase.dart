import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../repositories/auth_repository.dart';

class ResetPasswordUseCase {
  ResetPasswordUseCase(this._repository);

  final AuthRepository _repository;

  Future<Either<Failure, void>> call({
    required String token,
    required String password,
  }) {
    return _repository.resetPassword(token: token, password: password);
  }
}
