import 'dart:developer';

import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:samachar_hub/core/usecases/usecase.dart';
import 'package:samachar_hub/feature_news/domain/entities/news_feed_entity.dart';
import 'package:samachar_hub/feature_news/domain/repository/repository.dart';

class UndislikeNewsUseCase
    implements UseCase<NewsFeedEntity, UndislikeNewsUseCaseParams> {
  final Repository _repository;

  UndislikeNewsUseCase(this._repository);

  @override
  Future<NewsFeedEntity> call(UndislikeNewsUseCaseParams params) {
    try {
      return this._repository.undislikeFeed(params.feed);
    } catch (e) {
      log('UndislikeNewsUseCase unsuccessful.', error: e);
      throw e;
    }
  }
}

class UndislikeNewsUseCaseParams extends Equatable {
  final NewsFeedEntity feed;

  UndislikeNewsUseCaseParams({@required this.feed});

  @override
  List<Object> get props => [feed];
}
