import 'package:otraku/constants/entry_sort.dart';
import 'package:otraku/constants/list_status.dart';
import 'package:otraku/models/list_entry_model.dart';

class ListModel {
  final String name;
  final ListStatus? status;
  final bool isCustomList;
  final String? splitCompletedListFormat;
  final List<ListEntryModel> entries;

  ListModel._({
    required this.name,
    required this.isCustomList,
    required this.entries,
    this.status,
    this.splitCompletedListFormat,
  });

  factory ListModel(Map<String, dynamic> map, bool splitCompleted) =>
      ListModel._(
        name: map['name'],
        isCustomList: map['isCustomList'] ?? false,
        status: !map['isCustomList'] && map['status'] != null
            ? ListStatus.values.byName(map['status'])
            : null,
        splitCompletedListFormat: splitCompleted &&
                !map['isCustomList'] &&
                map['status'] == 'COMPLETED'
            ? map['entries'][0]['media']['format']
            : null,
        entries: (map['entries'] as List<dynamic>)
            .map((e) => ListEntryModel(e))
            .toList(),
      );

  void removeByMediaId(final int? id) {
    for (int i = 0; i < entries.length; i++)
      if (id == entries[i].mediaId) {
        entries.removeAt(i);
        return;
      }
  }

  void insertSorted(final ListEntryModel item, final EntrySort? s) {
    final compare = _compareFn(s);
    for (int i = 0; i < entries.length; i++)
      if (compare(item, entries[i]) <= 0) {
        entries.insert(i, item);
        return;
      }
    entries.add(item);
  }

  void sort(final EntrySort? s) => entries.sort(_compareFn(s));

