import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_id.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('id'),
  ];

  /// Application name
  ///
  /// In en, this message translates to:
  /// **'TradeGenZ'**
  String get appName;

  /// Onboarding tagline
  ///
  /// In en, this message translates to:
  /// **'INSTITUTIONAL GRADE ALGORITHMS  •  NO-LAG EXECUTION'**
  String get institutionalGrade;

  /// No description provided for @onboardingTitle.
  ///
  /// In en, this message translates to:
  /// **'TRADEGENZ'**
  String get onboardingTitle;

  /// No description provided for @onboardingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Smart Forex Signals\nfrom MetaTrader EA'**
  String get onboardingSubtitle;

  /// No description provided for @onboardingDescription.
  ///
  /// In en, this message translates to:
  /// **'Advanced algorithmic intelligence translated into actionable high-probability trade setups for the modern retail trader.'**
  String get onboardingDescription;

  /// No description provided for @featureSignalsTitle.
  ///
  /// In en, this message translates to:
  /// **'Real-time EA Signals'**
  String get featureSignalsTitle;

  /// No description provided for @featureSignalsDesc.
  ///
  /// In en, this message translates to:
  /// **'Instant execution alerts from our proprietary MT4/MT5 algorithms.'**
  String get featureSignalsDesc;

  /// No description provided for @featureCalculatorTitle.
  ///
  /// In en, this message translates to:
  /// **'Lot Size Calculator'**
  String get featureCalculatorTitle;

  /// No description provided for @featureCalculatorDesc.
  ///
  /// In en, this message translates to:
  /// **'Risk management precision. Calculate position sizes in milliseconds.'**
  String get featureCalculatorDesc;

  /// No description provided for @featureAnalyticsTitle.
  ///
  /// In en, this message translates to:
  /// **'Win Rate Analytics'**
  String get featureAnalyticsTitle;

  /// No description provided for @featureAnalyticsDesc.
  ///
  /// In en, this message translates to:
  /// **'Transparent historical performance with deep quantitative data.'**
  String get featureAnalyticsDesc;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? '**
  String get dontHaveAccount;

  /// No description provided for @registerNow.
  ///
  /// In en, this message translates to:
  /// **'Register Now'**
  String get registerNow;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @createAccountSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Join TradeGenZ and start trading smarter'**
  String get createAccountSubtitle;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @enterFullName.
  ///
  /// In en, this message translates to:
  /// **'Enter your full name'**
  String get enterFullName;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @enterEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get enterEmail;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @passwordHint.
  ///
  /// In en, this message translates to:
  /// **'Min. 8 characters'**
  String get passwordHint;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @reEnterPassword.
  ///
  /// In en, this message translates to:
  /// **'Re-enter your password'**
  String get reEnterPassword;

  /// No description provided for @allFieldsRequired.
  ///
  /// In en, this message translates to:
  /// **'All fields are required'**
  String get allFieldsRequired;

  /// No description provided for @passwordMinLength.
  ///
  /// In en, this message translates to:
  /// **'Password minimum 8 characters'**
  String get passwordMinLength;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get alreadyHaveAccount;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @accountRecovery.
  ///
  /// In en, this message translates to:
  /// **'Account Recovery'**
  String get accountRecovery;

  /// No description provided for @forgotPasswordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Review the three-step flow for resetting secure access to your TradeGenZ terminal.'**
  String get forgotPasswordSubtitle;

  /// No description provided for @step01.
  ///
  /// In en, this message translates to:
  /// **'STEP_01'**
  String get step01;

  /// No description provided for @step02.
  ///
  /// In en, this message translates to:
  /// **'STEP_02'**
  String get step02;

  /// No description provided for @enterEmailStep.
  ///
  /// In en, this message translates to:
  /// **'Enter Email'**
  String get enterEmailStep;

  /// No description provided for @forgotPasswordStep1Desc.
  ///
  /// In en, this message translates to:
  /// **'Input your registered terminal identifier to initiate the account recovery sequence.'**
  String get forgotPasswordStep1Desc;

  /// No description provided for @terminalAddress.
  ///
  /// In en, this message translates to:
  /// **'TERMINAL ADDRESS'**
  String get terminalAddress;

  /// No description provided for @terminalAddressHint.
  ///
  /// In en, this message translates to:
  /// **'operator@tradegenz.io'**
  String get terminalAddressHint;

  /// No description provided for @failedToSendOtp.
  ///
  /// In en, this message translates to:
  /// **'Failed to send OTP. Please check your internet connection.'**
  String get failedToSendOtp;

  /// No description provided for @sendOtp.
  ///
  /// In en, this message translates to:
  /// **'SEND OTP'**
  String get sendOtp;

  /// No description provided for @verificationSent.
  ///
  /// In en, this message translates to:
  /// **'Verification Sent'**
  String get verificationSent;

  /// No description provided for @forgotPasswordStep2Desc.
  ///
  /// In en, this message translates to:
  /// **'An encrypted sync key has been dispatched to '**
  String get forgotPasswordStep2Desc;

  /// No description provided for @enterOtpCode.
  ///
  /// In en, this message translates to:
  /// **'ENTER OTP CODE'**
  String get enterOtpCode;

  /// No description provided for @enterOtpOnNextScreen.
  ///
  /// In en, this message translates to:
  /// **'Enter 6-digit OTP on next screen'**
  String get enterOtpOnNextScreen;

  /// No description provided for @verifyOtp.
  ///
  /// In en, this message translates to:
  /// **'VERIFY OTP'**
  String get verifyOtp;

  /// No description provided for @otpTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter OTP Code'**
  String get otpTitle;

  /// No description provided for @otpSentTo.
  ///
  /// In en, this message translates to:
  /// **'OTP code has been sent to '**
  String get otpSentTo;

  /// No description provided for @otpHint.
  ///
  /// In en, this message translates to:
  /// **'Enter 6-digit OTP code'**
  String get otpHint;

  /// No description provided for @verify.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get verify;

  /// No description provided for @didNotReceiveCode.
  ///
  /// In en, this message translates to:
  /// **'Didn\'t receive the code? '**
  String get didNotReceiveCode;

  /// No description provided for @resend.
  ///
  /// In en, this message translates to:
  /// **'Resend'**
  String get resend;

  /// No description provided for @otpResentSuccess.
  ///
  /// In en, this message translates to:
  /// **'OTP resent successfully'**
  String get otpResentSuccess;

  /// No description provided for @otpResentFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to resend OTP. Please try again.'**
  String get otpResentFailed;

  /// No description provided for @resetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPassword;

  /// No description provided for @resetPasswordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Set a new strong password for your trading terminal. Use at least 12 characters with symbols.'**
  String get resetPasswordSubtitle;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'NEW PASSWORD'**
  String get newPassword;

  /// No description provided for @confirmPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'CONFIRM PASSWORD'**
  String get confirmPasswordLabel;

  /// No description provided for @passwordsDontMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDontMatch;

  /// No description provided for @passwordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters'**
  String get passwordTooShort;

  /// No description provided for @passwordChangedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Password changed successfully'**
  String get passwordChangedSuccess;

  /// No description provided for @invalidOrExpiredOtp.
  ///
  /// In en, this message translates to:
  /// **'Invalid or expired OTP code'**
  String get invalidOrExpiredOtp;

  /// No description provided for @somethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get somethingWentWrong;

  /// No description provided for @passwordStrengthWeak.
  ///
  /// In en, this message translates to:
  /// **'Weak'**
  String get passwordStrengthWeak;

  /// No description provided for @passwordStrengthMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get passwordStrengthMedium;

  /// No description provided for @passwordStrengthStrong.
  ///
  /// In en, this message translates to:
  /// **'Strong'**
  String get passwordStrengthStrong;

  /// No description provided for @savePassword.
  ///
  /// In en, this message translates to:
  /// **'SAVE PASSWORD'**
  String get savePassword;

  /// No description provided for @encryptionLabel.
  ///
  /// In en, this message translates to:
  /// **'ENCRYPTION'**
  String get encryptionLabel;

  /// No description provided for @encryptionValue.
  ///
  /// In en, this message translates to:
  /// **'AES-256 BIT'**
  String get encryptionValue;

  /// No description provided for @protocolLabel.
  ///
  /// In en, this message translates to:
  /// **'PROTOCOL'**
  String get protocolLabel;

  /// No description provided for @mfaReady.
  ///
  /// In en, this message translates to:
  /// **'MFA READY'**
  String get mfaReady;

  /// No description provided for @riskDisclaimerTitle.
  ///
  /// In en, this message translates to:
  /// **'Risk Disclaimer'**
  String get riskDisclaimerTitle;

  /// No description provided for @disclaimerIntro.
  ///
  /// In en, this message translates to:
  /// **'Please read this disclaimer carefully before using TradeGenZ.'**
  String get disclaimerIntro;

  /// No description provided for @disclaimerSection1Title.
  ///
  /// In en, this message translates to:
  /// **'1. No Financial Advice'**
  String get disclaimerSection1Title;

  /// No description provided for @disclaimerSection1Body.
  ///
  /// In en, this message translates to:
  /// **'The trading signals provided by TradeGenZ are for informational purposes only and do not constitute financial advice. TradeGenZ is not a licensed financial advisor, broker, or dealer.'**
  String get disclaimerSection1Body;

  /// No description provided for @disclaimerSection2Title.
  ///
  /// In en, this message translates to:
  /// **'2. Risk of Loss'**
  String get disclaimerSection2Title;

  /// No description provided for @disclaimerSection2Body.
  ///
  /// In en, this message translates to:
  /// **'Trading in forex, commodities, and other financial instruments involves a high level of risk and may not be suitable for all investors. You may lose some or all of your invested capital. Never trade with money you cannot afford to lose.'**
  String get disclaimerSection2Body;

  /// No description provided for @disclaimerSection3Title.
  ///
  /// In en, this message translates to:
  /// **'3. Past Performance'**
  String get disclaimerSection3Title;

  /// No description provided for @disclaimerSection3Body.
  ///
  /// In en, this message translates to:
  /// **'Past performance of any trading signal or strategy is not indicative of future results. Markets are unpredictable and no signal service can guarantee profits.'**
  String get disclaimerSection3Body;

  /// No description provided for @disclaimerSection4Title.
  ///
  /// In en, this message translates to:
  /// **'4. Your Responsibility'**
  String get disclaimerSection4Title;

  /// No description provided for @disclaimerSection4Body.
  ///
  /// In en, this message translates to:
  /// **'You are solely responsible for your trading decisions. TradeGenZ and its team shall not be held liable for any losses incurred as a result of using our signals or services.'**
  String get disclaimerSection4Body;

  /// No description provided for @disclaimerSection5Title.
  ///
  /// In en, this message translates to:
  /// **'5. Signal Accuracy'**
  String get disclaimerSection5Title;

  /// No description provided for @disclaimerSection5Body.
  ///
  /// In en, this message translates to:
  /// **'While we strive to provide accurate and timely signals, TradeGenZ does not guarantee the accuracy, completeness, or timeliness of any signal. Market conditions can change rapidly.'**
  String get disclaimerSection5Body;

  /// No description provided for @disclaimerSection6Title.
  ///
  /// In en, this message translates to:
  /// **'6. Independent Verification'**
  String get disclaimerSection6Title;

  /// No description provided for @disclaimerSection6Body.
  ///
  /// In en, this message translates to:
  /// **'We strongly recommend that you conduct your own research and analysis before executing any trade. Consider consulting with a qualified financial advisor if needed.'**
  String get disclaimerSection6Body;

  /// No description provided for @disclaimerSection7Title.
  ///
  /// In en, this message translates to:
  /// **'7. Regulatory Compliance'**
  String get disclaimerSection7Title;

  /// No description provided for @disclaimerSection7Body.
  ///
  /// In en, this message translates to:
  /// **'It is your responsibility to ensure that using TradeGenZ services complies with the laws and regulations in your jurisdiction. TradeGenZ is not responsible for any regulatory issues.'**
  String get disclaimerSection7Body;

  /// No description provided for @scrollToBottom.
  ///
  /// In en, this message translates to:
  /// **'↓ Scroll to bottom to continue'**
  String get scrollToBottom;

  /// No description provided for @agreeToDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'I have read and agree to the risk disclaimer'**
  String get agreeToDisclaimer;

  /// No description provided for @understandAndAccept.
  ///
  /// In en, this message translates to:
  /// **'I Understand & Accept'**
  String get understandAndAccept;

  /// No description provided for @signalFeedTitle.
  ///
  /// In en, this message translates to:
  /// **'TradeGenZ'**
  String get signalFeedTitle;

  /// No description provided for @noSignalsYet.
  ///
  /// In en, this message translates to:
  /// **'No signals yet'**
  String get noSignalsYet;

  /// No description provided for @noSignalsYetSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Check back later for new signals'**
  String get noSignalsYetSubtitle;

  /// No description provided for @noSignalsForSymbol.
  ///
  /// In en, this message translates to:
  /// **'No signals for {symbol}'**
  String noSignalsForSymbol(String symbol);

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @failedToLoadSignal.
  ///
  /// In en, this message translates to:
  /// **'Failed to load signal'**
  String get failedToLoadSignal;

  /// No description provided for @statusActive.
  ///
  /// In en, this message translates to:
  /// **'ACTIVE'**
  String get statusActive;

  /// No description provided for @statusTpHit.
  ///
  /// In en, this message translates to:
  /// **'TP HIT'**
  String get statusTpHit;

  /// No description provided for @statusSlHit.
  ///
  /// In en, this message translates to:
  /// **'SL HIT'**
  String get statusSlHit;

  /// No description provided for @statusClosed.
  ///
  /// In en, this message translates to:
  /// **'CLOSED'**
  String get statusClosed;

  /// No description provided for @entry1Label.
  ///
  /// In en, this message translates to:
  /// **'ENTRY 1'**
  String get entry1Label;

  /// No description provided for @entry2Label.
  ///
  /// In en, this message translates to:
  /// **'ENTRY 2'**
  String get entry2Label;

  /// No description provided for @stopLossLabel.
  ///
  /// In en, this message translates to:
  /// **'STOP LOSS'**
  String get stopLossLabel;

  /// No description provided for @takeProfitLabel.
  ///
  /// In en, this message translates to:
  /// **'TAKE PROFIT'**
  String get takeProfitLabel;

  /// No description provided for @riskRewardLabel.
  ///
  /// In en, this message translates to:
  /// **'RISK/REWARD'**
  String get riskRewardLabel;

  /// No description provided for @trendStrengthLabel.
  ///
  /// In en, this message translates to:
  /// **'TREND STRENGTH'**
  String get trendStrengthLabel;

  /// No description provided for @unlockSignalDetail.
  ///
  /// In en, this message translates to:
  /// **'Unlock Full Signal Detail'**
  String get unlockSignalDetail;

  /// No description provided for @upgradeToSeeDetail.
  ///
  /// In en, this message translates to:
  /// **'Upgrade to see Entry, SL & TP levels'**
  String get upgradeToSeeDetail;

  /// No description provided for @executeSignal.
  ///
  /// In en, this message translates to:
  /// **'EXECUTE SIGNAL'**
  String get executeSignal;

  /// No description provided for @signalHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Signal History'**
  String get signalHistoryTitle;

  /// No description provided for @totalLabel.
  ///
  /// In en, this message translates to:
  /// **'TOTAL'**
  String get totalLabel;

  /// No description provided for @winLabel.
  ///
  /// In en, this message translates to:
  /// **'WIN'**
  String get winLabel;

  /// No description provided for @lossLabel.
  ///
  /// In en, this message translates to:
  /// **'LOSS'**
  String get lossLabel;

  /// No description provided for @winRateLabel.
  ///
  /// In en, this message translates to:
  /// **'WIN RATE'**
  String get winRateLabel;

  /// No description provided for @noSignalsFound.
  ///
  /// In en, this message translates to:
  /// **'No signals found'**
  String get noSignalsFound;

  /// No description provided for @noCompletedSignalsYet.
  ///
  /// In en, this message translates to:
  /// **'No completed signals yet'**
  String get noCompletedSignalsYet;

  /// No description provided for @noFilterSignalsFound.
  ///
  /// In en, this message translates to:
  /// **'No {filter} signals found'**
  String noFilterSignalsFound(String filter);

  /// No description provided for @timeJustNow.
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get timeJustNow;

  /// No description provided for @timeDaysAgo.
  ///
  /// In en, this message translates to:
  /// **'{count}d ago'**
  String timeDaysAgo(int count);

  /// No description provided for @timeHoursAgo.
  ///
  /// In en, this message translates to:
  /// **'{count}h ago'**
  String timeHoursAgo(int count);

  /// No description provided for @timeMinutesAgo.
  ///
  /// In en, this message translates to:
  /// **'{count}m ago'**
  String timeMinutesAgo(int count);

  /// No description provided for @upgradeToSeeEntrySlTp.
  ///
  /// In en, this message translates to:
  /// **'Upgrade to see Entry, SL & TP'**
  String get upgradeToSeeEntrySlTp;

  /// No description provided for @entryPriceLabel.
  ///
  /// In en, this message translates to:
  /// **'ENTRY PRICE'**
  String get entryPriceLabel;

  /// No description provided for @takeProfitShort.
  ///
  /// In en, this message translates to:
  /// **'TAKEPROFIT'**
  String get takeProfitShort;

  /// No description provided for @riskRewardRatio.
  ///
  /// In en, this message translates to:
  /// **'R:R 1:{ratio}'**
  String riskRewardRatio(String ratio);

  /// No description provided for @pipsLabel.
  ///
  /// In en, this message translates to:
  /// **'Pips'**
  String get pipsLabel;

  /// No description provided for @entryShort.
  ///
  /// In en, this message translates to:
  /// **'ENTRY'**
  String get entryShort;

  /// No description provided for @exitLabel.
  ///
  /// In en, this message translates to:
  /// **'EXIT'**
  String get exitLabel;

  /// No description provided for @rrLabel.
  ///
  /// In en, this message translates to:
  /// **'R:R'**
  String get rrLabel;

  /// No description provided for @filterAll.
  ///
  /// In en, this message translates to:
  /// **'ALL'**
  String get filterAll;

  /// No description provided for @filterTpHit.
  ///
  /// In en, this message translates to:
  /// **'TP HIT'**
  String get filterTpHit;

  /// No description provided for @filterSlHit.
  ///
  /// In en, this message translates to:
  /// **'SL HIT'**
  String get filterSlHit;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'TradeGenZ'**
  String get profileTitle;

  /// No description provided for @winRateStat.
  ///
  /// In en, this message translates to:
  /// **'WIN RATE'**
  String get winRateStat;

  /// No description provided for @totalSignalsStat.
  ///
  /// In en, this message translates to:
  /// **'TOTAL SIGNALS'**
  String get totalSignalsStat;

  /// No description provided for @accountSection.
  ///
  /// In en, this message translates to:
  /// **'ACCOUNT'**
  String get accountSection;

  /// No description provided for @referralCode.
  ///
  /// In en, this message translates to:
  /// **'Referral Code'**
  String get referralCode;

  /// No description provided for @referralCodeCopied.
  ///
  /// In en, this message translates to:
  /// **'Referral code copied!'**
  String get referralCodeCopied;

  /// No description provided for @supportSection.
  ///
  /// In en, this message translates to:
  /// **'SUPPORT'**
  String get supportSection;

  /// No description provided for @contactWhatsApp.
  ///
  /// In en, this message translates to:
  /// **'Contact via WhatsApp'**
  String get contactWhatsApp;

  /// No description provided for @helpFaq.
  ///
  /// In en, this message translates to:
  /// **'Help & FAQ'**
  String get helpFaq;

  /// No description provided for @aboutSection.
  ///
  /// In en, this message translates to:
  /// **'ABOUT'**
  String get aboutSection;

  /// No description provided for @appVersion.
  ///
  /// In en, this message translates to:
  /// **'App Version'**
  String get appVersion;

  /// No description provided for @appVersionNumber.
  ///
  /// In en, this message translates to:
  /// **'1.0.0'**
  String get appVersionNumber;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @termsOfService.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsOfService;

  /// No description provided for @logoutAccount.
  ///
  /// In en, this message translates to:
  /// **'LOGOUT ACCOUNT'**
  String get logoutAccount;

  /// No description provided for @activeAffiliate.
  ///
  /// In en, this message translates to:
  /// **'Active Affiliate'**
  String get activeAffiliate;

  /// No description provided for @activePremium.
  ///
  /// In en, this message translates to:
  /// **'Active Premium'**
  String get activePremium;

  /// No description provided for @planExpires.
  ///
  /// In en, this message translates to:
  /// **'Expires: {date}'**
  String planExpires(String date);

  /// No description provided for @premiumFeature1.
  ///
  /// In en, this message translates to:
  /// **'Real-time High-Frequency Signals'**
  String get premiumFeature1;

  /// No description provided for @premiumFeature2.
  ///
  /// In en, this message translates to:
  /// **'Institutional Liquidity Heatmaps'**
  String get premiumFeature2;

  /// No description provided for @premiumFeature3.
  ///
  /// In en, this message translates to:
  /// **'Advanced Volatility Calculator'**
  String get premiumFeature3;

  /// No description provided for @upgradeToPremium.
  ///
  /// In en, this message translates to:
  /// **'Upgrade to Premium'**
  String get upgradeToPremium;

  /// No description provided for @unlockSignalsAlerts.
  ///
  /// In en, this message translates to:
  /// **'Unlock full signals & real-time alerts'**
  String get unlockSignalsAlerts;

  /// No description provided for @upgrade.
  ///
  /// In en, this message translates to:
  /// **'Upgrade'**
  String get upgrade;

  /// No description provided for @upgradePlanTitle.
  ///
  /// In en, this message translates to:
  /// **'Upgrade Plan'**
  String get upgradePlanTitle;

  /// No description provided for @proprietaryAlphaAccess.
  ///
  /// In en, this message translates to:
  /// **'PROPRIETARY ALPHA ACCESS'**
  String get proprietaryAlphaAccess;

  /// No description provided for @upgradePremiumTitle.
  ///
  /// In en, this message translates to:
  /// **'Upgrade to Premium'**
  String get upgradePremiumTitle;

  /// No description provided for @upgradePremiumSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Unlock high-velocity data execution and algorithmic signals built for the next generation of quants.'**
  String get upgradePremiumSubtitle;

  /// No description provided for @billingMonthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get billingMonthly;

  /// No description provided for @billingYearly.
  ///
  /// In en, this message translates to:
  /// **'Yearly'**
  String get billingYearly;

  /// No description provided for @save33.
  ///
  /// In en, this message translates to:
  /// **'Save 33%'**
  String get save33;

  /// No description provided for @planFree.
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get planFree;

  /// No description provided for @priceFree.
  ///
  /// In en, this message translates to:
  /// **'\$0'**
  String get priceFree;

  /// No description provided for @priceForever.
  ///
  /// In en, this message translates to:
  /// **'/ forever'**
  String get priceForever;

  /// No description provided for @freePlanFeature1.
  ///
  /// In en, this message translates to:
  /// **'Realtime signal direction (BUY/SELL)'**
  String get freePlanFeature1;

  /// No description provided for @freePlanFeature2.
  ///
  /// In en, this message translates to:
  /// **'See trading pair & status'**
  String get freePlanFeature2;

  /// No description provided for @freePlanFeature3.
  ///
  /// In en, this message translates to:
  /// **'Signal history (limited)'**
  String get freePlanFeature3;

  /// No description provided for @freePlanFeature4.
  ///
  /// In en, this message translates to:
  /// **'Entry price, SL & TP hidden'**
  String get freePlanFeature4;

  /// No description provided for @freePlanFeature5.
  ///
  /// In en, this message translates to:
  /// **'No push notifications'**
  String get freePlanFeature5;

  /// No description provided for @currentPlan.
  ///
  /// In en, this message translates to:
  /// **'Current Plan'**
  String get currentPlan;

  /// No description provided for @planPremium.
  ///
  /// In en, this message translates to:
  /// **'Premium'**
  String get planPremium;

  /// No description provided for @pricePremiumMonthly.
  ///
  /// In en, this message translates to:
  /// **'\$10'**
  String get pricePremiumMonthly;

  /// No description provided for @pricePerMonth.
  ///
  /// In en, this message translates to:
  /// **'/ month'**
  String get pricePerMonth;

  /// No description provided for @pricePremiumYearly.
  ///
  /// In en, this message translates to:
  /// **'\$80'**
  String get pricePremiumYearly;

  /// No description provided for @pricePerYear.
  ///
  /// In en, this message translates to:
  /// **'/ year (\$6.7/mo)'**
  String get pricePerYear;

  /// No description provided for @premiumPlanFeature1.
  ///
  /// In en, this message translates to:
  /// **'Full signal detail (Entry, SL, TP)'**
  String get premiumPlanFeature1;

  /// No description provided for @premiumPlanFeature2.
  ///
  /// In en, this message translates to:
  /// **'Realtime push notifications'**
  String get premiumPlanFeature2;

  /// No description provided for @premiumPlanFeature3.
  ///
  /// In en, this message translates to:
  /// **'All trading pairs'**
  String get premiumPlanFeature3;

  /// No description provided for @premiumPlanFeature4.
  ///
  /// In en, this message translates to:
  /// **'Complete signal history'**
  String get premiumPlanFeature4;

  /// No description provided for @premiumPlanFeature5.
  ///
  /// In en, this message translates to:
  /// **'No ads'**
  String get premiumPlanFeature5;

  /// No description provided for @getPremium.
  ///
  /// In en, this message translates to:
  /// **'Get Premium'**
  String get getPremium;

  /// No description provided for @planAffiliate.
  ///
  /// In en, this message translates to:
  /// **'Affiliate'**
  String get planAffiliate;

  /// No description provided for @priceAffiliate.
  ///
  /// In en, this message translates to:
  /// **'FREE'**
  String get priceAffiliate;

  /// No description provided for @priceViaBroker.
  ///
  /// In en, this message translates to:
  /// **'(via broker)'**
  String get priceViaBroker;

  /// No description provided for @affiliatePlanFeature1.
  ///
  /// In en, this message translates to:
  /// **'Everything in Premium'**
  String get affiliatePlanFeature1;

  /// No description provided for @affiliatePlanFeature2.
  ///
  /// In en, this message translates to:
  /// **'Register via our broker link'**
  String get affiliatePlanFeature2;

  /// No description provided for @affiliatePlanFeature3.
  ///
  /// In en, this message translates to:
  /// **'No monthly fee'**
  String get affiliatePlanFeature3;

  /// No description provided for @affiliatePlanFeature4.
  ///
  /// In en, this message translates to:
  /// **'Active trading required'**
  String get affiliatePlanFeature4;

  /// No description provided for @registerViaBroker.
  ///
  /// In en, this message translates to:
  /// **'Register via Broker'**
  String get registerViaBroker;

  /// No description provided for @contactWhatsAppActivate.
  ///
  /// In en, this message translates to:
  /// **'Contact us via WhatsApp to activate your plan'**
  String get contactWhatsAppActivate;

  /// No description provided for @affiliatePlanCard.
  ///
  /// In en, this message translates to:
  /// **'Affiliate Plan'**
  String get affiliatePlanCard;

  /// No description provided for @premiumPlanCard.
  ///
  /// In en, this message translates to:
  /// **'Premium Plan'**
  String get premiumPlanCard;

  /// No description provided for @planActiveUntil.
  ///
  /// In en, this message translates to:
  /// **'Active until {date}'**
  String planActiveUntil(String date);

  /// No description provided for @getPremiumUnlock.
  ///
  /// In en, this message translates to:
  /// **'Get unlimited signals & real-time alerts'**
  String get getPremiumUnlock;

  /// No description provided for @calculatorTitle.
  ///
  /// In en, this message translates to:
  /// **'Lot Size Calculator'**
  String get calculatorTitle;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @tradingPair.
  ///
  /// In en, this message translates to:
  /// **'Trading Pair'**
  String get tradingPair;

  /// No description provided for @accountBalance.
  ///
  /// In en, this message translates to:
  /// **'Account Balance'**
  String get accountBalance;

  /// No description provided for @riskPerTrade.
  ///
  /// In en, this message translates to:
  /// **'Risk per Trade'**
  String get riskPerTrade;

  /// No description provided for @riskLevelConservative.
  ///
  /// In en, this message translates to:
  /// **'Conservative'**
  String get riskLevelConservative;

  /// No description provided for @riskLevelModerate.
  ///
  /// In en, this message translates to:
  /// **'Moderate'**
  String get riskLevelModerate;

  /// No description provided for @riskLevelAggressive.
  ///
  /// In en, this message translates to:
  /// **'Aggressive'**
  String get riskLevelAggressive;

  /// No description provided for @riskLevelVeryHigh.
  ///
  /// In en, this message translates to:
  /// **'Very High Risk'**
  String get riskLevelVeryHigh;

  /// No description provided for @stopLoss.
  ///
  /// In en, this message translates to:
  /// **'Stop Loss'**
  String get stopLoss;

  /// No description provided for @pipsUnit.
  ///
  /// In en, this message translates to:
  /// **'pips'**
  String get pipsUnit;

  /// No description provided for @calculatePosition.
  ///
  /// In en, this message translates to:
  /// **'CALCULATE POSITION'**
  String get calculatePosition;

  /// No description provided for @recommendedPositionSize.
  ///
  /// In en, this message translates to:
  /// **'RECOMMENDED POSITION SIZE'**
  String get recommendedPositionSize;

  /// No description provided for @lotsUnit.
  ///
  /// In en, this message translates to:
  /// **'LOTS'**
  String get lotsUnit;

  /// No description provided for @riskAmount.
  ///
  /// In en, this message translates to:
  /// **'RISK AMOUNT'**
  String get riskAmount;

  /// No description provided for @riskLevel.
  ///
  /// In en, this message translates to:
  /// **'RISK LEVEL'**
  String get riskLevel;

  /// No description provided for @noInternetConnection.
  ///
  /// In en, this message translates to:
  /// **'No internet connection'**
  String get noInternetConnection;

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'TRADEGENZ'**
  String get loginTitle;

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'SECURE QUANTUM TERMINAL ACCESS'**
  String get loginSubtitle;

  /// No description provided for @loginEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'EMAIL TERMINAL ID'**
  String get loginEmailLabel;

  /// No description provided for @loginPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'ACCESS CIPHER'**
  String get loginPasswordLabel;

  /// No description provided for @forgotPasswordLink.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPasswordLink;

  /// No description provided for @initiateLogin.
  ///
  /// In en, this message translates to:
  /// **'INITIATE LOGIN'**
  String get initiateLogin;

  /// No description provided for @systemIntegrity.
  ///
  /// In en, this message translates to:
  /// **'SYSTEM INTEGRITY: OPTIMAL'**
  String get systemIntegrity;

  /// No description provided for @sslVerified.
  ///
  /// In en, this message translates to:
  /// **'SSL VERIFIED'**
  String get sslVerified;

  /// No description provided for @processing.
  ///
  /// In en, this message translates to:
  /// **'Processing...'**
  String get processing;

  /// No description provided for @purchaseSuccess.
  ///
  /// In en, this message translates to:
  /// **'Purchase successful! Premium activated.'**
  String get purchaseSuccess;

  /// No description provided for @restorePurchases.
  ///
  /// In en, this message translates to:
  /// **'Restore Purchases'**
  String get restorePurchases;

  /// No description provided for @whatsappUpgradeMessage.
  ///
  /// In en, this message translates to:
  /// **'Hello, I want to upgrade to {plan} plan ({price}) on TradeGenZ.'**
  String whatsappUpgradeMessage(String plan, String price);

  /// No description provided for @whatsappAffiliateMessage.
  ///
  /// In en, this message translates to:
  /// **'Hello, I want to activate the Affiliate Plan on TradeGenZ.'**
  String get whatsappAffiliateMessage;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'id'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'id':
      return AppLocalizationsId();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
