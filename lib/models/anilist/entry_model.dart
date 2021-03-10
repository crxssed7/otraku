import 'package:flutter/foundation.dart';
import 'package:otraku/utils/convert.dart';
import 'package:otraku/enums/list_status.dart';

class EntryModel {
  final int mediaId;
  final int entryId;
  final String type;
  ListStatus status;
  int progress;
  final int progressMax;
  int progressVolumes;
  final int progressVolumesMax;
  double score;
  int repeat;
  String notes;
  DateTime startedAt;
  DateTime completedAt;
  bool private;
  bool hiddenFromStatusLists;
  Map<String, bool> customLists;

  EntryModel._({
    @required this.mediaId,
    @required this.type,
    this.entryId,
    this.status,
    this.progress = 0,
    this.progressMax,
    this.progressVolumes = 0,
    this.progressVolumesMax,
    this.score = 0,
    this.repeat = 0,
    this.notes,
    this.startedAt,
    this.completedAt,
    this.private = false,
    this.hiddenFromStatusLists = false,
    this.customLists,
  });

  factory EntryModel(Map<String, dynamic> map) {
    if (map['mediaListEntry'] == null) {
      return EntryModel._(
        type: map['type'],
        mediaId: map['id'],
        progressMax: map['episodes'] ?? map['chapters'],
        progressVolumesMax: map['volumes'],
      );
    }

    final Map<String, bool> customLists = {};
    if (map['mediaListEntry']['customLists'] != null)
      for (final key in map['mediaListEntry']['customLists'].keys)
        customLists[key] = map['mediaListEntry']['customLists'][key];

    return EntryModel._(
      type: map['type'],
      mediaId: map['id'],
      entryId: map['mediaListEntry']['id'],
      status: Convert.stringToEnum(
        map['mediaListEntry']['status'],
        ListStatus.values,
      ),
      progress: map['mediaListEntry']['progress'] ?? 0,
      progressMax: map['episodes'] ?? map['chapters'],
      progressVolumes: map['mediaListEntry']['volumes'] ?? 0,
      progressVolumesMax: map['volumes'],
      score: map['mediaListEntry']['score'].toDouble(),
      repeat: map['mediaListEntry']['repeat'],
      notes: map['mediaListEntry']['notes'],
      startedAt: Convert.mapToDateTime(map['mediaListEntry']['startedAt']),
      completedAt: Convert.mapToDateTime(map['mediaListEntry']['completedAt']),
      private: map['mediaListEntry']['private'],
      hiddenFromStatusLists: map['mediaListEntry']['hiddenFromStatusLists'],
      customLists: customLists,
    );
  }

  factory EntryModel.copy(final EntryModel copy) => EntryModel._(
        type: copy.type,
        mediaId: copy.mediaId,
        entryId: copy.entryId,
        status: copy.status,
        progress: copy.progress,
        progressMax: copy.progressMax,
        progressVolumes: copy.progressVolumes,
        progressVolumesMax: copy.progressVolumesMax,
        score: copy.score,
        repeat: copy.repeat,
        notes: copy.notes,
        startedAt: copy.startedAt != null
            ? DateTime.fromMillisecondsSinceEpoch(
                copy.startedAt.millisecondsSinceEpoch,
              )
            : null,
        completedAt: copy.completedAt != null
            ? DateTime.fromMillisecondsSinceEpoch(
                copy.completedAt.millisecondsSinceEpoch,
              )
            : null,
        private: copy.private,
        hiddenFromStatusLists: copy.hiddenFromStatusLists,
        customLists: {...copy.customLists},
      );

  Map<String, dynamic> toMap() => {
        'mediaId': mediaId,
        'status': describeEnum(status ?? ListStatus.CURRENT),
        'progress': progress,
        'progressVolumes': progressVolumes,
        'score': score,
        'repeat': repeat,
        'notes': notes,
        'startedAt': Convert.dateTimeToMap(startedAt),
        'completedAt': Convert.dateTimeToMap(completedAt),
        'private': private,
        'hiddenFromStatusLists': hiddenFromStatusLists,
        'customLists': customLists.entries
            .where((e) => e.value)
            .map((e) => e.key)
            .toList(),
      };
}
