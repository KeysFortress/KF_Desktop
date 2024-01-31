import 'package:components/dashboard_header/dashboard_header.dart';
import 'package:components/identity_card/identity_card.dart';
import 'package:domain/models/enums.dart';
import 'package:domain/styles.dart';
import 'package:flutter/material.dart';
import 'package:presentation/views/identities/identities_viewmodel.dart';
import 'package:stacked/stacked.dart';

class IdentitiesView extends StatelessWidget {
  const IdentitiesView({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
      viewModelBuilder: () => IdentitiesViewModel(context),
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
                    type: ActiveNavigationPage.identities,
                    onNewPassword: viewModel.onGenerateIdentity,
                  ),
                  Expanded(
                    flex: 1,
                    child: ListView.builder(
                      itemCount: viewModel.identities.length,
                      itemBuilder: (context, index) => IdentityCard(
                        identity: viewModel.identities.elementAt(index),
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
