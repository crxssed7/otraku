import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otraku/utils/config.dart';
import 'package:otraku/controllers/explorer.dart';
import 'package:otraku/enums/browsable.dart';
import 'package:otraku/widgets/layouts/review_grid.dart';
import 'package:otraku/widgets/layouts/title_list.dart';
import 'package:otraku/widgets/loader.dart';
import 'package:otraku/widgets/navigation/media_control_header.dart';
import 'package:otraku/widgets/layouts/tile_grid.dart';
import 'package:otraku/widgets/navigation/nav_bar.dart';
import 'package:otraku/widgets/navigation/headline_header.dart';

class ExplorePage extends StatelessWidget {
  const ExplorePage();

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      controller: Get.find<Explorer>().scrollCtrl,
      slivers: [
        const HeadlineHeader('Explore', false),
        MediaControlHeader(),
        _ExploreGrid(),
        _EndOfListLoader(),
        SliverToBoxAdapter(
          child: SizedBox(height: NavBar.offset(context)),
        ),
      ],
    );
  }
}

class _ExploreGrid extends StatelessWidget {
  void _loadMore() {
    final explorable = Get.find<Explorer>();
    if (explorable.hasNextPage && !explorable.isLoading) {
      explorable.loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final explorer = Get.find<Explorer>();

    return Obx(() {
      if (explorer.isLoading)
        return const SliverFillRemaining(child: Center(child: Loader()));

      final results = explorer.results;
      if (results.isEmpty) {
        return SliverFillRemaining(
          child: Center(
            child: Text(
              'No results',
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
        );
      }

      if (results[0].browsable == Browsable.studio)
        return TitleList(results, _loadMore);

      if (results[0].browsable == Browsable.user)
        return TileGrid(
          tileData: results,
          loadMore: _loadMore,
          tileModel: Config.squareTile,
        );

      if (results[0].browsable == Browsable.review)
        return ReviewGrid(results, _loadMore);

      return TileGrid(
        tileData: results,
        loadMore: _loadMore,
        tileModel: Config.highTile,
      );
    });
  }
}

class _EndOfListLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Center(
          child: Obx(
            () => Get.find<Explorer>().hasNextPage &&
                    !Get.find<Explorer>().isLoading
                ? Loader()
                : const SizedBox(),
          ),
        ),
      ),
    );
  }
}