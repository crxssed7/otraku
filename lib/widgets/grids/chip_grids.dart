import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:otraku/constants/consts.dart';
import 'package:otraku/tag/tag_models.dart';
import 'package:otraku/utils/convert.dart';
import 'package:otraku/filter/filter_view.dart';
import 'package:otraku/widgets/fields/chip_fields.dart';
import 'package:otraku/widgets/layouts/page_layout.dart';
import 'package:otraku/widgets/overlays/dialogs.dart';
import 'package:otraku/widgets/overlays/sheets.dart';

class _ChipGrid extends StatelessWidget {
  const _ChipGrid({
    required this.title,
    required this.placeholder,
    required this.children,
    required this.onEdit,
    this.onClear,
  });

  final String title;
  final String placeholder;
  final List<Widget> children;
  final void Function() onEdit;
  final void Function()? onClear;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Text(title, style: Theme.of(context).textTheme.subtitle1),
            const Spacer(),
            if (onClear != null && children.isNotEmpty)
              Tooltip(
                message: 'Clear',
                child: GestureDetector(
                  onTap: onClear,
                  child: Container(
                    height: Consts.iconBig,
                    width: Consts.iconBig,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).colorScheme.surfaceVariant,
                    ),
                    child: Icon(
                      Icons.close,
                      color: Theme.of(context).colorScheme.background,
                      size: Consts.iconSmall,
                    ),
                  ),
                ),
              ),
            TopBarIcon(
              tooltip: 'Edit',
              icon: Ionicons.add_circle_outline,
              colour: Theme.of(context).colorScheme.surfaceVariant,
              onTap: onEdit,
            ),
          ],
        ),
        children.isNotEmpty
            ? Wrap(spacing: 5, children: children)
            : SizedBox(
                height: Consts.tapTargetSize,
                child: Center(
                  child: Text(
                    'No $placeholder',
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                ),
              ),
      ],
    );
  }
}

class ChipGrid extends StatefulWidget {
  const ChipGrid({
    required this.title,
    required this.placeholder,
    required this.names,
    required this.onEdit,
  });

  final String title;
  final String placeholder;
  final List<String> names;
  final Future<void> Function(List<String>) onEdit;

  @override
  ChipGridState createState() => ChipGridState();
}

class ChipGridState extends State<ChipGrid> {
  @override
  Widget build(BuildContext context) {
    final children = <Widget>[];
    for (int i = 0; i < widget.names.length; i++) {
      children.add(ChipField(
        key: Key(widget.names[i]),
        name: Convert.clarifyEnum(widget.names[i])!,
        onRemoved: () => setState(() => widget.names.removeAt(i)),
      ));
    }

    return _ChipGrid(
      title: widget.title,
      placeholder: widget.placeholder,
      children: children,
      onEdit: () => widget.onEdit(widget.names).then((_) => setState(() {})),
      onClear: () => setState(() => widget.names.clear()),
    );
  }
}

// The names can get modified. On every change onChanged gets called.
class ChipNamingGrid extends StatefulWidget {
  final String title;
  final String placeholder;
  final List<String> names;

  const ChipNamingGrid({
    required this.title,
    required this.placeholder,
    required this.names,
  });

  @override
  ChipNamingGridState createState() => ChipNamingGridState();
}

class ChipNamingGridState extends State<ChipNamingGrid> {
  @override
  Widget build(BuildContext context) {
    final children = <Widget>[];
    for (int i = 0; i < widget.names.length; i++) {
      children.add(ChipNamingField(
        key: Key(widget.names[i]),
        name: widget.names[i],
        onChanged: (n) => setState(() => widget.names[i] = n),
        onRemoved: () => setState(() => widget.names.removeAt(i)),
      ));
    }

    return _ChipGrid(
      title: widget.title,
      placeholder: widget.placeholder,
      children: children,
      onEdit: () {
        String name = '';
        showPopUp(
          context,
          InputDialog(initial: name, onChanged: (n) => name = n),
        ).then((_) {
          if (name.isNotEmpty && !widget.names.contains(name)) {
            setState(() => widget.names.add(name));
          }
        });
      },
    );
  }
}

class ChipTagGrid extends StatefulWidget {
  const ChipTagGrid({
    required this.inclusiveGenres,
    required this.exclusiveGenres,
    required this.inclusiveTags,
    required this.exclusiveTags,
    this.tags,
    this.tagIdIn,
    this.tagIdNotIn,
  });

