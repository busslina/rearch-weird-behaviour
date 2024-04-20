import 'package:rearch/rearch.dart';
import 'package:rearch_weird_behaviour/src/websocket.dart';

extension _ConvenienceExtension on SideEffectRegistrar {
  SideEffectRegistrar get use => this;
}

LoadingValue loadingModeCapsule(CapsuleHandle use) {
  final controller = use.loadingMode(
    initialValue: true,
    initialMessage: 'Initiating',
  );

  final websocketConnectionState = use(websocketConnectionStateCapsule);

  print('loadingModeCapsule() -- Loading: ${controller.loading}');
  print(
      'loadingModeCapsule() -- Websocket connection state: ${websocketConnectionState.asString}');

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

  print(
      'loadingModeCapsule() -- Setting -- loading: $loading -- message: $message');

  controller.set(loading, message);

  return controller.asValue;
}

class LoadingValue {
  final bool loading;
  final String? message;

  LoadingValue({
    required this.loading,
    required this.message,
  });
}

extension SideEffectRegistrarExtension on SideEffectRegistrar {
  LoadingModeController loadingMode({
    bool initialValue = false,
    String? initialMessage,
  }) {
    final loading = use.data(initialValue);
    final message = use.data<String?>(initialValue ? initialMessage : null);

    final transactionRunner = use.transactionRunner();

    print(
        'loadingMode() -- loading: ${loading.value}, message: ${message.value}');

    return LoadingModeController(
      loading: loading.value,
      loadingMessage: message.value,
      on: (msg) => transactionRunner(() {
        loading.value = true;
        message.value = msg;
      }),
      off: () => transactionRunner(() {
        loading.value = false;
      }),
      toggle: (msg) => transactionRunner(() {
        loading.value = !loading.value;
        message.value = loading.value ? msg : null;
      }),
      set: (value, msg) => transactionRunner(() {
        print('loadingMode() setting -- value: $value, msg: $msg');
        loading.value = value;
        message.value = value ? msg : null;
      }),
    );
  }
}

class LoadingModeController {
  final bool loading;
  final String? loadingMessage;
  final void Function(String?) on;
  final void Function() off;
  final void Function(String?) toggle;
  final void Function(bool, String?) set;

  LoadingModeController({
    required this.loading,
    required this.loadingMessage,
    required this.on,
    required this.off,
    required this.toggle,
    required this.set,
  });
}

extension LoadingModeControllerLiteExtension on LoadingModeController {
  LoadingValue get asValue => LoadingValue(
        loading: loading,
        message: loadingMessage,
      );
}
