import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../repositories/auth_repository.dart';

class RequestPasswordResetUseCase {
  RequestPasswordResetUseCase(this._repository);

  final AuthRepository _repository;

  Future<Either<Failure, void>> call({required String email}) {
    return _repository.requestPasswordReset(email: email);
  }
}