  final List<String> inclusiveGenres;
  final List<String> exclusiveGenres;
  final List<String> inclusiveTags;
  final List<String> exclusiveTags;
  final TagGroup? tags;
  final List<int>? tagIdIn;
  final List<int>? tagIdNotIn;

  @override
  ChipTagGridState createState() => ChipTagGridState();
}

class ChipTagGridState extends State<ChipTagGrid> {
  @override
  Widget build(BuildContext context) {
    final children = <Widget>[];

    for (int i = 0; i < widget.inclusiveGenres.length; i++) {
      final name = widget.inclusiveGenres[i];
      children.add(ChipToggleField(
        key: Key(widget.inclusiveGenres[i]),
        name: Convert.clarifyEnum(name)!,
        initial: true,
        onChanged: (positive) => _toggleGenre(name, positive),
        onRemoved: () => setState(() => widget.inclusiveGenres.remove(name)),
      ));
    }

    for (int i = 0; i < widget.inclusiveTags.length; i++) {
      final name = widget.inclusiveTags[i];
      children.add(ChipToggleField(
        key: Key(widget.inclusiveTags[i]),
        name: Convert.clarifyEnum(name)!,
        initial: true,
        onChanged: (positive) => _toggleTag(name, positive),
        onRemoved: () => setState(() => widget.inclusiveTags.remove(name)),
      ));
    }

    for (int i = 0; i < widget.exclusiveGenres.length; i++) {
      final name = widget.exclusiveGenres[i];
      children.add(ChipToggleField(
        key: Key(widget.exclusiveGenres[i]),
        name: Convert.clarifyEnum(name)!,
        initial: false,
        onChanged: (positive) => _toggleGenre(name, positive),
        onRemoved: () => setState(() => widget.exclusiveGenres.remove(name)),
      ));
    }

    for (int i = 0; i < widget.exclusiveTags.length; i++) {
      final name = widget.exclusiveTags[i];
      children.add(ChipToggleField(
        key: Key(widget.exclusiveTags[i]),
        name: Convert.clarifyEnum(name)!,
        initial: false,
        onChanged: (positive) => _toggleTag(name, positive),
        onRemoved: () => setState(() => widget.exclusiveTags.remove(name)),
      ));
    }

    return _ChipGrid(
      title: 'Tags',
      placeholder: 'tags',
      children: children,
      onEdit: () => showSheet(
        context,
        OpaqueSheet(
          builder: (context, scrollCtrl) => TagSheetBody(
            inclusiveGenres: widget.inclusiveGenres,
            exclusiveGenres: widget.exclusiveGenres,
            inclusiveTags: widget.inclusiveTags,
            exclusiveTags: widget.exclusiveTags,
            scrollCtrl: scrollCtrl,
          ),
        ),
      ).then((_) {
        setState(() {});

        if (widget.tags == null ||
            widget.tagIdIn == null ||
            widget.tagIdNotIn == null) return;

        widget.tagIdIn!.clear();
        widget.tagIdNotIn!.clear();
        for (final t in widget.inclusiveTags) {
          final i = widget.tags!.indices[t];
          if (i == null) continue;
          widget.tagIdIn!.add(widget.tags!.ids[i]);
        }
        for (final t in widget.exclusiveTags) {
          final i = widget.tags!.indices[t];
          if (i == null) continue;
          widget.tagIdNotIn!.add(widget.tags!.ids[i]);
        }
      }),
      onClear: () => setState(() {
        widget.inclusiveGenres.clear();
        widget.exclusiveGenres.clear();
        widget.inclusiveTags.clear();
        widget.exclusiveTags.clear();
      }),
    );
  }

  void _toggleGenre(String name, bool positive) {
    if (positive) {
      widget.inclusiveGenres.add(name);
      widget.exclusiveGenres.remove(name);
    } else {
      widget.exclusiveGenres.add(name);
      widget.inclusiveGenres.remove(name);
    }
  }

  void _toggleTag(String name, bool positive) {
    if (positive) {
      widget.inclusiveTags.add(name);
      widget.exclusiveTags.remove(name);
    } else {
      widget.exclusiveTags.add(name);
      widget.inclusiveTags.remove(name);
    }
  }
}
