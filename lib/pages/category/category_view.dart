import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:incrementally_loading_listview/incrementally_loading_listview.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:samachar_hub/common/service/navigation_service.dart';
import 'package:samachar_hub/data/api/api.dart';
import 'package:samachar_hub/data/dto/feed_dto.dart';
import 'package:samachar_hub/pages/category/categories_page.dart';
import 'package:samachar_hub/pages/category/categories_store.dart';
import 'package:samachar_hub/pages/widgets/news_compact_view.dart';
import 'package:samachar_hub/pages/widgets/news_list_view.dart';
import 'package:samachar_hub/pages/widgets/news_thumbnail_view.dart';

class NewsCategoryView extends StatelessWidget {
  final NewsCategory category;

  NewsCategoryView(this.category);

  @override
  Widget build(BuildContext context) {
    return Consumer2<CategoriesStore, NavigationService>(
        builder: (context, categoriesStore, _navigationService, child) {
      return Observer(builder: (_) {
        switch (categoriesStore.loadFeedItemsFuture[category]?.status) {
          case FutureStatus.pending:
            return Center(
              // Todo: Replace with Shimmer
              child: CircularProgressIndicator(),
            );
          case FutureStatus.rejected:
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Oops something went wrong'),
                  RaisedButton(
                    child: Text('Retry'),
                    onPressed: () {
                      categoriesStore.retry(category);
                    },
                  ),
                ],
              ),
            );
          case FutureStatus.fulfilled:
            final List<Feed> newsData = categoriesStore.newsData[category];
            if (null != newsData && newsData.isNotEmpty) {
              final MenuItem viewType = categoriesStore.view;
              return RefreshIndicator(
                child: IncrementallyLoadingListView(
                    hasMore: () =>
                        categoriesStore.hasMoreData[category] ?? true,
                    itemCount: () => newsData.length,
                    loadMore: () async {
                      await categoriesStore.loadMoreData(category);
                    },
                    loadMoreOffsetFromBottom: 2,
                    itemBuilder: (BuildContext context, int index) {
                      final feed = newsData[index];
                      Widget articleWidget;
                      switch (viewType) {
                        case MenuItem.LIST_VIEW:
                          articleWidget = NewsListView(feed:feed);
                          break;
                        case MenuItem.THUMBNAIL_VIEW:
                          articleWidget = NewsThumbnailView(feed);
                          break;
                        case MenuItem.COMPACT_VIEW:
                          articleWidget = NewsCompactView(feed);
                          break;
                      }
                      if (index == newsData.length - 1 &&
                              categoriesStore.hasMoreData[category] ??
                          true && !categoriesStore.isLoadingMore[category] ??
                          false) {
                        return Column(
                          children: <Widget>[
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () => _navigationService.onFeedClick(
                                    feed, context),
                                child: articleWidget,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CircularProgressIndicator(),
                            ),
                          ],
                        );
                      } else {
                        return Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () =>
                                _navigationService.onFeedClick(feed, context),
                            child: articleWidget,
                          ),
                        );
                      }
                    }),
                onRefresh: () async {
                  await categoriesStore.refresh(category);
                },
              );
            }
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Empty Data!'),
                  RaisedButton(
                      child: Text('Retry'),
                      onPressed: () async {
                        categoriesStore.retry(category);
                      }),
                ],
              ),
            );
          default:
            return Center(
              // Todo: Replace with Shimmer
              child: CircularProgressIndicator(),
            );
        }
      });
    });
  }
}