import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:samachar_hub/core/services/services.dart';
import 'package:samachar_hub/core/widgets/empty_data_widget.dart';
import 'package:samachar_hub/core/widgets/error_data_widget.dart';
import 'package:samachar_hub/core/widgets/progress_widget.dart';
import 'package:samachar_hub/feature_news/presentation/blocs/news_topic/news_topic_bloc.dart';
import 'package:samachar_hub/feature_news/presentation/ui/widgets/news_menu_item.dart';
import 'package:samachar_hub/core/extensions/view.dart';

class FollowedNewsTopicList extends StatefulWidget {
  const FollowedNewsTopicList({
    Key key,
  }) : super(key: key);

  @override
  _FollowedNewsTopicListState createState() => _FollowedNewsTopicListState();
}

class _FollowedNewsTopicListState extends State<FollowedNewsTopicList> {
  @override
  void initState() {
    super.initState();
    context.bloc<NewsTopicBloc>().add(GetFollowedTopicsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NewsTopicBloc, NewsTopicState>(
      listener: (context, state) {
        if (state is NewsTopicLoadErrorState) {
          context.showMessage(state.message);
        }
      },
      builder: (context, state) {
        if (state is NewsTopicLoadSuccessState) {
          return FadeInUp(
            duration: Duration(milliseconds: 200),
            child: LimitedBox(
              maxHeight: 100,
              child: ListView.builder(
                primary: false,
                itemExtent: 120,
                scrollDirection: Axis.horizontal,
                itemCount: state.topics.length,
                itemBuilder: (_, index) {
                  var topic = state.topics[index];
                  return NewsMenuItem(
                    title: topic.title,
                    icon: topic.icon,
                    onTap: () {
                      GetIt.I.get<NavigationService>().toNewsTopicFeedScreen(
                          context: context, topic: topic);
                    },
                  );
                },
              ),
            ),
          );
        } else if (state is NewsTopicLoadErrorState) {
          return Center(
            child: ErrorDataView(
              message: state.message,
              onRetry: () {
                context.bloc<NewsTopicBloc>().add(GetFollowedTopicsEvent());
              },
            ),
          );
        } else if (state is NewsTopicLoadEmptyState) {
          return Center(
            child: EmptyDataView(
              text: state.message,
            ),
          );
        }
        return Center(child: ProgressView());
      },
    );
  }
}
