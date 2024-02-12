import 'dart:async';

import 'package:domain/exceptions/base_exception.dart';
import 'package:domain/models/core_router.dart';
import 'package:domain/styles.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:infrastructure/interfaces/iexception_manager.dart';
import 'package:infrastructure/interfaces/ihttp_server.dart';
import "package:infrastructure/interfaces/ipage_router_service.dart";
import 'package:stacked/stacked.dart';
import 'package:shared/locator.dart' as locator;

class MainViewModel extends BaseViewModel {
  late BuildContext _context;
  GetIt getIt = locator.getIt;
  late IPageRouterService routerService;
  late IExceptionManager _exceptionManager;
  late bool? _isConfigured;
  bool? get isConfigured => _isConfigured;
  late CoreRouter? _router;
  CoreRouter? get router => _router;
  late IHttpServer _httpServer;
  StreamSubscription<Uri>? _linkSubscription;

  initialized(CoreRouter router, BuildContext context) async {
    _context = context;
    _router = router;
    _exceptionManager = getIt.get<IExceptionManager>();
    routerService = getIt.get<IPageRouterService>();
    _httpServer = getIt.get<IHttpServer>();
    routerService.registerRouter(router);
    var deviceDimensions = MediaQuery.of(context).size;
    ThemeStyles.width = deviceDimensions.width;
    ThemeStyles.height = deviceDimensions.height;
    await _httpServer.startServer();

    registerGlobalExceptionHandler();
    notifyListeners();
  }

  List<Widget> intersperse(Iterable<Widget> list, Widget item) {
    final initialValue = <Widget>[];
    return list.fold(initialValue, (all, el) {
      if (all.isNotEmpty) all.add(item);
      all.add(el);
      return all;
    });
  }

  void registerGlobalExceptionHandler() async {
    PlatformDispatcher.instance.onError = (error, stack) {
      if (error is BaseException) {
        _exceptionManager.raisePopup(error);
      }
      print(error);
      return true;
    };
  }

  onBackAction() {
    routerService.backToPrevious(_context);
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();

    super.dispose();
  }

  onPageChanged() {}
}
