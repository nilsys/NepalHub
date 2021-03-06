import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:samachar_hub/core/usecases/usecase.dart';
import 'package:samachar_hub/feature_news/domain/entities/news_feed_entity.dart';
import 'package:samachar_hub/feature_news/domain/usecases/get_bookmarked_news_use_case.dart';

part 'bookmark_news_event.dart';
part 'bookmark_news_state.dart';

class BookmarkNewsBloc extends Bloc<BookmarkNewsEvent, BookmarkNewsState> {
  final UseCase _getBookmarkNewsUseCase;

  BookmarkNewsBloc({@required UseCase getBookmarkNewsUseCase})
      : this._getBookmarkNewsUseCase = getBookmarkNewsUseCase,
        super(InitialState());

  int _page = 0;
  int get page => _page;

  @override
  Stream<BookmarkNewsState> mapEventToState(
    BookmarkNewsEvent event,
  ) async* {
    if (event is GetBookmarkedNews) {
      yield* _mapGetBookmarkedNewsEventToState(event);
    } else if (event is RefreshBookmarkedNewsEvent) {
      yield* _mapRefreshBookmarkedNewsEventToState(event);
    } else if (event is LoadMoreBookmarkedNewsEvent) {
      yield* _mapLoadMoreBookmarkedNewsEventToState(event);
    }
  }

  Stream<BookmarkNewsState> _mapGetBookmarkedNewsEventToState(
      GetBookmarkedNews event) async* {
    if (state is LoadingState) return;
    yield LoadingState();
    try {
      _page = 1;
      final List<NewsFeedEntity> newsList = await _getBookmarkNewsUseCase.call(
        GetBookmarkedNewsUseCaseParams(
          page: page,
        ),
      );
      if (newsList == null || newsList.isEmpty)
        yield EmptyState(message: 'You have not bookmarked any news yet.');
      else
        yield LoadSuccessState(newsList);
    } catch (e) {
      log('Bookmark news load error.', error: e);
      yield LoadErrorState(
          message:
              'Unable to load data. Make sure you are connected to internet.');
    }
  }

  Stream<BookmarkNewsState> _mapRefreshBookmarkedNewsEventToState(
      RefreshBookmarkedNewsEvent event) async* {
    try {
      final List<NewsFeedEntity> newsList = await _getBookmarkNewsUseCase.call(
        GetBookmarkedNewsUseCaseParams(
          page: 1,
        ),
      );
      if (newsList != null || newsList.isNotEmpty) {
        _page = 1;
        yield LoadSuccessState(newsList);
      } else
        yield ErrorState(message: 'Unable to refresh.');
    } catch (e) {
      log('Refresh bookmark news load error.', error: e);
      yield ErrorState(
          message:
              'Unable to refresh data. Make sure you are connected to internet.');
    }
  }

  Stream<BookmarkNewsState> _mapLoadMoreBookmarkedNewsEventToState(
      LoadMoreBookmarkedNewsEvent event) async* {
    if (state is LoadingState) return;
    final currentState = state;
    try {
      final List<NewsFeedEntity> newsList = await _getBookmarkNewsUseCase.call(
        GetBookmarkedNewsUseCaseParams(
          page: page + 1,
        ),
      );

      if (newsList == null || newsList.isEmpty) {
        if (currentState is LoadSuccessState) {
          yield currentState.copyWith(hasMore: false);
        } else {
          _page = 1;
          yield EmptyState(message: 'You have not bookmarked any news yet.');
        }
      } else {
        _page = _page + 1;
        if (currentState is LoadSuccessState) {
          yield currentState.copyWith(feeds: currentState.feeds + newsList);
        } else
          yield LoadSuccessState(newsList);
      }
    } catch (e) {
      log('Load more bookmark news error.', error: e);
      yield ErrorState(
          message:
              'Unable to load more data. Make sure you are connected to internet.');
    }
  }
}
