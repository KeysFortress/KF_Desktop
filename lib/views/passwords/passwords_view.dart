import 'package:components/dashboard_header/dashboard_header.dart';
import 'package:components/secret_card/secret_card.dart';
import 'package:domain/models/enums.dart';
import 'package:domain/styles.dart';
import 'package:flutter/material.dart';
import 'package:presentation/views/passwords/passwords_viewmodel.dart';
import 'package:stacked/stacked.dart';

class PasswordsView extends StatelessWidget {
  const PasswordsView({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
      viewModelBuilder: () => PasswordsViewModel(context),
      builder: (context, viewModel, child) => Material(
        color: ThemeStyles.theme.background300,
        child: Builder(
          builder: (containerContext) {
            var width = 0.2 * MediaQuery.of(containerContext).size.width;
            return Container(
              margin: EdgeInsets.fromLTRB(width / 2, 0, width / 2, 0),
              child: Column(
                children: [
                  DashboardHeader(
                    type: ActiveNavigationPage.passwords,
                    onNewPassword: viewModel.onGeneratePassword,
                  ),
                  Expanded(
                    flex: 1,
                    child: ListView.builder(
                      itemCount: viewModel.secrets.length,
                      itemBuilder: (context, index) => SecretCard(
                        secret: viewModel.secrets.elementAt(index),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
