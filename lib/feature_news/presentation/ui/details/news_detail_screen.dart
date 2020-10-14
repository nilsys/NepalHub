import 'package:flutter/material.dart';
import 'package:samachar_hub/core/services/services.dart';
import 'package:samachar_hub/core/widgets/comment_bar_placeholder_widget.dart';
import 'package:samachar_hub/core/widgets/empty_data_widget.dart';
import 'package:samachar_hub/core/widgets/error_data_widget.dart';
import 'package:samachar_hub/core/widgets/progress_widget.dart';
import 'package:samachar_hub/feature_news/domain/models/news_feed.dart';
import 'package:samachar_hub/feature_news/domain/usecases/get_news_detail_use_case.dart';
import 'package:samachar_hub/feature_news/presentation/blocs/like_unlike/like_unlike_bloc.dart'
    as likeUnlikeBloc;
import 'package:samachar_hub/feature_news/presentation/blocs/news_detail/news_detail_bloc.dart'
    as newsDetailBloc;
import 'package:samachar_hub/feature_news/presentation/blocs/share/share_bloc.dart';
import 'package:samachar_hub/feature_news/presentation/models/news_feed.dart';
import 'package:samachar_hub/feature_news/presentation/ui/details/widgets/article_detail.dart';
import 'package:samachar_hub/feature_news/presentation/ui/widgets/news_feed_more_option.dart';
import 'package:samachar_hub/feature_news/presentation/extensions/news_extensions.dart';
import 'package:samachar_hub/core/widgets/cached_image_widget.dart';
import 'package:samachar_hub/core/widgets/comment_bar_widget.dart';
import 'package:samachar_hub/core/extensions/view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NewsDetailScreen extends StatelessWidget {
  final String feedId;
  final NewsFeedEntity feedEntity;

  const NewsDetailScreen({Key key, this.feedId, this.feedEntity})
      : super(key: key);
  Widget _buildBody(BuildContext context, NewsFeedUIModel feedUIModel) {
    return OrientationBuilder(
      builder: (_, Orientation orientation) {
        switch (orientation) {
          case Orientation.landscape:
            return SafeArea(
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Expanded(
                    child: CachedImage(
                      feedUIModel.feed.image,
                      tag: feedUIModel.tag,
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                        child: ArticleDetail(
                            context: context, feedUIModel: feedUIModel)),
                  ),
                ],
              ),
            );
            break;
          default:
            return CustomScrollView(
              slivers: <Widget>[
                SliverAppBar(
                  pinned: true,
                  expandedHeight: MediaQuery.of(context).size.height * 0.3,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Stack(
                      fit: StackFit.expand,
                      children: [
                        CachedImage(
                          feedUIModel.feed.image,
                          tag: feedUIModel.tag,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.black45,
                                Colors.black12,
                                Colors.transparent
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    IconButton(
                      visualDensity: VisualDensity.compact,
                      icon: Icon(Icons.more_vert),
                      onPressed: () => context.showBottomSheet(
                        child: NewsFeedMoreOption(feed: feedUIModel),
                      ),
                    ),
                  ],
                ),
                SliverFillRemaining(
                  hasScrollBody: false,
                  child:
                      ArticleDetail(context: context, feedUIModel: feedUIModel),
                ),
              ],
            );
            break;
        }
      },
    );
  }

  Widget _buildCommentBar(NewsFeedUIModel feedUIModel) {
    return BlocBuilder<likeUnlikeBloc.LikeUnlikeBloc,
        likeUnlikeBloc.LikeUnlikeState>(
      builder: (context, state) {
        return CommentBar(
          likeCount: feedUIModel?.formattedLikeCount ?? '0',
          onCommentTap: () => context
              .repository<NavigationService>()
              .toCommentsScreen(
                  context: context,
                  title: feedUIModel.feed.title,
                  postId: feedUIModel.feed.id),
          onShareTap: () {
            context.bloc<ShareBloc>().add(Share());
          },
          commentCount: feedUIModel?.formattedCommentCount ?? '0',
          isLiked: feedUIModel?.feed?.isLiked ?? false,
          shareCount: feedUIModel?.formattedShareCount ?? '0',
          userAvatar: null,
          onLikeTap: () {
            if (feedUIModel.feed.isLiked) {
              feedUIModel.unlike();
              context
                  .bloc<likeUnlikeBloc.LikeUnlikeBloc>()
                  .add(likeUnlikeBloc.UnlikeEvent());
            } else {
              feedUIModel.like();
              context
                  .bloc<likeUnlikeBloc.LikeUnlikeBloc>()
                  .add(likeUnlikeBloc.LikeEvent());
            }
          },
        );
      },
    );
  }

  Widget _buildComment() {
    return BlocBuilder<newsDetailBloc.NewsDetailBloc,
        newsDetailBloc.NewsDetailState>(
      buildWhen: (previous, current) => !(current is newsDetailBloc.ErrorState),
      builder: (context, state) {
        if (state is newsDetailBloc.LoadSuccessState) {
          return _buildCommentBar(state.feed);
        }
        return const CommentBarPlaceholder();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<newsDetailBloc.NewsDetailBloc>(
      create: (context) => newsDetailBloc.NewsDetailBloc(
        feed: feedEntity.toUIModel,
        feedId: feedId,
        getDetailNewsUseCase: context.repository<GetNewsDetailUseCase>(),
      )..add(newsDetailBloc.GetNewsDetailEvent()),
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: BlocConsumer<newsDetailBloc.NewsDetailBloc,
                newsDetailBloc.NewsDetailState>(
            listener: (context, state) {
              if (state is newsDetailBloc.ErrorState) {
                context.showMessage(state.message);
              } else if (state is newsDetailBloc.LoadErrorState) {
                context.showMessage(state.message);
              }
            },
            buildWhen: (previous, current) =>
                !(current is newsDetailBloc.ErrorState),
            builder: (context, state) {
              if (state is newsDetailBloc.LoadSuccessState) {
                return _buildBody(context, state.feed);
              } else if (state is newsDetailBloc.LoadErrorState) {
                return Center(
                  child: ErrorDataView(
                    onRetry: () => context
                        .bloc<newsDetailBloc.NewsDetailBloc>()
                        .add(newsDetailBloc.GetNewsDetailEvent()),
                    message: state.message,
                  ),
                );
              } else if (state is newsDetailBloc.EmptyState) {
                return Center(
                  child: EmptyDataView(
                    text: state.message,
                  ),
                );
              }

              return Center(
                child: ProgressView(),
              );
            }),
        bottomNavigationBar: BottomAppBar(
          child: _buildComment(),
        ),
      ),
    );
  }
}