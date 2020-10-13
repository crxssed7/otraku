import 'package:flutter/foundation.dart';
import 'package:otraku/models/page_data/page_item_data.dart';
import 'package:otraku/models/sample_data/connection.dart';

class PersonData extends PageItemData {
  final String fullName;
  final List<String> altNames;
  final String imageUrl;
  final String description;
  final List<Connection> primaryConnections;
  final List<Connection> secondaryConnections;
  int _nextPage;

  PersonData({
    this.primaryConnections = const [],
    this.secondaryConnections = const [],
    @required this.fullName,
    @required this.altNames,
    @required this.imageUrl,
    @required this.description,
    @required id,
    @required isFavourite,
    @required favourites,
    @required browsable,
  }) : super(
          id: id,
          isFavourite: isFavourite,
          favourites: favourites,
          browsable: browsable,
        ) {
    _nextPage = 2;
  }

  int get nextPage {
    return _nextPage;
  }

  void appendConnections(List<Connection> primary, List<Connection> secondary) {
    primaryConnections.addAll(primary);
    secondaryConnections.addAll(secondary);
    _nextPage++;
  }
}