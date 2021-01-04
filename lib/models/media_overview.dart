import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:otraku/enums/browsable.dart';
import 'package:otraku/enums/list_status.dart';
import 'package:otraku/models/page_object.dart';
import 'package:otraku/models/tuple.dart';

class MediaOverview extends PageObject {
  final String preferredTitle;
  final String romajiTitle;
  final String englishTitle;
  final String nativeTitle;
  final List<String> synonyms;
  final String cover;
  final String banner;
  final String description;
  final String format;
  final String status;
  ListStatus entryStatus;
  final int nextEpisode;
  final String timeUntilAiring;
  final int episodes;
  final String duration;
  final int chapters;
  final int volumes;
  final String startDate;
  final String endDate;
  final String season;
  final String averageScore;
  final String meanScore;
  final int popularity;
  final List<String> genres;
  final Tuple<List<int>, List<String>> studios;
  final Tuple<List<int>, List<String>> producers;
  final String source;
  final String hashtag;
  final String countryOfOrigin;

  MediaOverview({
    @required int id,
    @required Browsable browsable,
    @required bool isFavourite,
    @required int favourites,
    @required this.preferredTitle,
    @required this.romajiTitle,
    @required this.englishTitle,
    @required this.nativeTitle,
    @required this.synonyms,
    @required this.cover,
    @required this.banner,
    @required this.description,
    @required this.format,
    @required this.status,
    @required this.entryStatus,
    @required this.nextEpisode,
    @required this.timeUntilAiring,
    @required this.episodes,
    @required this.duration,
    @required this.chapters,
    @required this.volumes,
    @required this.startDate,
    @required this.endDate,
    @required this.season,
    @required this.averageScore,
    @required this.meanScore,
    @required this.popularity,
    @required this.genres,
    @required this.studios,
    @required this.producers,
    @required this.source,
    @required this.hashtag,
    @required this.countryOfOrigin,
  }) : super(
          id: id,
          browsable: browsable,
          isFavourite: isFavourite,
          favourites: favourites,
        );
}