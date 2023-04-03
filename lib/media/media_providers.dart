import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:otraku/discover/discover_models.dart';
import 'package:otraku/edit/edit_model.dart';
import 'package:otraku/media/media_models.dart';
import 'package:otraku/common/relation.dart';
import 'package:otraku/settings/settings_provider.dart';
import 'package:otraku/utils/api.dart';
import 'package:otraku/utils/convert.dart';
import 'package:otraku/utils/graphql.dart';
import 'package:otraku/common/paged.dart';

Future<bool> toggleFavoriteMedia(int id, bool isAnime) async {
  try {
    await Api.get(
      GqlMutation.toggleFavorite,
      {(isAnime ? 'anime' : 'manga'): id},
    );
    return true;
  } catch (_) {
    return false;
  }
}

Future<bool> rateRecommendation(int mediaId, int recId, bool? rating) async {
  try {
    await Api.get(GqlMutation.rateRecommendation, {
      'id': mediaId,
      'recommendedId': recId,
      'rating': rating == null
          ? 'NO_RATING'
          : rating
              ? 'RATE_UP'
              : 'RATE_DOWN',
    });
    return true;
  } catch (_) {
    return false;
  }
}

final mediaProvider = FutureProvider.autoDispose.family<Media, int>(
  (ref, mediaId) async {
    var data = await Api.get(GqlQuery.media, {'id': mediaId, 'withInfo': true});
    data = data['Media'];

    final relatedMedia = <RelatedMedia>[];
    for (final relation in data['relations']['edges']) {
      if (relation['node'] != null) relatedMedia.add(RelatedMedia(relation));
    }

    return Media(
      Edit(data, ref.watch(settingsProvider.notifier).value),
      MediaInfo(data),
      MediaStats(data),
      relatedMedia,
    );
  },
);

final mediaContentProvider = ChangeNotifierProvider.autoDispose.family(
  (ref, int mediaId) => MediaContentNotifier(mediaId),
);

class MediaContentNotifier extends ChangeNotifier {
  MediaContentNotifier(this.mediaId) {
    _fetch();
  }

  final int mediaId;

  var _recommended = const AsyncValue<Paged<Recommendation>>.loading();
  var _characters = const AsyncValue<Paged<Relation>>.loading();
  var _staff = const AsyncValue<Paged<Relation>>.loading();
  var _reviews = const AsyncValue<Paged<RelatedReview>>.loading();

  int _languageIndex = 0;
  final languages = <String>[];
  final _voiceActors = <String, Map<int, List<Relation>>>{};

  int get languageIndex => _languageIndex;
  set languageIndex(int val) {
    if (_languageIndex == val) return;
    _languageIndex = val;
    notifyListeners();
  }

  AsyncValue<Paged<Recommendation>> get recommended => _recommended;
  AsyncValue<Paged<Relation>> get characters => _characters;
  AsyncValue<Paged<Relation>> get staff => _staff;
  AsyncValue<Paged<RelatedReview>> get reviews => _reviews;

  void selectCharactersAndVoiceActors(
    List<Relation> characterList,
    List<Relation?> voiceActorList,
  ) {
    final chars = _characters.valueOrNull?.items;
    if (chars == null) return;

    final byLanguage = _voiceActors[languages[_languageIndex]];
    if (byLanguage == null) {
      characterList.addAll(chars);
      return;
    }

    for (final c in chars) {
      final vas = byLanguage[c.id];
      if (vas == null || vas.isEmpty) {
        characterList.add(c);
        voiceActorList.add(null);
        continue;
      }

      for (final va in vas) {
        characterList.add(c);
        voiceActorList.add(va);
      }
    }
  }

  Future<void> _fetch() async {
    final data = await AsyncValue.guard<Map<String, dynamic>>(() async {
      final data = await Api.get(GqlQuery.media, {
        'id': mediaId,
        'withRecommendations': true,
        'withCharacters': true,
        'withStaff': true,
        'withReviews': true,
      });
      return data['Media'];
    });

    if (data.hasError) {
      _recommended = AsyncValue.error(data.error!, data.stackTrace!);
      _characters = AsyncValue.error(data.error!, data.stackTrace!);
      _staff = AsyncValue.error(data.error!, data.stackTrace!);
      _reviews = AsyncValue.error(data.error!, data.stackTrace!);
      return;
    }

    _recommended = const AsyncValue.data(Paged());
    _characters = const AsyncValue.data(Paged());
    _staff = const AsyncValue.data(Paged());
    _reviews = const AsyncValue.data(Paged());

    _initRecommended(data.value!['recommendations']);
    _initCharacters(data.value!['characters']);
    _initStaff(data.value!['staff']);
    _initReviews(data.value!['reviews']);
    notifyListeners();
  }

