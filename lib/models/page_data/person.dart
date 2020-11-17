import 'package:flutter/foundation.dart';

import 'page_entry.dart';

class Person extends PageEntry {
  final String fullName;
  final List<String> altNames;
  final String imageUrl;
  final String description;

  Person({
    @required this.fullName,
    @required this.altNames,
    @required this.imageUrl,
    @required this.description,
    @required id,
    @required browsable,
    @required isFavourite,
    @required favourites,
  }) : super(
          id: id,
          browsable: browsable,
          isFavourite: isFavourite,
          favourites: favourites,
        );
}
