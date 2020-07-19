// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'news_source_feed_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$NewsSourceFeedStore on _NewsSourceFeedStore, Store {
  final _$sortAtom = Atom(name: '_NewsSourceFeedStore.sort');

  @override
  SortBy get sort {
    _$sortAtom.context.enforceReadPolicy(_$sortAtom);
    _$sortAtom.reportObserved();
    return super.sort;
  }

  @override
  set sort(SortBy value) {
    _$sortAtom.context.conditionallyRunInAction(() {
      super.sort = value;
      _$sortAtom.reportChanged();
    }, _$sortAtom, name: '${_$sortAtom.name}_set');
  }

  final _$selectedSourceAtom =
      Atom(name: '_NewsSourceFeedStore.selectedSource');

  @override
  NewsSourceModel get selectedSource {
    _$selectedSourceAtom.context.enforceReadPolicy(_$selectedSourceAtom);
    _$selectedSourceAtom.reportObserved();
    return super.selectedSource;
  }

  @override
  set selectedSource(NewsSourceModel value) {
    _$selectedSourceAtom.context.conditionallyRunInAction(() {
      super.selectedSource = value;
      _$selectedSourceAtom.reportChanged();
    }, _$selectedSourceAtom, name: '${_$selectedSourceAtom.name}_set');
  }

  final _$apiErrorAtom = Atom(name: '_NewsSourceFeedStore.apiError');

  @override
  APIException get apiError {
    _$apiErrorAtom.context.enforceReadPolicy(_$apiErrorAtom);
    _$apiErrorAtom.reportObserved();
    return super.apiError;
  }

  @override
  set apiError(APIException value) {
    _$apiErrorAtom.context.conditionallyRunInAction(() {
      super.apiError = value;
      _$apiErrorAtom.reportChanged();
    }, _$apiErrorAtom, name: '${_$apiErrorAtom.name}_set');
  }

  final _$errorAtom = Atom(name: '_NewsSourceFeedStore.error');

  @override
  String get error {
    _$errorAtom.context.enforceReadPolicy(_$errorAtom);
    _$errorAtom.reportObserved();
    return super.error;
  }

  @override
  set error(String value) {
    _$errorAtom.context.conditionallyRunInAction(() {
      super.error = value;
      _$errorAtom.reportChanged();
    }, _$errorAtom, name: '${_$errorAtom.name}_set');
  }

  final _$_loadFirstPageDataAsyncAction = AsyncAction('_loadFirstPageData');

  @override
  Future<dynamic> _loadFirstPageData() {
    return _$_loadFirstPageDataAsyncAction
        .run(() => super._loadFirstPageData());
  }

  final _$loadMoreDataAsyncAction = AsyncAction('loadMoreData');

  @override
  Future<dynamic> loadMoreData() {
    return _$loadMoreDataAsyncAction.run(() => super.loadMoreData());
  }

  final _$_NewsSourceFeedStoreActionController =
      ActionController(name: '_NewsSourceFeedStore');

  @override
  void loadInitialData() {
    final _$actionInfo = _$_NewsSourceFeedStoreActionController.startAction();
    try {
      return super.loadInitialData();
    } finally {
      _$_NewsSourceFeedStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void retry() {
    final _$actionInfo = _$_NewsSourceFeedStoreActionController.startAction();
    try {
      return super.retry();
    } finally {
      _$_NewsSourceFeedStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  Future<dynamic> refresh() {
    final _$actionInfo = _$_NewsSourceFeedStoreActionController.startAction();
    try {
      return super.refresh();
    } finally {
      _$_NewsSourceFeedStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setSortBy(SortBy value) {
    final _$actionInfo = _$_NewsSourceFeedStoreActionController.startAction();
    try {
      return super.setSortBy(value);
    } finally {
      _$_NewsSourceFeedStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setSource(NewsSourceModel source) {
    final _$actionInfo = _$_NewsSourceFeedStoreActionController.startAction();
    try {
      return super.setSource(source);
    } finally {
      _$_NewsSourceFeedStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    final string =
        'sort: ${sort.toString()},selectedSource: ${selectedSource.toString()},apiError: ${apiError.toString()},error: ${error.toString()}';
    return '{$string}';
  }
}