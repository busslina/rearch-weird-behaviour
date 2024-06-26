import 'package:rearch/rearch.dart';
import 'package:rearch_weird_behaviour/src/loading_capsule.dart';
import 'package:rearch_weird_behaviour/src/websocket.dart';

final cc = CapsuleContainer();

main(List<String> arguments) {
  _listenToLoadingStateChanges();
  _startWebsocketSimulation();
}

_startWebsocketSimulation() async {
  print('Starting websocket simulation\n');

  final setState = cc.read(setWebsocketConnectionStateCapsule);

  await _wait(5);
  print('\n\n');
  setState(WebsocketConnectionState.connecting);

  await _wait(5);
  print('\n\n');
  setState(WebsocketConnectionState.connected);

  await _wait(5);
  print('\n\n');
  setState(WebsocketConnectionState.identified);

  await _wait(3600);
}

void _listenToLoadingStateChanges() {
  print('Starting loading state listener\n');

  final _ = cc.listen((use) {
    final loading = use(loadingModeCapsule);
    print(
        '\nLISTENER:\nLoading: ${loading.loading}\nMessage: ${loading.message}\n');
  });
}

Future<void> _wait(int seconds) => Future.delayed(Duration(seconds: seconds));