  int Function(ListEntryModel, ListEntryModel) _compareFn(final EntrySort? s) {
    switch (s) {
      case EntrySort.TITLE:
        return (a, b) => a.titles[0].compareTo(b.titles[0]);
      case EntrySort.TITLE_DESC:
        return (a, b) => b.titles[0].compareTo(a.titles[0]);
      case EntrySort.SCORE:
        return (a, b) {
          final comparison = a.score.compareTo(b.score);
          if (comparison != 0) return comparison;
          return a.titles[0].compareTo(b.titles[0]);
        };
      case EntrySort.SCORE_DESC:
        return (a, b) {
          final comparison = b.score.compareTo(a.score);
          if (comparison != 0) return comparison;
          return a.titles[0].compareTo(b.titles[0]);
        };
      case EntrySort.UPDATED_AT:
        return (a, b) {
          final comparison = a.updatedAt!.compareTo(b.updatedAt!);
          if (comparison != 0) return comparison;
          return a.titles[0].compareTo(b.titles[0]);
        };
      case EntrySort.UPDATED_AT_DESC:
        return (a, b) {
          final comparison = b.updatedAt!.compareTo(a.updatedAt!);
          if (comparison != 0) return comparison;
          return a.titles[0].compareTo(b.titles[0]);
        };
      case EntrySort.CREATED_AT:
        return (a, b) {
          final comparison = a.createdAt!.compareTo(b.createdAt!);
          if (comparison != 0) return comparison;
          return a.titles[0].compareTo(b.titles[0]);
        };
      case EntrySort.CREATED_AT_DESC:
        return (a, b) {
          final comparison = b.createdAt!.compareTo(a.createdAt!);
          if (comparison != 0) return comparison;
          return a.titles[0].compareTo(b.titles[0]);
        };
      case EntrySort.PROGRESS:
        return (a, b) {
          final comparison = a.progress.compareTo(b.progress);
          if (comparison != 0) return comparison;
          return a.titles[0].compareTo(b.titles[0]);
        };
      case EntrySort.PROGRESS_DESC:
        return (a, b) {
          final comparison = b.progress.compareTo(a.progress);
          if (comparison != 0) return comparison;
          return a.titles[0].compareTo(b.titles[0]);
        };
      case EntrySort.REPEAT:
        return (a, b) {
          final comparison = a.repeat.compareTo(b.repeat);
          if (comparison != 0) return comparison;
          return a.titles[0].compareTo(b.titles[0]);
        };
      case EntrySort.REPEAT_DESC:
        return (a, b) {
          final comparison = b.repeat.compareTo(a.repeat);
          if (comparison != 0) return comparison;
          return a.titles[0].compareTo(b.titles[0]);
        };
      case EntrySort.AIRING_AT:
        return (a, b) {
          if (a.airingAt == null) {
            if (b.airingAt == null) return a.titles[0].compareTo(b.titles[0]);
            return 1;
          }

          if (b.airingAt == null) return -1;

          final comparison = a.airingAt!.compareTo(b.airingAt!);
          if (comparison != 0) return comparison;
          return a.titles[0].compareTo(b.titles[0]);
        };
      case EntrySort.AIRING_AT_DESC:
        return (a, b) {
          if (b.airingAt == null) {
            if (a.airingAt == null) return a.titles[0].compareTo(b.titles[0]);
            return -1;
          }

          if (a.airingAt == null) return 1;

          final comparison = b.airingAt!.compareTo(a.airingAt!);
          if (comparison != 0) return comparison;
          return a.titles[0].compareTo(b.titles[0]);
        };
      case EntrySort.STARTED_RELEASING:
        return (a, b) {
          if (a.releaseStart == null) {
            if (b.releaseStart == null)
              return a.titles[0].compareTo(b.titles[0]);
            return 1;
          }

          if (b.releaseStart == null) return -1;

          final comparison = a.releaseStart!.compareTo(b.releaseStart!);
          if (comparison != 0) return comparison;
          return a.titles[0].compareTo(b.titles[0]);
        };
      case EntrySort.STARTED_RELEASING_DESC:
        return (a, b) {
          if (b.releaseStart == null) {
            if (a.releaseStart == null)
              return a.titles[0].compareTo(b.titles[0]);
            return -1;
          }

          if (a.releaseStart == null) return 1;

          final comparison = b.releaseStart!.compareTo(a.releaseStart!);
          if (comparison != 0) return comparison;
          return a.titles[0].compareTo(b.titles[0]);
        };
      case EntrySort.ENDED_RELEASING:
        return (a, b) {
          if (a.releaseEnd == null) {
            if (b.releaseEnd == null) return a.titles[0].compareTo(b.titles[0]);
            return 1;
          }

          if (b.releaseEnd == null) return -1;

          final comparison = a.releaseEnd!.compareTo(b.releaseEnd!);
          if (comparison != 0) return comparison;
          return a.titles[0].compareTo(b.titles[0]);
        };
      case EntrySort.ENDED_RELEASING_DESC:
        return (a, b) {
          if (b.releaseEnd == null) {
            if (a.releaseEnd == null) return a.titles[0].compareTo(b.titles[0]);
            return -1;
          }

          if (a.releaseEnd == null) return 1;

          final comparison = b.releaseEnd!.compareTo(a.releaseEnd!);
          if (comparison != 0) return comparison;
          return a.titles[0].compareTo(b.titles[0]);
        };
      case EntrySort.STARTED_WATCHING:
        return (a, b) {
          if (a.watchStart == null) {
            if (b.watchStart == null) return a.titles[0].compareTo(b.titles[0]);
            return 1;
          }

          if (b.watchStart == null) return -1;

          final comparison = a.watchStart!.compareTo(b.watchStart!);
          if (comparison != 0) return comparison;
          return a.titles[0].compareTo(b.titles[0]);
        };
      case EntrySort.STARTED_WATCHING_DESC:
        return (a, b) {
          if (b.watchStart == null) {
            if (a.watchStart == null) return a.titles[0].compareTo(b.titles[0]);
            return -1;
          }

          if (a.watchStart == null) return 1;

          final comparison = b.watchStart!.compareTo(a.watchStart!);
          if (comparison != 0) return comparison;
          return a.titles[0].compareTo(b.titles[0]);
        };
      case EntrySort.ENDED_WATCHING:
        return (a, b) {
          if (a.watchEnd == null) {
            if (b.watchEnd == null) return a.titles[0].compareTo(b.titles[0]);
            return 1;
          }

          if (b.watchEnd == null) return -1;

          final comparison = a.watchEnd!.compareTo(b.watchEnd!);
          if (comparison != 0) return comparison;
          return a.titles[0].compareTo(b.titles[0]);
        };
      case EntrySort.ENDED_WATCHING_DESC:
        return (a, b) {
          if (b.watchEnd == null) {
            if (a.watchEnd == null) return a.titles[0].compareTo(b.titles[0]);
            return -1;
          }

          if (a.watchEnd == null) return 1;

          final comparison = b.watchEnd!.compareTo(a.watchEnd!);
          if (comparison != 0) return comparison;
          return a.titles[0].compareTo(b.titles[0]);
        };
      default:
        return (_, __) => 0;
    }
  }
}
