import 'package:flutter/material.dart';
import 'package:flareline/pages/layout.dart';
import 'package:flareline_uikit/components/card/common_card.dart';
import 'package:flareline_uikit/components/forms/outborder_text_form_field.dart';
import 'package:flareline/flutter_gen/app_localizations.dart';

class UserCreatePage extends LayoutWidget {
  const UserCreatePage({super.key});

  @override
  String breakTabTitle(BuildContext context) {
    return AppLocalizations.of(context)!.createUser;
  }

  @override
  Widget contentDesktopWidget(BuildContext context) {
    return Column(
      children: [
        CommonCard(
          title: AppLocalizations.of(context)!.createUser,
          child: UserCreateForm(),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(AppLocalizations.of(context)!.saveUser),
        ),
      ],
    );
  }
}

class UserCreateForm extends StatelessWidget {
  UserCreateForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        OutBorderTextFormField(
          labelText: AppLocalizations.of(context)!.name,
          hintText: AppLocalizations.of(context)!.nameHint,
        ),
        const SizedBox(height: 16),
        OutBorderTextFormField(
          labelText: AppLocalizations.of(context)!.email,
          hintText: AppLocalizations.of(context)!.emailHint,
        ),
        const SizedBox(height: 16),
        OutBorderTextFormField(
          labelText: AppLocalizations.of(context)!.role,
          hintText: AppLocalizations.of(context)!.roleHint,
        ),
      ],
    );
  }
}
