import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info/package_info.dart';
import 'package:pandemia_mobile/blocs/blocs.dart';
import 'package:pandemia_mobile/blocs/feed/feed_bloc.dart';
import 'package:pandemia_mobile/blocs/issue/issue_bloc.dart';
import 'package:pandemia_mobile/blocs/notif/notif_bloc.dart';
import 'package:pandemia_mobile/blocs/pandemia/pandemia.dart';
import 'package:pandemia_mobile/core/core.dart';
import 'package:pandemia_mobile/models/models.dart';
import 'package:pandemia_mobile/notification_util.dart';
import 'package:pandemia_mobile/screens/feed/feed_tab_screen.dart';
import 'package:pandemia_mobile/screens/issue/issue_page.dart';
import 'package:pandemia_mobile/widgets/widgets.dart';

import '../core/core.dart';
import 'package:pandemia_mobile/screens/stats/stats_page.dart';

@immutable
class HomeScreen extends StatelessWidget {
  final String title;
  final PandemiaBloc pandemiaBloc;

  HomeScreen({Key key, this.title, this.pandemiaBloc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final pandemiaBloc = BlocProvider.of<PandemiaBloc>(context);
    final tabBloc = BlocProvider.of<TabBloc>(context);
    final notifBloc = BlocProvider.of<NotifBloc>(context);
    final feedBloc = BlocProvider.of<FeedBloc>(context);
    final issueBloc = BlocProvider.of<IssueBloc>(context);

    new Future.delayed(Duration.zero, () {
      NotificationUtil().init(context, notifBloc, feedBloc);
    });

    return BlocBuilder<TabBloc, AppTab>(
      builder: (context, activeTab) {
        Widget body;
        if (activeTab == AppTab.updates) {
          body = FeedTabScreen(context, feedBloc);
        } else if (activeTab == AppTab.stats) {
          body = StatsPage();
        } else if (activeTab == AppTab.map) {
          body = Container();
        } else if (activeTab == AppTab.hoax) {
          body = IssuePage(issueBloc);
        } else {
          // @TODO(*): fix this
          body = Container();
        }
        return Scaffold(
          appBar: AppBar(
            elevation: 2.0,
            leading: Image.asset("assets/img/pandemia-logo-32.png"),
            title: Text(title, style: TextStyle()),
            titleSpacing: 0.0,
            actions: [
              FlatButton(
                child: Icon(
                  Icons.info,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.of(context).pushNamed(PandemiaRoutes.about);
                },
              )
            ],
          ),
          body: body,
          bottomNavigationBar: TabSelector(
            activeTab: activeTab,
            onTabSelected: (tab) => tabBloc.dispatch(UpdateTab(tab)),
          ),
        );
      },
    );
  }
}
