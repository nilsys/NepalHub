import 'dart:async';

import 'package:flutter/material.dart';
import 'package:samachar_hub/feature_news/presentation/blocs/news_category/category_feeds/news_category_feed_bloc.dart';
import 'package:samachar_hub/feature_news/presentation/ui/widgets/news_list_builder_widget.dart';
import 'package:samachar_hub/core/widgets/empty_data_widget.dart';
import 'package:samachar_hub/core/widgets/error_data_widget.dart';
import 'package:samachar_hub/core/widgets/progress_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:samachar_hub/core/extensions/view.dart';

class NewsCategoryFeedList extends StatefulWidget {
  const NewsCategoryFeedList({
    Key key,
  }) : super(key: key);

  @override
  _NewsCategoryFeedListState createState() => _NewsCategoryFeedListState();
}

class _NewsCategoryFeedListState extends State<NewsCategoryFeedList> {
  Completer<void> _refreshCompleter;
  NewsCategoryFeedBloc _newsCategoryFeedBloc;

  @override
  void initState() {
    super.initState();
    _refreshCompleter = Completer<void>();
    _newsCategoryFeedBloc = context.bloc<NewsCategoryFeedBloc>();
  }

  Future<void> _onRefresh() {
    _newsCategoryFeedBloc.add(RefreshCategoryNewsEvent());
    return _refreshCompleter.future;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NewsCategoryFeedBloc, NewsCategoryFeedState>(
        cubit: _newsCategoryFeedBloc,
        listener: (context, state) {
          if (!(state is Loading)) {
            _refreshCompleter?.complete();
            _refreshCompleter = Completer();
          }
          if (state is ErrorState) {
            context.showMessage(state.message);
          } else if (state is RefreshError) {
            context.showMessage(state.message);
          }
        },
        buildWhen: (previous, current) => (current is Initial ||
            current is LoadSuccess ||
            current is Empty ||
            current is ErrorState ||
            current is Loading),
        builder: (context, state) {
          if (state is LoadSuccess) {
            return NewsListBuilder(
              data: state.feeds,
              onRefresh: _onRefresh,
              hasMore: state.hasMore,
            );
          } else if (state is Empty) {
            return Center(
              child: EmptyDataView(
                text: state.message,
              ),
            );
          } else if (state is ErrorState) {
            return Center(
              child: ErrorDataView(
                onRetry: () =>
                    _newsCategoryFeedBloc.add(RetryCategoryNewsEvent()),
              ),
            );
          }
          return Center(child: ProgressView());
        });
  }
}