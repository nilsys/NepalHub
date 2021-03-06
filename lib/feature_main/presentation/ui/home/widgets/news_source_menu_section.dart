import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:samachar_hub/core/services/services.dart';
import 'package:samachar_hub/feature_main/presentation/ui/widgets/section_heading.dart';
import 'package:samachar_hub/feature_news/domain/entities/news_source_entity.dart';
import 'package:samachar_hub/feature_news/presentation/ui/widgets/news_menu_item.dart';

class NewsSourceMenuSection extends StatefulWidget {
  const NewsSourceMenuSection({
    Key key,
    @required this.newsSources,
  }) : super(key: key);

  final List<NewsSourceEntity> newsSources;

  @override
  _NewsSourceMenuSectionState createState() => _NewsSourceMenuSectionState();
}

class _NewsSourceMenuSectionState extends State<NewsSourceMenuSection>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        SectionHeading(
          title: 'Featured Sources',
          onTap: () => GetIt.I
              .get<NavigationService>()
              .toFollowedNewsSourceScreen(context),
        ),
        LimitedBox(
          maxHeight: 100,
          child: Container(
            color: Theme.of(context).cardColor,
            child: ListView.builder(
              itemExtent: 120,
              primary: false,
              itemCount: widget.newsSources.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                var sourceModel = widget.newsSources[index];
                return NewsMenuItem(
                  title: sourceModel.title,
                  icon: sourceModel.icon,
                  onTap: () => GetIt.I
                      .get<NavigationService>()
                      .toNewsSourceFeedScreen(
                          context: context, source: sourceModel),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
