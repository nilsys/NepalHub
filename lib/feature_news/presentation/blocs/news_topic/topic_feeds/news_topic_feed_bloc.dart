import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:samachar_hub/core/models/language.dart';
import 'package:samachar_hub/core/usecases/usecase.dart';
import 'package:samachar_hub/feature_news/domain/entities/news_feed_entity.dart';
import 'package:samachar_hub/feature_news/domain/entities/news_source_entity.dart';
import 'package:samachar_hub/feature_news/domain/entities/news_topic_entity.dart';
import 'package:samachar_hub/feature_news/domain/entities/sort.dart';
import 'package:samachar_hub/feature_news/domain/usecases/get_news_by_topic_use_case.dart';
import 'package:samachar_hub/feature_news/presentation/blocs/news_filter/news_filter_bloc.dart';

part 'news_topic_feed_event.dart';
part 'news_topic_feed_state.dart';

class NewsTopicFeedBloc extends Bloc<NewsTopicFeedEvent, NewsTopicFeedState> {
  final UseCase _newsByTopicUseCase;
  final NewsFilterBloc _newsFilterBloc;
  final NewsTopicEntity _topic;

  SortBy _sortBy;
  NewsSourceEntity _source;
  int _page = 1;

  SortBy get sortBy => _sortBy;

  NewsSourceEntity get sourceModel => _source;
  int get page => _page;

  NewsTopicEntity get topic => _topic;
  StreamSubscription _newsFilterBlocSubscription;

  NewsTopicFeedBloc(
      {@required UseCase newsByTopicUseCase,
      @required NewsTopicEntity topic,
      @required NewsFilterBloc newsFilterBloc})
      : this._newsByTopicUseCase = newsByTopicUseCase,
        this._topic = topic,
        this._newsFilterBloc = newsFilterBloc,
        super(NewsTopicFeedInitialState(topic: topic)) {
    this._sortBy = _newsFilterBloc.selectedSortBy;
    this._source = _newsFilterBloc.selectedSource;
    this._newsFilterBlocSubscription = this._newsFilterBloc.listen((state) {
      if (state is SourceChangedState) {
        this._source = state.source;
        this.add(GetTopicNewsEvent());
      } else if (state is SortByChangedState) {
        this._sortBy = state.sortBy;
        this.add(GetTopicNewsEvent());
      }
    });
  }

  @override
  Future<void> close() {
    _newsFilterBlocSubscription?.cancel();
    return super.close();
  }

  @override
  Stream<NewsTopicFeedState> mapEventToState(
    NewsTopicFeedEvent event,
  ) async* {
    if (event is GetTopicNewsEvent) {
      yield* _mapGetTopicNewsEventToState(event);
    } else if (event is GetMoreTopicNewsEvent) {
      yield* _mapGetMoreTopicNewsEventToState(event);
    } else if (event is RefreshTopicNewsEvent) {
      yield* _mapRefreshTopicNewsToState(event);
    } else if (event is FeedChangeEvent) {
      yield* _mapFeedChangeEventToState(event);
    }
  }

  Stream<NewsTopicFeedState> _mapRefreshTopicNewsToState(
      RefreshTopicNewsEvent event) async* {
    if (state is NewsTopicFeedLoadingState) return;
    try {
      final List<NewsFeedEntity> newsList = await _newsByTopicUseCase.call(
        GetNewsByTopicUseCaseParams(
          topic: topic,
          source: sourceModel,
          sortBy: sortBy,
          page: 1,
        ),
      );
      if (newsList != null && newsList.isNotEmpty) {
        _page = 1;
        yield NewsTopicFeedLoadSuccessState(feeds: newsList, hasMore: true);
      } else {
        yield NewsTopicFeedErrorState(message: 'Unable to refresh data.');
      }
    } catch (e) {
      log('News by topic load error.', error: e);
      yield NewsTopicFeedErrorState(
          message:
              'Unable to refresh data. Make sure you are connected to Internet.');
    }
  }

  Stream<NewsTopicFeedState> _mapGetMoreTopicNewsEventToState(
      GetMoreTopicNewsEvent event) async* {
    final currentState = state;
    if (currentState is NewsTopicFeedMoreLoadingState) return;
    yield NewsTopicFeedMoreLoadingState();
    try {
      final List<NewsFeedEntity> newsList = await _newsByTopicUseCase.call(
        GetNewsByTopicUseCaseParams(
            topic: topic,
            source: sourceModel,
            sortBy: sortBy,
            page: page + 1,
            language: event.language),
      );
      if (newsList == null || newsList.isEmpty) {
        if (currentState is NewsTopicFeedLoadSuccessState) {
          yield currentState.copyWith(hasMore: false);
        } else
          yield NewsTopicFeedEmptyState(message: 'News feed not available');
      } else {
        _page = _page + 1;
        if (currentState is NewsTopicFeedLoadSuccessState) {
          yield currentState.copyWith(feeds: currentState.feeds + newsList);
        } else
          yield NewsTopicFeedLoadSuccessState(feeds: newsList, hasMore: true);
      }
    } catch (e) {
      log('News by topic load more cache error.', error: e);
      if (currentState is NewsTopicFeedLoadSuccessState) {
        yield currentState.copyWith(hasMore: false);
      } else
        yield NewsTopicFeedErrorState(
            message:
                'Unable to load data. Make sure you are connected to Internet.');
    }
  }

  Stream<NewsTopicFeedState> _mapGetTopicNewsEventToState(
      GetTopicNewsEvent event) async* {
    if (state is NewsTopicFeedLoadingState) return;
    yield NewsTopicFeedLoadingState();
    try {
      _page = 1;
      final List<NewsFeedEntity> newsList = await _newsByTopicUseCase.call(
        GetNewsByTopicUseCaseParams(
          topic: topic,
          source: sourceModel,
          sortBy: sortBy,
          page: page,
          language: event.language,
        ),
      );
      if (newsList == null || newsList.isEmpty)
        yield NewsTopicFeedEmptyState(message: 'News feed not available.');
      else
        yield NewsTopicFeedLoadSuccessState(feeds: newsList, hasMore: true);
    } catch (e) {
      log('News by topic load error.', error: e);
      yield NewsTopicFeedLoadErrorState(
          message:
              'Unable to load data. Make sure you are connected to internet.');
    }
  }

  Stream<NewsTopicFeedState> _mapFeedChangeEventToState(
      FeedChangeEvent event) async* {
    try {
      final currentState = state;
      if (currentState is NewsTopicFeedLoadSuccessState) {
        if (event.eventType == 'feed') {
          final feed = (event.data as NewsFeedEntity);
          final index =
              currentState.feeds.indexWhere((element) => element.id == feed.id);
          if (index != -1) {
            final feeds = List<NewsFeedEntity>.from(currentState.feeds);
            feeds[index] = feed;
            yield currentState.copyWith(feeds: feeds);
          }
        } else if (event.eventType == 'source') {
          final source = (event.data as NewsSourceEntity);
          final feeds = currentState.feeds.map<NewsFeedEntity>((e) {
            if (e.source.id == source.id) {
              return e.copyWith(source: source);
            }
            return e;
          }).toList();

          yield currentState.copyWith(feeds: feeds);
        }
      }
    } catch (e) {
      log('Update change event of ${event.eventType} error: ', error: e);
    }
  }
}
