// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'personalised_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$PersonalisedNewsStore on _PersonalisedNewsStore, Store {
  final _$apiErrorAtom = Atom(name: '_PersonalisedNewsStore.apiError');

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

  final _$errorAtom = Atom(name: '_PersonalisedNewsStore.error');

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

  final _$viewAtom = Atom(name: '_PersonalisedNewsStore.view');

  @override
  ContentViewStyle get view {
    _$viewAtom.context.enforceReadPolicy(_$viewAtom);
    _$viewAtom.reportObserved();
    return super.view;
  }

  @override
  set view(ContentViewStyle value) {
    _$viewAtom.context.conditionallyRunInAction(() {
      super.view = value;
      _$viewAtom.reportChanged();
    }, _$viewAtom, name: '${_$viewAtom.name}_set');
  }

  final _$refreshAsyncAction = AsyncAction('refresh');

  @override
  Future<void> refresh() {
    return _$refreshAsyncAction.run(() => super.refresh());
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

  final _$_PersonalisedNewsStoreActionController =
      ActionController(name: '_PersonalisedNewsStore');

  @override
  void loadInitialData() {
    final _$actionInfo = _$_PersonalisedNewsStoreActionController.startAction();
    try {
      return super.loadInitialData();
    } finally {
      _$_PersonalisedNewsStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void retry() {
    final _$actionInfo = _$_PersonalisedNewsStoreActionController.startAction();
    try {
      return super.retry();
    } finally {
      _$_PersonalisedNewsStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setView(ContentViewStyle value) {
    final _$actionInfo = _$_PersonalisedNewsStoreActionController.startAction();
    try {
      return super.setView(value);
    } finally {
      _$_PersonalisedNewsStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    final string =
        'apiError: ${apiError.toString()},error: ${error.toString()},view: ${view.toString()}';
    return '{$string}';
  }
}