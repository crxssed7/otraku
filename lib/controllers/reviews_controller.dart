import 'package:get/get.dart';
import 'package:otraku/controllers/user_controller.dart';
import 'package:otraku/models/explorable_model.dart';
import 'package:otraku/models/user_model.dart';
import 'package:otraku/utils/client.dart';
import 'package:otraku/utils/graphql.dart';
import 'package:otraku/utils/scrolling_controller.dart';

class ReviewsController extends ScrollingController {
  ReviewsController(this.id);

  final int id;
  late UserModel _model;

  bool get hasNextPage => _model.reviews.hasNextPage;
  List<ExplorableModel> get reviews => _model.reviews.items;

  @override
  Future<void> fetchPage() async {
    if (!_model.reviews.hasNextPage) return;

    final data = await Client.request(GqlQuery.reviews, {
      'userId': id,
      'page': _model.reviews.nextPage,
    });
    if (data == null) return;

    final rl = <ExplorableModel>[];
    for (final r in data['Page']['reviews']) rl.add(ExplorableModel.review(r));
    _model.reviews.append(rl, data['Page']['pageInfo']['hasNextPage']);
    update();
  }

  @override
  void onInit() {
    super.onInit();
    _model = Get.find<UserController>(tag: id.toString()).model!;
    if (_model.reviews.items.isEmpty) fetchPage();
  }
}
