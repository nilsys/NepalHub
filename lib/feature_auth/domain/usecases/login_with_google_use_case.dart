import 'dart:developer';

import 'package:samachar_hub/core/usecases/usecase.dart';
import 'package:samachar_hub/feature_auth/domain/entities/user_entity.dart';
import 'package:samachar_hub/feature_auth/domain/repositories/repository.dart';

class LoginWithGoogleUseCase implements UseCase<UserEntity, NoParams> {
  final Repository _repository;

  LoginWithGoogleUseCase(this._repository);

  @override
  Future<UserEntity> call(NoParams params) {
    try {
      return this._repository.loginWithGoogle();
    } catch (e) {
      log('LoginWithGoogleUseCase unsuccessful.', error: e);
      throw e;
    }
  }
}
