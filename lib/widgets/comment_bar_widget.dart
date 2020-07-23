import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:samachar_hub/widgets/icon_badge_widget.dart';

class CommentBar extends StatefulWidget {
  final String userProfileImageUrl;

  final bool isLiked;
  final Future Function(bool) onLikeTap;
  final VoidCallback onCommentTap;
  final VoidCallback onShareTap;
  final String commentsCount;
  final String likesCount;
  CommentBar({
    Key key,
    this.userProfileImageUrl,
    @required this.isLiked,
    @required this.onLikeTap,
    @required this.onCommentTap,
    @required this.onShareTap,
    @required this.commentsCount,
    @required this.likesCount,
  }) : super(key: key);

  @override
  _CommentBarState createState() => _CommentBarState();
}

class _CommentBarState extends State<CommentBar> {
  final ValueNotifier<bool> _likeProgressNotifier = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _likeNotifier = ValueNotifier<bool>(false);
  bool isLiked;
  @override
  void initState() {
    super.initState();
    this._likeNotifier.value = widget.isLiked;
  }

  @override
  void dispose() {
    super.dispose();
    _likeProgressNotifier.dispose();
    _likeNotifier.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
            top: BorderSide(color: Theme.of(context).dividerColor, width: 0.5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: GestureDetector(
              onTap: () => widget.onCommentTap(),
              child: Container(
                height: 34,
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.2),
                    borderRadius: BorderRadius.all(Radius.circular(30))),
                child: Row(
                  children: <Widget>[
                    CircleAvatar(
                      radius: 12,
                      backgroundImage: (widget.userProfileImageUrl == null ||
                              widget.userProfileImageUrl.isEmpty)
                          ? AssetImage('assets/images/user.png')
                          : CachedNetworkImageProvider(
                              widget.userProfileImageUrl,
                              errorListener: () {}),
                      backgroundColor:
                          Theme.of(context).primaryColor.withOpacity(0.3),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      '${widget.commentsCount} Comments',
                      style: Theme.of(context).textTheme.caption,
                    ),
                  ],
                ),
              ),
            ),
          ),
          IconBadge(
              iconData: FontAwesomeIcons.comment,
              badgeText: widget.commentsCount,
              onTap: () => widget.onCommentTap()),
          ValueListenableBuilder(
            valueListenable: _likeNotifier,
            builder: (context, isLiked, child) {
              return ValueListenableBuilder(
                  valueListenable: _likeProgressNotifier,
                  builder: (_, value, Widget child) {
                    return IgnorePointer(
                      ignoring: value,
                      child: IconBadge(
                          iconData: isLiked
                              ? FontAwesomeIcons.solidThumbsUp
                              : FontAwesomeIcons.thumbsUp,
                          badgeText: widget.likesCount,
                          onTap: () {
                            _likeProgressNotifier.value = true;
                            _likeNotifier.value = !_likeNotifier.value;
                            widget.onLikeTap(widget.isLiked).whenComplete(
                                () => _likeProgressNotifier.value = false);
                          }),
                    );
                  });
            },
          ),
          IconButton(
            icon: Icon(
              FontAwesomeIcons.shareAlt,
              size: 16,
            ),
            onPressed: widget.onShareTap,
          ),
        ],
      ),
    );
  }
}
