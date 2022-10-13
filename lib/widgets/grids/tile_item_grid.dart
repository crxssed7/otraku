import 'package:flutter/material.dart';
import 'package:otraku/common/tile_item.dart';
import 'package:otraku/utils/consts.dart';
import 'package:otraku/widgets/link_tile.dart';
import 'package:otraku/widgets/fade_image.dart';
import 'package:otraku/widgets/grids/sliver_grid_delegates.dart';

class TileItemGrid extends StatelessWidget {
  const TileItemGrid(this.items);

  final List<TileItem> items;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const SliverFillRemaining(child: Center(child: Text('No Media')));
    }

    return SliverPadding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithMinWidthAndExtraHeight(
          minWidth: 100,
          extraHeight: 40,
          rawHWRatio: Consts.coverHtoWRatio,
        ),
        delegate: SliverChildBuilderDelegate(
          childCount: items.length,
          (_, i) => LinkTile(
            id: items[i].id,
            info: items[i].imageUrl,
            discoverType: items[i].type,
            child: Column(
              children: [
                Expanded(
                  child: Hero(
                    tag: items[i].id,
                    child: ClipRRect(
                      borderRadius: Consts.borderRadiusMin,
                      child: Container(
                        color: Theme.of(context).colorScheme.surfaceVariant,
                        child: FadeImage(items[i].imageUrl),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                SizedBox(
                  height: 35,
                  child: Text(
                    items[i].title,
                    maxLines: 2,
                    overflow: TextOverflow.fade,
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}