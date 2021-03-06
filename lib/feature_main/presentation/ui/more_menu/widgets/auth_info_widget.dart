import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:samachar_hub/core/services/services.dart';
import 'package:samachar_hub/feature_auth/domain/entities/user_entity.dart';
import 'package:samachar_hub/feature_auth/presentation/blocs/auth_bloc.dart';

class AuthInfo extends StatefulWidget {
  @override
  _AuthInfoState createState() => _AuthInfoState();
}

class _AuthInfoState extends State<AuthInfo> {
  Widget _buildUserInfo(BuildContext context, UserEntity user) {
    return InkWell(
      onTap: () {
        GetIt.I.get<NavigationService>().toUserProfileScreen(context: context);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Hero(
            tag: 'profile_pic_tag',
            child: Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Theme.of(context).cardColor,
                image: DecorationImage(
                    image: (user?.avatar?.isNotEmpty ?? false)
                        ? AdvancedNetworkImage(user.avatar, useDiskCache: true)
                        : AssetImage('assets/images/user.png'),
                    fit: BoxFit.cover),
              ),
            ),
          ),
          SizedBox(
            width: 12,
          ),
          Flexible(
            child: Text(
              user.fullname,
              style: Theme.of(context)
                  .textTheme
                  .headline6
                  .copyWith(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSigninButtons(BuildContext context, UserEntity user) {
    return Align(
      alignment: Alignment.center,
      child: OutlineButton(
        onPressed: () {
          GetIt.I.get<NavigationService>().toLoginScreen(context);
        },
        child: Text('Sign In'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Builder(
        builder: (context) {
          final user = context.bloc<AuthBloc>().currentUser;
          if (user != null && !user.isAnonymous) {
            return _buildUserInfo(context, user);
          }
          return _buildSigninButtons(context, user);
        },
      ),
    );
  }
}
