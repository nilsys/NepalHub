import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:samachar_hub/core/models/language.dart';
import 'package:samachar_hub/core/services/services.dart';
import 'package:samachar_hub/core/widgets/cached_image_widget.dart';
import 'package:samachar_hub/feature_horoscope/domain/entities/horoscope_entity.dart';
import 'package:samachar_hub/feature_horoscope/presentation/extensions/horoscope_extensions.dart';
import 'package:samachar_hub/feature_main/presentation/blocs/settings/settings_cubit.dart';

class DailyHoroscope extends StatefulWidget {
  final HoroscopeEntity data;
  const DailyHoroscope({Key key, @required this.data}) : super(key: key);

  @override
  _DailyHoroscopeState createState() => _DailyHoroscopeState();
}

class _DailyHoroscopeState extends State<DailyHoroscope>
    with AutomaticKeepAliveClientMixin {
  Widget _buildPopupMenu(BuildContext context) {
    return PopupMenuButton<String>(
      icon: Icon(
        Icons.more_vert,
        color: Theme.of(context).iconTheme.color.withOpacity(0.6),
      ),
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        PopupMenuItem<String>(
          value: 'default',
          child: Text(
            'Setting',
            style: Theme.of(context).textTheme.caption,
          ),
        ),
      ],
      onSelected: (value) =>
          GetIt.I.get<NavigationService>().toSettingsScreen(context: context),
    );
  }

  Widget _buildSignRow(
      BuildContext context, String sign, String signIcon, String date) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 34,
            height: 34,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Theme.of(context).canvasColor,
              shape: BoxShape.circle,
            ),
            child: CachedImage(
              signIcon,
              tag: sign,
            ),
          ),
          SizedBox(
            width: 8,
          ),
          RichText(
            text: TextSpan(
              text: sign,
              style: Theme.of(context)
                  .textTheme
                  .subtitle1
                  .copyWith(fontWeight: FontWeight.w500),
              children: <TextSpan>[
                TextSpan(
                    text: '\n$date', style: Theme.of(context).textTheme.caption)
              ],
            ),
          ),
          Spacer(),
          _buildPopupMenu(context),
        ],
      ),
    );
  }

  Widget _buildHoroscopeRow(BuildContext context, String horoscope) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12.0, 4.0, 12.0, 12),
      child: Text(
        horoscope,
        maxLines: 3,
        style: Theme.of(context).textTheme.subtitle1.copyWith(height: 1.3),
      ),
    );
  }

  Widget _buildCard(BuildContext context, int defaultHoroscopeSign) {
    final sign = widget.data.signByIndex(defaultHoroscopeSign, Language.NEPALI);
    final signIcon = widget.data.signIconByIndex(defaultHoroscopeSign);
    final horoscope =
        widget.data.horoscopeByIndex(defaultHoroscopeSign, Language.NEPALI);
    return Card(
      clipBehavior: Clip.hardEdge,
      color: Theme.of(context).cardColor,
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
      ),
      child: InkWell(
        onTap: () => GetIt.I
            .get<NavigationService>()
            .toHoroscopeDetail(context, sign, signIcon, horoscope, widget.data),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildSignRow(context, sign, signIcon, widget.data.formattedDate),
            Divider(),
            _buildHoroscopeRow(context, horoscope),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final settingsCubit = context.bloc<SettingsCubit>();
    return FadeInUp(
      child:
          _buildCard(context, settingsCubit.settings.defaultHoroscopeSign ?? 0),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
