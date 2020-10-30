import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:event_bus/event_bus.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';
import 'package:samachar_hub/core/usecases/usecase.dart';
import 'package:samachar_hub/feature_news/domain/entities/news_feed_entity.dart';
import 'package:samachar_hub/feature_news/domain/usecases/like_news_use_case.dart';
import 'package:samachar_hub/feature_news/domain/usecases/unlike_news_use_case.dart';
import 'package:samachar_hub/feature_news/presentation/events/feed_event.dart';
import 'package:samachar_hub/feature_news/presentation/models/news_feed.dart';

part 'like_unlike_event.dart';
part 'like_unlike_state.dart';

class LikeUnlikeBloc extends Bloc<LikeUnlikeEvent, LikeUnlikeState> {
  final UseCase _likeNewsFeedUseCase;
  final UseCase _unLikeNewsFeedUseCase;
  final NewsFeedUIModel _newsFeedUIModel;

  StreamSubscription _feedEventStreamSubscription;

  LikeUnlikeBloc({
    @required UseCase likeNewsFeedUseCase,
    @required UseCase unLikeNewsFeedUseCase,
    @required NewsFeedUIModel newsFeedUIModel,
  })  : _likeNewsFeedUseCase = likeNewsFeedUseCase,
        _unLikeNewsFeedUseCase = unLikeNewsFeedUseCase,
        _newsFeedUIModel = newsFeedUIModel,
        super(InitialState()) {
    this._feedEventStreamSubscription =
        GetIt.I.get<EventBus>().on<NewsFeedEvent>().listen((event) {
      switch (event.eventType) {
        case 'like':
          if (_newsFeedUIModel.feedEntity.id == event.feedId) {
            add(UpdateLikeEvent());
          }
          break;
        case 'unlike':
          if (_newsFeedUIModel.feedEntity.id == event.feedId) {
            add(UpdateUnlikeEvent());
          }
          break;
      }
    });
  }

  @override
  Future<void> close() {
    _feedEventStreamSubscription?.cancel();
    return super.close();
  }

  @override
  Stream<LikeUnlikeState> mapEventToState(
    LikeUnlikeEvent event,
  ) async* {
    if (state is InProgressState) return;
    if (event is LikeEvent) {
      yield InProgressState();
      try {
        final NewsFeedEntity newsFeedEntity = await _likeNewsFeedUseCase
            .call(LikeNewsUseCaseParams(feed: _newsFeedUIModel.feedEntity));
        if (newsFeedEntity != null) {
          _newsFeedUIModel.feedEntity = newsFeedEntity;
        }
        yield LikedState(message: 'Feed liked successfully.');
      } catch (e) {
        log('News feed like error.', error: e);
        yield ErrorState(message: 'Unable to like.');
      }
    } else if (event is UnlikeEvent) {
      yield InProgressState();
      try {
        final NewsFeedEntity newsFeedEntity = await _unLikeNewsFeedUseCase
            .call(UnlikeNewsUseCaseParams(feed: _newsFeedUIModel.feedEntity));
        if (newsFeedEntity != null) {
          _newsFeedUIModel.feedEntity = newsFeedEntity;
        }
        yield UnlikedState(message: 'News feed unliked successfully.');
      } catch (e) {
        log('News feed unlike error.', error: e);
        yield ErrorState(message: 'Unable to unlike.');
      }
    } else if (event is UpdateLikeEvent) {
      _newsFeedUIModel.like();
      yield LikedState(message: 'Feed liked successfully.');
    } else if (event is UpdateUnlikeEvent) {
      _newsFeedUIModel.unlike();
      yield UnlikedState(message: 'News feed unliked successfully.');
    }
  }
}
