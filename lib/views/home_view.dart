import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:otraku/controllers/collection_controller.dart';
import 'package:otraku/views/explore_view.dart';
import 'package:otraku/views/collection_view.dart';
import 'package:otraku/views/feed_view.dart';
import 'package:otraku/views/user_view.dart';
import 'package:otraku/utils/background_handler.dart';
import 'package:otraku/utils/client.dart';
import 'package:otraku/utils/config.dart';
import 'package:otraku/widgets/layouts/nav_layout.dart';
import 'package:otraku/widgets/overlays/dialogs.dart';

class HomeView extends StatelessWidget {
  static const FEED = 0;
  static const ANIME_LIST = 1;
  static const MANGA_LIST = 2;
  static const EXPLORE = 3;
  static const PROFILE = 4;

  @override
  Widget build(BuildContext context) {
    final tabs = [
      const HomeFeedView(),
      HomeCollectionView(
        ofAnime: true,
        id: Client.viewerId!,
        collectionTag: CollectionController.ANIME,
        key: UniqueKey(),
      ),
      HomeCollectionView(
        ofAnime: false,
        id: Client.viewerId!,
        collectionTag: CollectionController.MANGA,
        key: UniqueKey(),
      ),
      const ExploreView(),
      HomeUserView(Client.viewerId!, null),
    ];

    final fabs = [
      null,
      CollectionActionButton(CollectionController.ANIME, key: UniqueKey()),
      CollectionActionButton(CollectionController.MANGA, key: UniqueKey()),
      ExploreActionButton(),
      null,
    ];

    BackgroundHandler.checkLaunchedByNotification();

    return WillPopScope(
      onWillPop: () => _onWillPop(context),
      child: ValueListenableBuilder<int>(
        valueListenable: Config.homeNotifier,
        builder: (_, index, __) => NavLayout(
          index: index,
          child: tabs[index],
          floating: fabs[index],
          onChanged: (i) => Config.homeIndex = i,
          items: const {
            'Feed': Ionicons.file_tray_outline,
            'Anime': Ionicons.film_outline,
            'Manga': Ionicons.bookmark_outline,
            'Explore': Ionicons.compass_outline,
            'Profile': Ionicons.person_outline,
          },
        ),
      ),
    );
  }

  Future<bool> _onWillPop(BuildContext ctx) async {
    if (!(Config.storage.read(Config.CONFIRM_EXIT) ?? false))
      return SynchronousFuture(true);

    bool ok = false;
    await showPopUp(
      ctx,
      ConfirmationDialog(
        title: 'Exit?',
        mainAction: 'Yes',
        secondaryAction: 'Never',
        onConfirm: () => ok = true,
      ),
    );

    return Future.value(ok);
  }
}
