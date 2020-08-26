import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:otraku/enums/enum_helper.dart';
import 'package:otraku/enums/media_sort_enum.dart';
import 'package:otraku/providers/auth.dart';
import 'package:otraku/tools/overlays/modal_sheet.dart';
import 'package:provider/provider.dart';

class ExploreSortModalSheet extends StatelessWidget {
  final Map<String, dynamic> filters;
  final Function load;

  ExploreSortModalSheet(this.filters, this.load);

  @override
  Widget build(BuildContext context) {
    final length = MediaSort.values.length;
    final prefTitle = Provider.of<Auth>(context, listen: false).titleFormat;
    String titleAsc;
    String titleDesc;

    if (describeEnum(MediaSort.values[length - 2]).contains(prefTitle)) {
      titleAsc = describeEnum(MediaSort.values[length - 2]);
      titleDesc = describeEnum(MediaSort.values[length - 1]);
    } else if (describeEnum(MediaSort.values[length - 4]).contains(prefTitle)) {
      titleAsc = describeEnum(MediaSort.values[length - 4]);
      titleDesc = describeEnum(MediaSort.values[length - 3]);
    } else {
      titleAsc = describeEnum(MediaSort.values[length - 6]);
      titleDesc = describeEnum(MediaSort.values[length - 5]);
    }

    MediaSort mediaSort = stringToEnum(
      filters['sort'],
      Map.fromIterable(
        MediaSort.values,
        key: (element) => describeEnum(element),
        value: (element) => element,
      ),
    );

    int currentIndex;
    bool currentlyDesc;

    for (int i = 0; i < length; i++) {
      if (mediaSort == MediaSort.values[i]) {
        currentIndex = i ~/ 2;
        currentlyDesc = i % 2 == 0 ? false : true;
        break;
      }
    }

    if (currentIndex > (length - 5) ~/ 2) {
      currentIndex = (length - 6) ~/ 2;
    }

    List<String> options = [];
    for (int i = 0; i < length - 6; i += 2) {
      options.add(clarifyEnum(describeEnum(MediaSort.values[i])));
    }
    options.add('Title');

    return ModalSheet(
      options: options,
      index: currentIndex,
      desc: currentlyDesc,
      onTap: (int index) {
        if (index != options.length - 1) {
          if (index != currentIndex) {
            filters['sort'] = describeEnum(MediaSort.values[index * 2 + 1]);
          } else {
            if (currentlyDesc) {
              filters['sort'] = describeEnum(MediaSort.values[index * 2]);
            } else {
              filters['sort'] = describeEnum(MediaSort.values[index * 2 + 1]);
            }
          }
        } else {
          if (index != currentIndex) {
            filters['sort'] = titleDesc;
          } else if (currentlyDesc) {
            filters['sort'] = titleAsc;
          } else {
            filters['sort'] = titleDesc;
          }
        }

        load();
      },
    );
  }
}