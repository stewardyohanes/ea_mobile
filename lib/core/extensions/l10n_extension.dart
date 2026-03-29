import 'package:flutter/widgets.dart';
import 'package:tradegenz_app/l10n/app_localizations.dart';

export 'package:tradegenz_app/l10n/app_localizations.dart';

extension AppLocalizationsX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}