  Future<void> fetchRecommended() async {
    final value = _recommended.valueOrNull;
    if (value == null || !value.hasNext) return;

    final data = await AsyncValue.guard<Map<String, dynamic>>(() async {
      final data = await Api.get(GqlQuery.media, {
        'id': mediaId,
        'page': value.next,
        'withRecommendations': true,
      });
      return data['Media'];
    });

    if (data.hasError) {
      _recommended = AsyncValue.error(data.error!, data.stackTrace!);
      return;
    }

    _initRecommended(data.value!['recommendations']);
    notifyListeners();
  }

  Future<void> fetchCharacters() async {
    final value = _characters.valueOrNull;
    if (value == null || !value.hasNext) return;

    final data = await AsyncValue.guard<Map<String, dynamic>>(() async {
      final data = await Api.get(GqlQuery.media, {
        'id': mediaId,
        'page': value.next,
        'withCharacters': true,
      });
      return data['Media'];
    });

    if (data.hasError) {
      _characters = AsyncValue.error(data.error!, data.stackTrace!);
      return;
    }

    _initCharacters(data.value!['characters']);
    notifyListeners();
  }

  Future<void> fetchStaff() async {
    final value = _staff.valueOrNull;
    if (value == null || !value.hasNext) return;

    final data = await AsyncValue.guard<Map<String, dynamic>>(() async {
      final data = await Api.get(GqlQuery.media, {
        'id': mediaId,
        'page': value.next,
        'withStaff': true,
      });
      return data['Media'];
    });

    if (data.hasError) {
      _staff = AsyncValue.error(data.error!, data.stackTrace!);
      return;
    }

    _initStaff(data.value!['staff']);
    notifyListeners();
  }

  Future<void> fetchReviews() async {
    final value = _reviews.valueOrNull;
    if (value == null || !value.hasNext) return;

    final data = await AsyncValue.guard<Map<String, dynamic>>(() async {
      final data = await Api.get(GqlQuery.media, {
        'id': mediaId,
        'page': value.next,
        'withReviews': true,
      });
      return data['Media'];
    });

    if (data.hasError) {
      _reviews = AsyncValue.error(data.error!, data.stackTrace!);
      return;
    }

    _initReviews(data.value!['reviews']);
    notifyListeners();
  }

  void _initRecommended(Map<String, dynamic> map) {
    var value = _recommended.valueOrNull;
    if (value == null) return;

    final items = <Recommendation>[];
    for (final r in map['nodes']) {
      if (r['mediaRecommendation'] != null) items.add(Recommendation(r));
    }

    value = value.withNext(
      items,
      map['pageInfo']['hasNextPage'],
    );
    _recommended = AsyncValue.data(value);
  }

  void _initCharacters(Map<String, dynamic> map) {
    var value = _characters.valueOrNull;
    if (value == null) return;

    final items = <Relation>[];
    for (final c in map['edges']) {
      items.add(Relation(
        id: c['node']['id'],
        title: c['node']['name']['userPreferred'],
        imageUrl: c['node']['image']['large'],
        subtitle: Convert.clarifyEnum(c['role']),
        type: DiscoverType.character,
      ));

      if (c['voiceActors'] == null) continue;

      for (final va in c['voiceActors']) {
        final l = Convert.clarifyEnum(va['languageV2']);
        if (l == null) continue;

        if (!languages.contains(l)) languages.add(l);

        final currentLanguage = _voiceActors.putIfAbsent(
          l,
          () => <int, List<Relation>>{},
        );

        final currentCharacter = currentLanguage.putIfAbsent(
          items.last.id,
          () => [],
        );

        currentCharacter.add(Relation(
          id: va['id'],
          title: va['name']['userPreferred'],
          imageUrl: va['image']['large'],
          subtitle: l,
          type: DiscoverType.staff,
        ));
      }
    }

    value = value.withNext(
      items,
      map['pageInfo']['hasNextPage'],
    );
    _characters = AsyncValue.data(value);
  }

  void _initStaff(Map<String, dynamic> map) {
    var value = _staff.valueOrNull;
    if (value == null) return;

    final items = <Relation>[];
    for (final s in map['edges']) {
      items.add(Relation(
        id: s['node']['id'],
        title: s['node']['name']['userPreferred'],
        imageUrl: s['node']['image']['large'],
        subtitle: s['role'],
        type: DiscoverType.staff,
      ));
    }

    value = value.withNext(
      items,
      map['pageInfo']['hasNextPage'],
    );
    _staff = AsyncValue.data(value);
  }

  void _initReviews(Map<String, dynamic> map) {
    var value = _reviews.valueOrNull;
    if (value == null) return;

    final items = <RelatedReview>[];
    for (final r in map['nodes']) {
      final item = RelatedReview.maybe(r);
      if (item != null) items.add(item);
    }

    value = value.withNext(
      items,
      map['pageInfo']['hasNextPage'],
    );
    _reviews = AsyncValue.data(value);
  }
}
