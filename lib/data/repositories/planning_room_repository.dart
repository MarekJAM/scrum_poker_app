import '../../utils/stats.dart';
import '../../utils/session_data_singleton.dart';
import '../../ui/ui_models/ui_models.dart';
import '../../data/models/models.dart';

class PlanningRoomRepository {
  Future<PlanningRoomStatusInfoUI> processRoomStatusToUIModel(
      RoomStatus roomStatus) async {
    final myUsername = SessionDataSingleton().getUsername();
    final amAdmin = roomStatus.admins.contains(myUsername);
    final amSpectator = roomStatus.spectators.contains(myUsername);
    final alreadyEstimated = ((roomStatus.estimates.singleWhere(
            (estimate) => estimate.name == myUsername,
            orElse: () => null)) !=
        null);
    final estimatesReceived = roomStatus.estimates
        .where((el) => !roomStatus.admins.contains(el.name))
        .length;
    final estimatesExpected = (roomStatus.estimators.length) +
        (roomStatus.estimates.where((element) {
          return !roomStatus.estimators.contains(element.name) &&
              !roomStatus.admins.contains(element.name);
        }).length);
    Map<int, int> estimatesDistribution = {};

    List<EstimatorCardModelUI> estimatorCardsUI = [];
    List<SpectatorCardModelUI> spectatorCardsUI = [];
    List<int> estimates = [];

    roomStatus.admins.forEach((admin) {
      estimatorCardsUI.add(
        EstimatorCardModelUI(
          username: admin,
          isAdmin: true,
          isInRoom: true,
        ),
      );
    });
    roomStatus.estimators.forEach((estimator) {
      estimatorCardsUI.add(
        EstimatorCardModelUI(
          username: estimator,
          isAdmin: false,
          isInRoom: true,
        ),
      );
    });

    //checks if all users who estimated are still in the room, and if not adds them at the end of the list
    roomStatus.estimates
        .where((estimate) => estimate.estimate != -1)
        .forEach((estimate) {
      estimates.add(estimate.estimate);

      estimatesDistribution.update(estimate.estimate, (value) => ++value,
          ifAbsent: () => 1);

      var index =
          estimatorCardsUI.indexWhere((card) => card.username == estimate.name);
      if (index >= 0) {
        estimatorCardsUI[index]
          ..isInRoom = true
          ..estimate = estimate.estimate;
      } else {
        estimatorCardsUI.add(EstimatorCardModelUI(
          username: estimate.name,
          estimate: estimate.estimate,
        ));
      }
    });

    roomStatus.spectators.forEach((spectator) {
      spectatorCardsUI.add(SpectatorCardModelUI(username: spectator));
    });

    final estimatedTaskInfo = estimates.isEmpty
        ? EstimatedTaskInfoUI(
            taskId: roomStatus.taskId,
            estimatesReceived: estimatesReceived,
            estimatesExpected: estimatesExpected,
          )
        : EstimatedTaskInfoUI(
            taskId: roomStatus.taskId,
            average: Stats.average(estimates),
            median: Stats.median(estimates),
            estimatesReceived: estimatesReceived,
            estimatesExpected: estimatesExpected,
            estimatesDistribution: estimatesDistribution,
          );

    return PlanningRoomStatusInfoUI(
        amAdmin: amAdmin,
        alreadyEstimated: alreadyEstimated,
        estimatedTaskInfo: estimatedTaskInfo,
        estimatorCards: estimatorCardsUI,
        amSpectator: amSpectator,
        spectatorCards: spectatorCardsUI);
  }
}
