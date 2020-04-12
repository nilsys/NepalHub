import 'package:flutter/material.dart';
import 'package:samachar_hub/data/model/feed.dart';
import 'package:samachar_hub/util/helper.dart';

class ArticleInfoWidget extends StatelessWidget {

  ArticleInfoWidget(this.article);

  final Feed article;

  String _articleSource(FeedSource source) => source == null ? '' : source.name + ' • ';

  String _publishedAt(String publishedAt) =>
      publishedAt == null ? '' : relativeTimeString(DateTime.parse(publishedAt));

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(article.title),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Text(
            article.author ?? 'Unknown Author',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.display3.copyWith(color: Theme.of(context).accentColor),
          ),
        ),
        Opacity(
          opacity: 0.75,
          child: Text(
            _articleSource(article.source) + _publishedAt(article.publishedAt),
            style: Theme.of(context).textTheme.display4,
          ),
        )
      ],
    );
  }
}
