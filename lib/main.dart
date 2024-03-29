import 'package:components/desktop_navigation/desktop_navigation.dart';
import 'package:domain/models/core_router.dart';
import 'package:flutter/material.dart';
import 'package:localization/localization.dart';
import 'package:presentation/router/router.dart';
import 'package:stacked/stacked.dart';

import 'package:shared/locator.dart' as locator;
import 'main_viewmodel.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();

  locator.registerDependency();
  LocalJsonLocalization.delegate.directories = ['KF_Localization'];

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final appRouter = ApplicationRouter.router;
  final configured = false;

  MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final internalRouter = CoreRouter(router: appRouter);

    return Material(
      child: ViewModelBuilder<MainViewModel>.reactive(
        builder: (context, model, child) => MaterialApp.router(
          supportedLocales: [
            Locale('en', 'US'), // English
            Locale('de', 'DE'), // German
          ],
          locale: Locale("en_DE"),
          localizationsDelegates: [
            LocalJsonLocalization.delegate,
          ],
          localeResolutionCallback: (locale, supportedLocales) {
            if (supportedLocales.contains(locale)) {
              return locale;
            }

            // define pt_BR as default when de language code is 'pt'
            if (locale?.languageCode == 'pt') {
              return Locale('en', 'DE');
            }

            // default language
            return Locale('en', 'DE');
          },
          debugShowCheckedModeBanner: false,
          routerConfig: internalRouter.router,
          builder: (bc, child) => Row(
            children: [
              DesktopNavigation(
                context: context,
              ),
              Expanded(
                child: child ?? Container(),
              ),
            ],
          ),
        ),
        viewModelBuilder: () => MainViewModel(),
        onViewModelReady: (model) => model.initialized(
          internalRouter,
          context,
        ),
      ),
    );
  }
}
