import '../../utils/stats.dart';
import '../../utils/secure_storage.dart';
import '../../ui/ui_models/ui_models.dart';
import '../../data/models/models.dart';

class PlanningRoomRepository {
  Future<PlanningRoomStatusInfo> processRoomStatusToUIModel(
      RoomStatus roomStatus) async {
    final myUsername = await SecureStorage().readUsername();
    final amAdmin = roomStatus.admins.contains(myUsername);
    final alreadyEstimated = ((roomStatus.estimates.singleWhere(
            (estimate) => estimate.name == myUsername,
            orElse: () => null)) !=
        null);

    List<UserEstimationCard> userEstimationCardsUI = [];
    List<int> estimates = [];

    roomStatus.admins.forEach((admin) {
      userEstimationCardsUI.add(
          UserEstimationCard(username: admin, isAdmin: true, isInRoom: true));
    });
    roomStatus.estimators.forEach((estimator) {
      userEstimationCardsUI.add(UserEstimationCard(
          username: estimator, isAdmin: false, isInRoom: true));
    });

    //checks if all users who estimated are still in the room, and if not adds them at the end of the list
    roomStatus.estimates.forEach((estimate) {
      estimates.add(estimate.estimate);

      var index = userEstimationCardsUI
          .indexWhere((card) => card.username == estimate.name);
      if (index >= 0) {
        userEstimationCardsUI[index]
          ..isInRoom = true
          ..estimate = estimate.estimate;
      } else {
        userEstimationCardsUI.add(UserEstimationCard(
          username: estimate.name,
          estimate: estimate.estimate,
        ));
      }
    });

    final estimatedTaskInfo = estimates.isEmpty
        ? EstimatedTaskInfo(taskId: roomStatus.taskId)
        : EstimatedTaskInfo(
            taskId: roomStatus.taskId,
            average: Stats.average(estimates),
            median: Stats.median(estimates),
          );
          
    return PlanningRoomStatusInfo(
      amAdmin: amAdmin,
      alreadyEstimated: alreadyEstimated,
      estimatedTaskInfo: estimatedTaskInfo,
      userEstimationCards: userEstimationCardsUI,
    );
  }
}
