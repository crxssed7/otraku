import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:otraku/models/related_review_model.dart';
import 'package:otraku/constants/consts.dart';
import 'package:otraku/controllers/media_controller.dart';
import 'package:otraku/constants/explorable.dart';
import 'package:otraku/utils/pagination_controller.dart';
import 'package:otraku/widgets/charts.dart';
import 'package:otraku/widgets/explore_indexer.dart';
import 'package:otraku/widgets/fade_image.dart';
import 'package:otraku/widgets/grids/sliver_grid_delegates.dart';
import 'package:otraku/widgets/navigation/app_bars.dart';
import 'package:otraku/widgets/navigation/tab_segments.dart';

abstract class MediaSocialView {
  static List<Widget> children(BuildContext ctx, MediaController ctrl) {
    final model = ctrl.model!;

    return [
      ShadowSliverAppBar([
        Expanded(
          child: TabSegments(
            items: const {'Reviews': false, 'Stats': true},
            initial: ctrl.socialTabToggled,
            onChanged: (bool val) {
              ctrl.scrollCtrl.scrollUpTo(0);
              ctrl.socialTabToggled = val;
            },
          ),
        ),
      ]),
      if (!ctrl.socialTabToggled)
        _ReviewGrid(model.reviews.items, model.info.banner)
      else ...[
        if (model.stats.rankTexts.isNotEmpty)
          _Ranks(model.stats.rankTexts, model.stats.rankTypes),
        if (model.stats.scoreNames.isNotEmpty)
          _Scores(model.stats.scoreNames, model.stats.scoreValues),
        if (model.stats.statusNames.isNotEmpty)
          _Statuses(model.stats.statusNames, model.stats.statusValues),
      ],
    ];
  }
}

class _ReviewGrid extends StatelessWidget {
  _ReviewGrid(this.items, this.bannerUrl);

  final List<RelatedReviewModel> items;
  final String? bannerUrl;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty)
      return SliverFillRemaining(
        child: Center(
          child: Text(
            'No reviews',
            style: Theme.of(context).textTheme.subtitle1,
          ),
        ),
      );

    return SliverPadding(
      padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
      sliver: SliverGrid(
        delegate: SliverChildBuilderDelegate(
          (_, i) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ExploreIndexer(
                id: items[i].userId,
                text: items[i].avatar,
                explorable: Explorable.user,
                child: Row(
                  children: [
                    Hero(
                      tag: items[i].userId,
                      child: ClipRRect(
                        borderRadius: Consts.borderRadiusMin,
                        child: FadeImage(
                          items[i].avatar,
                          height: 50,
                          width: 50,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(items[i].username),
                  ],
                ),
              ),
              const SizedBox(height: 5),
              Expanded(
                child: ExploreIndexer(
                  id: items[i].reviewId,
                  text: bannerUrl,
                  explorable: Explorable.review,
                  child: Container(
                    width: double.infinity,
                    padding: Consts.padding,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: Consts.borderRadiusMin,
                    ),
                    child: Text(
                      items[i].summary,
                      style: Theme.of(context).textTheme.subtitle1,
                      overflow: TextOverflow.fade,
                    ),
                  ),
                ),
              ),
            ],
          ),
          childCount: items.length,
        ),
        gridDelegate: const SliverGridDelegateWithMinWidthAndFixedHeight(
          minWidth: 300,
          height: 140,
        ),
      ),
    );
  }
}

class _Ranks extends StatelessWidget {
  _Ranks(this.rankTexts, this.rankTypes);
  final List<String> rankTexts;
  final List<bool> rankTypes;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithMinWidthAndFixedHeight(
          height: Consts.tapTargetSize,
          minWidth: 185,
        ),
        delegate: SliverChildBuilderDelegate(
          (_, i) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: Consts.borderRadiusMin,
            ),
            child: Row(
              children: [
                Icon(
                  rankTypes[i] ? Ionicons.star : Icons.favorite_rounded,
                  size: Consts.iconBig,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: Text(
                    rankTexts[i],
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
              ],
            ),
          ),
          childCount: rankTexts.length,
        ),
      ),
    );
  }
}

class _Scores extends StatelessWidget {
  _Scores(this.scoreNames, this.scoreValues);
  final List<int> scoreNames;
  final List<int> scoreValues;

  @override
  Widget build(BuildContext context) => SliverToBoxAdapter(
        child: BarChart(
          title: 'Score Distribution',
          names: scoreNames,
          values: scoreValues,
        ),
      );
}

class _Statuses extends StatelessWidget {
  _Statuses(this.statusNames, this.statusValues);
  final List<String> statusNames;
  final List<int> statusValues;

  @override
  Widget build(BuildContext context) => SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: PieChart(
            title: 'Status Distribution',
            names: statusNames,
            values: statusValues,
          ),
        ),
      );
}
