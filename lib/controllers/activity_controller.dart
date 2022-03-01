import 'package:get/get.dart';
import 'package:otraku/controllers/feed_controller.dart';
import 'package:otraku/utils/client.dart';
import 'package:otraku/models/activity_model.dart';
import 'package:otraku/models/reply_model.dart';
import 'package:otraku/utils/graphql.dart';
import 'package:otraku/utils/scrolling_controller.dart';

class ActivityController extends ScrollingController {
  static const ID_LOADING = 0;

  ActivityController(this.id, this.feedTag);

  final int id;
  final String? feedTag;
  ActivityModel? _model;
  bool _isLoading = true;

  ActivityModel? get model => _model;
  bool get isLoading => _isLoading;

  Future<void> fetch() async {
    if (_model != null && _model!.replies.items.isNotEmpty) return;
    _isLoading = true;
    update([ID_LOADING]);

    final data = await Client.request(
      GqlQuery.activity,
      {'id': id, 'withActivity': true},
    );
    if (data == null) return;

    _model = ActivityModel(data['Activity']);
    _model!.appendReplies(data['Page']);
    _isLoading = false;
    update([ID_LOADING]);
    update();
  }

  @override
  Future<void> fetchPage() async {
    if (!_model!.replies.hasNextPage) return;

    final data = await Client.request(
      GqlQuery.activity,
      {'id': id, 'page': _model!.replies.nextPage},
    );
    if (data == null) return;

    _model!.appendReplies(data['Page']);
    update();
  }

  static Future<bool> toggleSubscription(ActivityModel activityModel) async {
    final data = await Client.request(
      GqlMutation.toggleActivitySubscription,
      {'id': activityModel.id, 'subscribe': activityModel.isSubscribed},
    );
    return data != null;
  }

  static Future<bool> toggleLike(ActivityModel am) async {
    final data = await Client.request(
      GqlMutation.toggleLike,
      {'id': am.id, 'type': 'ACTIVITY'},
    );
    return data != null;
  }

  static Future<bool> toggleReplyLike(ReplyModel reply) async {
    final data = await Client.request(
      GqlMutation.toggleLike,
      {'id': reply.id, 'type': 'ACTIVITY_REPLY'},
    );
    return data != null;
  }

  void updateModel() {
    if (Get.isRegistered<FeedController>(tag: feedTag))
      Get.find<FeedController>(tag: feedTag).updateActivity(_model!);
  }

  Future<void> deleteModel() async {
    if (feedTag != null)
      await Get.find<FeedController>(tag: feedTag).deleteActivity(id);
    else
      await Client.request(GqlMutation.deleteActivity, {'id': id});
  }

  @override
  void onInit() {
    super.onInit();
    if (feedTag != null)
      _model = Get.find<FeedController>(tag: feedTag).getActivity(id);
    fetch();
  }
}
