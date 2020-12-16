import '../../utils/stats.dart';
import '../../utils/session_data_singleton.dart';
import '../../ui/ui_models/ui_models.dart';
import '../../data/models/models.dart';

class PlanningRoomRepository {
  Future<PlanningRoomStatusInfo> processRoomStatusToUIModel(
      RoomStatus roomStatus) async {
    final myUsername = SessionDataSingleton().getUsername();
    final amAdmin = roomStatus.admins.contains(myUsername);
    final amSpectator = roomStatus.spectators.contains(myUsername);
    final alreadyEstimated = ((roomStatus.estimates.singleWhere(
            (estimate) => estimate.name == myUsername,
            orElse: () => null)) !=
        null);
    final estimatesReceived = roomStatus.estimates.length;
    final estimatesExpected =
        (roomStatus.admins.length + roomStatus.estimators.length) +
            (roomStatus.estimates.where((element) {
              return !roomStatus.estimators.contains(element.name) &&
                  !roomStatus.admins.contains(element.name);
            }).length);
    Map<int, int> estimatesDistribution = {};

    List<EstimatorCardModel> estimatorCardsUI = [];
    List<SpectatorCardModel> spectatorCardsUI = [];
    List<int> estimates = [];

    roomStatus.admins.forEach((admin) {
      estimatorCardsUI.add(
        EstimatorCardModel(
          username: admin,
          isAdmin: true,
          isInRoom: true,
        ),
      );
    });
    roomStatus.estimators.forEach((estimator) {
      estimatorCardsUI.add(
        EstimatorCardModel(
          username: estimator,
          isAdmin: false,
          isInRoom: true,
        ),
      );
    });

    //checks if all users who estimated are still in the room, and if not adds them at the end of the list
    roomStatus.estimates.forEach((estimate) {
      estimates.add(estimate.estimate);

      estimatesDistribution.update(estimate.estimate, (value) => ++value,
          ifAbsent: () => 1);

      var index = estimatorCardsUI
          .indexWhere((card) => card.username == estimate.name);
      if (index >= 0) {
        estimatorCardsUI[index]
          ..isInRoom = true
          ..estimate = estimate.estimate;
      } else {
        estimatorCardsUI.add(EstimatorCardModel(
          username: estimate.name,
          estimate: estimate.estimate,
        ));
      }
    });

    roomStatus.spectators.forEach((spectator) { 
      spectatorCardsUI.add(SpectatorCardModel(username: spectator));
    });

    final estimatedTaskInfo = estimates.isEmpty
        ? EstimatedTaskInfo(
            taskId: roomStatus.taskId,
            estimatesReceived: estimatesReceived,
            estimatesExpected: estimatesExpected,
          )
        : EstimatedTaskInfo(
            taskId: roomStatus.taskId,
            average: Stats.average(estimates),
            median: Stats.median(estimates),
            estimatesReceived: estimatesReceived,
            estimatesExpected: estimatesExpected,
            estimatesDistribution: estimatesDistribution,
          );

    return PlanningRoomStatusInfo(
      amAdmin: amAdmin,
      alreadyEstimated: alreadyEstimated,
      estimatedTaskInfo: estimatedTaskInfo,
      estimatorCards: estimatorCardsUI,
      amSpectator: amSpectator,
      spectatorCards: spectatorCardsUI
    );
  }
}
