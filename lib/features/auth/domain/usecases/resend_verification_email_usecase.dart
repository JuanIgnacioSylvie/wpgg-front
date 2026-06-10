import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../repositories/auth_repository.dart';

class ResendVerificationEmailUseCase {
  ResendVerificationEmailUseCase(this._repository);

  final AuthRepository _repository;

  Future<Either<Failure, void>> call({
    required String email,
    String? turnstileToken,
  }) {
    return _repository.resendVerificationEmail(
      email: email,
      turnstileToken: turnstileToken,
    );
  }
}
