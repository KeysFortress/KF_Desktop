import 'package:components/custom_button/custom_button.dart';
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
      onViewModelReady: (viewModel) => viewModel.ready(),
      builder: (context, viewModel, child) => Material(
        color: ThemeStyles.theme.background300,
        child: Stack(
          children: [
            Builder(
              builder: (containerContext) {
                var width = 0.2 * MediaQuery.of(containerContext).size.width;
                return Container(
                  margin: EdgeInsets.fromLTRB(width / 2, 0, width / 2, 0),
                  child: Column(
                    children: [
                      DashboardHeader(
                        name: "Passwords",
                        icon: "secrets.svg",
                        type: ActiveNavigationPage.passwords,
                        onNewPassword: () {},
                        btnVisible: false,
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
            Positioned(
              right: 20,
              bottom: 20,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: ThemeStyles.theme.accent200,
                ),
                child: CustomButton(
                  callback: viewModel.onGeneratePassword,
                  widget: Icon(
                    Icons.add,
                    size: 120,
                    color: ThemeStyles.theme.text300,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
