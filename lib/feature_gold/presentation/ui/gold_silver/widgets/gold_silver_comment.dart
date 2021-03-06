import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:samachar_hub/core/services/services.dart';
import 'package:samachar_hub/core/widgets/comment_bar_widget.dart';
import 'package:samachar_hub/feature_auth/presentation/blocs/auth_bloc.dart';
import 'package:samachar_hub/feature_comment/domain/entities/thread_type.dart';
import 'package:samachar_hub/feature_gold/presentation/blocs/like_unlike/like_unlike_bloc.dart';
import 'package:samachar_hub/feature_gold/presentation/blocs/share/share_bloc.dart';
import 'package:samachar_hub/feature_gold/presentation/models/gold_silver_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scoped_model/scoped_model.dart';

class GoldSilverComment extends StatelessWidget {
  const GoldSilverComment({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = context.bloc<AuthBloc>().currentUser;
    final goldSilverUIModel =
        ScopedModel.of<GoldSilverUIModel>(context, rebuildOnChange: true);
    return CommentBar(
      likeCount: goldSilverUIModel.entity.likeCount ?? 0,
      onCommentTap: () => GetIt.I.get<NavigationService>().toCommentsScreen(
          context: context,
          threadTitle: goldSilverUIModel.entity.category.title,
          threadId: goldSilverUIModel.entity.id,
          threadType: CommentThreadType.GOLD),
      onShareTap: () {
        context
            .bloc<ShareBloc>()
            .add(Share(goldSilver: goldSilverUIModel.entity));
      },
      commentCount: goldSilverUIModel.entity.commentCount ?? 0,
      isLiked: goldSilverUIModel?.entity?.isLiked ?? false,
      shareCount: goldSilverUIModel.entity.shareCount ?? 0,
      userAvatar: user?.avatar,
      onLikeTap: () {
        if (goldSilverUIModel.entity.isLiked) {
          goldSilverUIModel.entity = goldSilverUIModel.entity.copyWith(
              isLiked: false,
              likeCount: goldSilverUIModel.entity.likeCount - 1);
          context
              .bloc<LikeUnlikeBloc>()
              .add(UnlikeEvent(goldSilver: goldSilverUIModel.entity));
        } else {
          goldSilverUIModel.entity = goldSilverUIModel.entity.copyWith(
              isLiked: true, likeCount: goldSilverUIModel.entity.likeCount + 1);
          context
              .bloc<LikeUnlikeBloc>()
              .add(LikeEvent(goldSilver: goldSilverUIModel.entity));
        }
      },
    );
  }
}
