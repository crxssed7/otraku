// Used for sorting the entries of a collection.
enum EntrySort {
  TITLE,
  TITLE_DESC,
  SCORE,
  SCORE_DESC,
  UPDATED_AT,
  UPDATED_AT_DESC,
  CREATED_AT,
  CREATED_AT_DESC,
  PROGRESS,
  PROGRESS_DESC,
  REPEAT,
  REPEAT_DESC,
  AIRING_AT,
  AIRING_AT_DESC,
  STARTED_RELEASING,
  STARTED_RELEASING_DESC,
  ENDED_RELEASING,
  ENDED_RELEASING_DESC,
  STARTED_WATCHING,
  STARTED_WATCHING_DESC,
  ENDED_WATCHING,
  ENDED_WATCHING_DESC,
}

// AniList supports only 4 default sort types.
extension EntrySortHelper on EntrySort {
  static const _enumsToStrings = {
    EntrySort.TITLE: 'title',
    EntrySort.SCORE_DESC: 'score',
    EntrySort.UPDATED_AT_DESC: 'updatedAt',
    EntrySort.CREATED_AT_DESC: 'id',
  };

  static const _stringsToEnums = {
    'title': EntrySort.TITLE,
    'score': EntrySort.SCORE_DESC,
    'updatedAt': EntrySort.UPDATED_AT_DESC,
    'id': EntrySort.CREATED_AT_DESC,
    null: EntrySort.TITLE,
  };

  String get string => _enumsToStrings[this]!;

  static EntrySort getEnum(String key) => _stringsToEnums[key]!;

  static List<EntrySort> get defaultEnums => [..._enumsToStrings.keys];

  static List<String> get defaultStrings =>
      const ['Title', 'Score', 'Last Updated', 'Last Added'];
}
