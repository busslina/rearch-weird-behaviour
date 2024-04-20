import 'package:rearch/rearch.dart';

extension _ConvenienceExtension on SideEffectRegistrar {
  SideEffectRegistrar get use => this;
}

extension SideEffectRegistrarExtension on SideEffectRegistrar {
  LoadingModeController loadingMode({
    bool initialValue = false,
    String? initialMessage,
  }) {
    final loading = use.data(initialValue);
    final message = use.data<String?>(initialValue ? initialMessage : null);

    final transactionRunner = use.transactionRunner();

    // print(
    //     'loadingMode() -- loading: ${loading.value}, message: ${message.value}');

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
        print('LOADING SIDE EFFECT -- set() -- loading: $value, message: $msg');
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

class LoadingValue {
  final bool loading;
  final String? message;

  LoadingValue({
    required this.loading,
    required this.message,
  });
}
