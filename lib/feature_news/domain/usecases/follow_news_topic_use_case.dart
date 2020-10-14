import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:samachar_hub/core/usecases/usecase.dart';
import 'package:samachar_hub/feature_news/domain/models/news_topic.dart';
import 'package:samachar_hub/feature_news/domain/repository/repository.dart';

class FollowNewsTopicUseCase
    implements UseCase<void, FollowNewsTopicUseCaseParams> {
  final Repository _repository;

  FollowNewsTopicUseCase(this._repository);

  @override
  Future<void> call(FollowNewsTopicUseCaseParams params) {
    try {
      return this._repository.followTopic(params.topic);
    } catch (e) {
      log('FollowNewsTopicUseCase unsuccessful.', error: e);
      throw e;
    }
  }
}

class FollowNewsTopicUseCaseParams extends Equatable {
  final NewsTopicEntity topic;

  FollowNewsTopicUseCaseParams({this.topic});

  @override
  List<Object> get props => [topic];
}