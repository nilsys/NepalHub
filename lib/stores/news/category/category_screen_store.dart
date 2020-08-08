import 'dart:async';

import 'package:mobx/mobx.dart';
import 'package:samachar_hub/data/api/api.dart';
import 'package:samachar_hub/data/models/models.dart';
import 'package:samachar_hub/repository/news_repository.dart';
import 'package:samachar_hub/utils/content_view_type.dart';
import 'package:throttling/throttling.dart';

part 'category_screen_store.g.dart';

class NewsCategoryScreenStore = _NewsCategoryScreenStore
    with _$NewsCategoryScreenStore;

abstract class _NewsCategoryScreenStore with Store {
  final NewsRepository _newsRepository;

  final StreamController<List<NewsCategory>> _dataStreamController =
      StreamController<List<NewsCategory>>();
  final Throttling _throttling = Throttling(duration: Duration(minutes: 1));

  _NewsCategoryScreenStore(this._newsRepository);

  Stream<List<NewsCategory>> get dataStream => _dataStreamController.stream;
  final List<NewsCategory> _data = List<NewsCategory>();

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  @observable
  String error;

  @observable
  APIException apiError;

  @observable
  String activeCategoryTab = 'tops';

  @observable
  ContentViewStyle view = ContentViewStyle.LIST_VIEW;

  @action
  void loadData() {
    _throttling.throttle(() {
      _loadCategories();
    });
  }

  @action
  Future<void> refresh() async {
    return _loadCategories();
  }

  @action
  void retry() {
    _loadCategories();
  }

  @action
  Future<void> _loadCategories() async {
    if (_isLoading) return;
    _isLoading = true;
    _data.clear();
    return _newsRepository.getCategories(followedOnly: true).then((value) {
      if (value != null) {
        _data.addAll(value);
      }
      _dataStreamController.add(_data);
    }).catchError((onError) {
      this.apiError = onError;
      _dataStreamController.addError(onError);
    }, test: (e) => e is APIException).catchError((onError) {
      this.error = 'Unable to load data!';
      _dataStreamController.addError(onError);
    }).whenComplete(() => _isLoading = false);
  }

  @action
  setActiveCategoryTab(String categoryCode) {
    activeCategoryTab = categoryCode;
  }

  @action
  setView(ContentViewStyle value) {
    view = value;
  }

  dispose() {
    _dataStreamController.close();
    _throttling.dispose();
  }
}