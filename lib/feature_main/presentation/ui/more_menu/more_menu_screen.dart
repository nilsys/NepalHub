import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:samachar_hub/core/services/services.dart';
import 'package:samachar_hub/feature_main/presentation/ui/more_menu/widgets/auth_info_widget.dart';
import 'package:samachar_hub/feature_main/presentation/ui/more_menu/widgets/menu_list.dart';
import 'package:samachar_hub/feature_main/presentation/ui/more_menu/widgets/more_menu_list_item.dart';

class MoreMenuScreen extends StatefulWidget {
  @override
  _MoreMenuScreenState createState() => _MoreMenuScreenState();
}

class _MoreMenuScreenState extends State<MoreMenuScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
  }

  Widget _buildSettingsMenu(BuildContext context) {
    return MoreMenuListItem(
      title: 'Settings',
      icon: FontAwesomeIcons.cog,
      onTap: () {
        GetIt.I.get<NavigationService>().toSettingsScreen(context: context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      color: Theme.of(context).backgroundColor,
      child: ListView(
        physics: BouncingScrollPhysics(),
        children: <Widget>[
          SizedBox(height: 8),
          AuthInfo(),
          Divider(
            thickness: 4,
          ),
          MenuList(context: context),
          Divider(
            thickness: 4,
          ),
          _buildSettingsMenu(context),
          Divider(),
          SizedBox(height: 8),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
