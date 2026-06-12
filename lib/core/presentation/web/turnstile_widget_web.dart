import 'dart:async';
import 'dart:js_interop';
import 'dart:ui_web' as ui_web;

import 'package:flutter/material.dart';
import 'package:web/web.dart' as web;

import 'turnstile_script_loader.dart';

@JS('turnstile')
external TurnstileApi? get _turnstile;

@JS()
extension type TurnstileApi._(JSObject _) {
  external String render(
    web.HTMLElement container,
    TurnstileRenderOptions options,
  );

  external void reset(String? widgetId);
}

@JS()
@anonymous
extension type TurnstileRenderOptions._(JSObject _) {
  external factory TurnstileRenderOptions({
    String sitekey,
    JSFunction callback,
    @JS('expired-callback')
    JSFunction? expiredCallback,
    @JS('error-callback')
    JSFunction? errorCallback,
  });
}

int _turnstileInstanceCounter = 0;
String? _lastWidgetId;

void resetTurnstileWidget() {
  final api = _turnstile;
  final id = _lastWidgetId;
  if (api != null && id != null && id.isNotEmpty) {
    api.reset(id);
  }
}

class TurnstileWidget extends StatefulWidget {
  const TurnstileWidget({
    super.key,
    required this.siteKey,
    required this.onToken,
    this.onExpired,
    this.onError,
  });

  final String siteKey;
  final ValueChanged<String> onToken;
  final VoidCallback? onExpired;
  final VoidCallback? onError;

  @override
  State<TurnstileWidget> createState() => _TurnstileWidgetState();
}

class _TurnstileWidgetState extends State<TurnstileWidget> {
  late final String _viewType;

  @override
  void initState() {
    super.initState();
    _viewType = 'wpgg-turnstile-${_turnstileInstanceCounter++}';
    ui_web.platformViewRegistry.registerViewFactory(_viewType, (int _) {
      final div = web.HTMLDivElement();
      _renderWhenReady(div);
      return div;
    });
  }

  void _renderWhenReady(web.HTMLDivElement div) {
    Future<void> tryRender() async {
      try {
        await ensureTurnstileScriptLoaded();
      } catch (_) {
        widget.onError?.call();
        return;
      }

      final api = _turnstile;
      if (api == null) {
        await Future<void>.delayed(const Duration(milliseconds: 120));
        if (div.isConnected) {
          await tryRender();
        }
        return;
      }

      _lastWidgetId = api.render(
        div,
        TurnstileRenderOptions(
          sitekey: widget.siteKey,
          callback: ((JSString token) {
            widget.onToken(token.toDart);
          }).toJS,
          expiredCallback: widget.onExpired == null
              ? null
              : (() {
                  widget.onExpired!();
                }).toJS,
          errorCallback: widget.onError == null
              ? null
              : (() {
                  widget.onError!();
                }).toJS,
        ),
      );
    }

    unawaited(tryRender());
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 65,
      width: double.infinity,
      child: HtmlElementView(viewType: _viewType),
    );
  }
}
