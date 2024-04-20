import 'package:rearch/rearch.dart';

ValueWrapper<WebsocketConnectionState> _websocketConnectionStateManagerCapsule(
  CapsuleHandle use,
) {
  final state = use.data(WebsocketConnectionState.disconnected);

  print('\nWEBSOCKET: ${state.value.asString}\n');

  return state;
}

void Function(WebsocketConnectionState) setWebsocketConnectionStateCapsule(
  CapsuleHandle use,
) =>
    use(_websocketConnectionStateManagerCapsule).$2;

WebsocketConnectionState websocketConnectionStateCapsule(CapsuleHandle use) =>
    use(_websocketConnectionStateManagerCapsule).value;

enum WebsocketConnectionState {
  disconnected,
  connecting,
  connected,
  identified,
}

extension WebsocketConnectionStateExtension on WebsocketConnectionState {
  bool get disconnected => this == WebsocketConnectionState.disconnected;

  bool get connecting => this == WebsocketConnectionState.connecting;

  bool get connected => this == WebsocketConnectionState.connected;

  bool get identified => this == WebsocketConnectionState.identified;

  String get asString => switch (this) {
        WebsocketConnectionState.disconnected => 'Disconnected',
        WebsocketConnectionState.connecting => 'Connecting',
        WebsocketConnectionState.connected => 'Connected',
        WebsocketConnectionState.identified => 'Identified',
      };

  String? get loadingMessage => switch (this) {
        WebsocketConnectionState.disconnected => 'Disconnected',
        WebsocketConnectionState.connecting => 'Connecting',
        WebsocketConnectionState.connected => 'Identifiying',
        WebsocketConnectionState.identified => null,
      };
}
