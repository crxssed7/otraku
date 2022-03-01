import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:ionicons/ionicons.dart';
import 'package:otraku/constants/consts.dart';
import 'package:otraku/widgets/fade_image.dart';
import 'package:otraku/widgets/navigation/app_bars.dart';
import 'package:otraku/widgets/overlays/dialogs.dart';

class CustomSliverHeader extends StatelessWidget {
  CustomSliverHeader({
    required this.title,
    required this.image,
    required this.banner,
    required this.squareImage,
    required this.implyLeading,
    required this.actions,
    required this.child,
    required this.heroId,
    this.maxWidth = Consts.OVERLAY_WIDE,
  });

  final String? title;
  final String? image;
  final String? banner;
  final bool squareImage;
  final bool implyLeading;
  final List<Widget> actions;
  final Widget? child;
  final int heroId;

  /// If not null the row with the [image] and the [child] will be restrained.
  final double? maxWidth;

  @override
  Widget build(BuildContext context) {
    double sidePadding = 10;
    if (maxWidth != null && MediaQuery.of(context).size.width > maxWidth! + 20)
      sidePadding = (MediaQuery.of(context).size.width - maxWidth!) / 2;

    final imageWidth = MediaQuery.of(context).size.width < 430.0
        ? MediaQuery.of(context).size.width * 0.35
        : 150.0;
    final imageHeight = imageWidth * (squareImage ? 1 : 1.4);
    final bannerHeight = 200.0;
    final height = bannerHeight + imageHeight / 2;

    return SliverPersistentHeader(
      pinned: true,
      delegate: _Delegate(
        title: title ?? '',
        image: image,
        banner: banner,
        height: height,
        bannerHeight: bannerHeight,
        imageHeight: imageHeight,
        imageWidth: imageWidth,
        sidePadding: sidePadding,
        implyLeading: implyLeading,
        actions: actions,
        child: child,
        heroId: heroId,
      ),
    );
  }
}

class _Delegate implements SliverPersistentHeaderDelegate {
  _Delegate({
    required this.title,
    required this.image,
    required this.banner,
    required this.height,
    required this.bannerHeight,
    required this.imageHeight,
    required this.imageWidth,
    required this.sidePadding,
    required this.implyLeading,
    required this.actions,
    required this.child,
    required this.heroId,
  });

  final String title;
  final String? image;
  final String? banner;
  final double height;
  final double bannerHeight;
  final double imageHeight;
  final double imageWidth;
  final double sidePadding;
  final bool implyLeading;
  final List<Widget> actions;
  final Widget? child;
  final int heroId;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final extent = maxExtent - shrinkOffset;
    final complexImage = imageHeight != imageWidth;
    final opacity = shrinkOffset < (bannerHeight - minExtent)
        ? shrinkOffset / (bannerHeight - minExtent)
        : 1.0;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            blurRadius: 5,
            spreadRadius: 5,
            color: Theme.of(context).colorScheme.background,
          ),
        ],
      ),
      child: FlexibleSpaceBar.createSettings(
        minExtent: minExtent,
        maxExtent: maxExtent,
        currentExtent: extent > minExtent ? extent : minExtent,
        child: Stack(
          fit: StackFit.expand,
          children: [
            FlexibleSpaceBar(
              collapseMode: CollapseMode.pin,
              stretchModes: [StretchMode.zoomBackground],
              background: Column(
                children: [
                  Expanded(
                    child: banner != null
                        ? GestureDetector(
                            child: FadeImage(banner!),
                            onTap: () =>
                                showPopUp(context, ImageDialog(banner!)),
                          )
                        : const SizedBox(),
                  ),
                  SizedBox(height: height - bannerHeight),
                ],
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                height: height - bannerHeight,
                alignment: Alignment.topCenter,
                color: Theme.of(context).colorScheme.background,
                child: Container(
                  height: 0,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 15,
                        spreadRadius: 25,
                        color: Theme.of(context).colorScheme.background,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: sidePadding,
              right: sidePadding,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  GestureDetector(
                    child: Hero(
                      tag: heroId,
                      child: ClipRRect(
                        borderRadius: Consts.BORDER_RAD_MIN,
                        child: Container(
                          height: imageHeight,
                          width: imageWidth,
                          color: complexImage
                              ? Theme.of(context).colorScheme.surface
                              : null,
                          child: image != null
                              ? GestureDetector(
                                  onTap: () =>
                                      showPopUp(context, ImageDialog(image!)),
                                  child: FadeImage(
                                    image!,
                                    fit: complexImage
                                        ? BoxFit.cover
                                        : BoxFit.contain,
                                    alignment: complexImage
                                        ? Alignment.center
                                        : Alignment.bottomCenter,
                                  ),
                                )
                              : null,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  if (child != null) Expanded(child: child!),
                ],
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: minExtent,
              child: Opacity(
                opacity: opacity,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.background,
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 10,
                        spreadRadius: 10,
                        color: Theme.of(context).colorScheme.background,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: minExtent,
              child: Row(
                children: [
                  implyLeading
                      ? IconShade(
                          AppBarIcon(
                            tooltip: 'Close',
                            icon: Ionicons.chevron_back_outline,
                            onTap: Navigator.of(context).pop,
                          ),
                        )
                      : const SizedBox(width: 10),
                  Expanded(
                    child: Opacity(
                      opacity: opacity,
                      child: Text(
                        title,
                        style: Theme.of(context).textTheme.headline2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  ...actions,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  double get maxExtent => height;

  @override
  double get minExtent => Consts.MATERIAL_TAP_TARGET_SIZE;

  @override
  OverScrollHeaderStretchConfiguration? get stretchConfiguration =>
      OverScrollHeaderStretchConfiguration(stretchTriggerOffset: 100);

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true;

  @override
  PersistentHeaderShowOnScreenConfiguration? get showOnScreenConfiguration =>
      null;

  @override
  FloatingHeaderSnapConfiguration? get snapConfiguration => null;

  @override
  TickerProvider? get vsync => null;
}

class IconShade extends StatelessWidget {
  final Widget child;
  IconShade(this.child);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.background,
            blurRadius: 10,
            spreadRadius: -10,
          ),
        ],
      ),
      child: child,
    );
  }
}
