import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ionicons/ionicons.dart';
import 'package:otraku/review/review_models.dart';
import 'package:otraku/review/review_providers.dart';
import 'package:otraku/utils/paged_controller.dart';
import 'package:otraku/review/review_grid.dart';
import 'package:otraku/widgets/layouts/floating_bar.dart';
import 'package:otraku/widgets/layouts/scaffolds.dart';
import 'package:otraku/widgets/layouts/top_bar.dart';
import 'package:otraku/widgets/overlays/sheets.dart';
import 'package:otraku/widgets/paged_view.dart';

class ReviewsView extends ConsumerStatefulWidget {
  const ReviewsView(this.id);

  final int id;

  @override
  ConsumerState<ReviewsView> createState() => _ReviewsViewState();
}

class _ReviewsViewState extends ConsumerState<ReviewsView> {
  late final _ctrl = PagedController(
    loadMore: () => ref.read(reviewsProvider(widget.id).notifier).fetch(),
  );

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final count = ref.watch(
      reviewsProvider(widget.id).select((s) => s.valueOrNull?.total ?? 0),
    );

    return PageScaffold(
      child: TabScaffold(
        topBar: TopBar(
          title: 'Reviews',
          trailing: [
            if (count > 0)
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Text(
                  count.toString(),
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
          ],
        ),
        floatingBar: FloatingBar(
          scrollCtrl: _ctrl,
          children: [
            ActionButton(
              tooltip: 'Sort',
              icon: Ionicons.funnel_outline,
              onTap: () {
                final theme = Theme.of(context);
                final notifier =
                    ref.read(reviewSortProvider(widget.id).notifier);

                showSheet(
                  context,
                  DynamicGradientDragSheet(
                    onTap: (i) =>
                        notifier.state = ReviewSort.values.elementAt(i),
                    children: [
                      for (int i = 0; i < ReviewSort.values.length; i++)
                        Text(
                          ReviewSort.values.elementAt(i).text,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: i != notifier.state.index
                              ? theme.textTheme.titleLarge
                              : theme.textTheme.titleLarge
                                  ?.copyWith(color: theme.colorScheme.primary),
                        ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
        child: PagedView<ReviewItem>(
          provider: reviewsProvider(widget.id),
          onData: (data) => ReviewGrid(data.items),
          onRefresh: () => ref.invalidate(reviewsProvider(widget.id)),
          scrollCtrl: _ctrl,
        ),
      ),
    );
  }
}
