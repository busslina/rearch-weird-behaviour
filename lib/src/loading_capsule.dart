import 'package:rearch/rearch.dart';
import 'package:rearch_weird_behaviour/src/loading_side_effect.dart';
import 'package:rearch_weird_behaviour/src/websocket.dart';

LoadingValue loadingModeCapsule(CapsuleHandle use) {
  final controller = use.loadingMode(
    initialValue: true,
    initialMessage: 'Initiating',
  );

  final websocketConnectionState = use(websocketConnectionStateCapsule);

  print(
      '\nCAPSULE:\nWebsocket state: ${websocketConnectionState.asString}\nLoading: ${controller.loading}\nMessage: ${controller.loadingMessage}\n');

  bool loading = false;
  String? message;

  // Websocket connection state
  {
    final websocketLoadingMessage = websocketConnectionState.loadingMessage;

    if (websocketLoadingMessage != null) {
      loading = true;
      message = websocketLoadingMessage;
    }
  }

  controller.set(loading, message);

  return controller.asValue;
}
