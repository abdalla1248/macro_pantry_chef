import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

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
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Macro Pantry Chef'**
  String get appName;

  /// No description provided for @tagline.
  ///
  /// In en, this message translates to:
  /// **'Cook Smart. Eat Better.'**
  String get tagline;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navPantry.
  ///
  /// In en, this message translates to:
  /// **'Pantry'**
  String get navPantry;

  /// No description provided for @navPlanner.
  ///
  /// In en, this message translates to:
  /// **'Planner'**
  String get navPlanner;

  /// No description provided for @navFavorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get navFavorites;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @recentRecipes.
  ///
  /// In en, this message translates to:
  /// **'Recent Recipes'**
  String get recentRecipes;

  /// No description provided for @yourPantry.
  ///
  /// In en, this message translates to:
  /// **'Your Pantry'**
  String get yourPantry;

  /// No description provided for @pantryDescription.
  ///
  /// In en, this message translates to:
  /// **'Add ingredients to find recipes.'**
  String get pantryDescription;

  /// No description provided for @searchIngredientsPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Search ingredients...'**
  String get searchIngredientsPlaceholder;

  /// No description provided for @addManually.
  ///
  /// In en, this message translates to:
  /// **'Add Manually'**
  String get addManually;

  /// No description provided for @currentInventory.
  ///
  /// In en, this message translates to:
  /// **'CURRENT INVENTORY'**
  String get currentInventory;

  /// No description provided for @savePantryInventory.
  ///
  /// In en, this message translates to:
  /// **'Save Pantry & Find Recipes'**
  String get savePantryInventory;

  /// No description provided for @macroFilter.
  ///
  /// In en, this message translates to:
  /// **'Macro Filter'**
  String get macroFilter;

  /// No description provided for @macroTargets.
  ///
  /// In en, this message translates to:
  /// **'Macro Targets'**
  String get macroTargets;

  /// No description provided for @protein.
  ///
  /// In en, this message translates to:
  /// **'P'**
  String get protein;

  /// No description provided for @carbohydrates.
  ///
  /// In en, this message translates to:
  /// **'Carbohydrates'**
  String get carbohydrates;

  /// No description provided for @fats.
  ///
  /// In en, this message translates to:
  /// **'Fats'**
  String get fats;

  /// No description provided for @calories.
  ///
  /// In en, this message translates to:
  /// **'Calories'**
  String get calories;

  /// No description provided for @viewMenu.
  ///
  /// In en, this message translates to:
  /// **'View Menu'**
  String get viewMenu;

  /// No description provided for @matchingRecipes.
  ///
  /// In en, this message translates to:
  /// **'Matching Recipes'**
  String get matchingRecipes;

  /// No description provided for @foundOptions.
  ///
  /// In en, this message translates to:
  /// **'Found {count} options from your pantry'**
  String foundOptions(int count);

  /// No description provided for @ingredients.
  ///
  /// In en, this message translates to:
  /// **'Ingredients'**
  String get ingredients;

  /// No description provided for @cookingInstructions.
  ///
  /// In en, this message translates to:
  /// **'Cooking Instructions'**
  String get cookingInstructions;

  /// No description provided for @cookNow.
  ///
  /// In en, this message translates to:
  /// **'Cook Now'**
  String get cookNow;

  /// No description provided for @saveToPlanner.
  ///
  /// In en, this message translates to:
  /// **'Save to Planner'**
  String get saveToPlanner;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search recipes, ingredients, or macros...'**
  String get searchHint;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @ingredientsIHave.
  ///
  /// In en, this message translates to:
  /// **'Ingredients I Have'**
  String get ingredientsIHave;

  /// No description provided for @managePantry.
  ///
  /// In en, this message translates to:
  /// **'Manage Pantry'**
  String get managePantry;

  /// No description provided for @ingredientCount.
  ///
  /// In en, this message translates to:
  /// **'You have {count} items logged. Let\'s see what we can make.'**
  String ingredientCount(int count);

  /// No description provided for @addItem.
  ///
  /// In en, this message translates to:
  /// **'Add Item'**
  String get addItem;

  /// No description provided for @generateMealIdeas.
  ///
  /// In en, this message translates to:
  /// **'Generate Meal Ideas'**
  String get generateMealIdeas;

  /// No description provided for @todaysRecommendations.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Recommendations'**
  String get todaysRecommendations;

  /// No description provided for @quickFilters.
  ///
  /// In en, this message translates to:
  /// **'Quick Filters'**
  String get quickFilters;

  /// No description provided for @highProtein.
  ///
  /// In en, this message translates to:
  /// **'High Protein'**
  String get highProtein;

  /// No description provided for @lowCarb.
  ///
  /// In en, this message translates to:
  /// **'Low Carb'**
  String get lowCarb;

  /// No description provided for @vegetarian.
  ///
  /// In en, this message translates to:
  /// **'Vegetarian'**
  String get vegetarian;

  /// No description provided for @vegan.
  ///
  /// In en, this message translates to:
  /// **'Vegan'**
  String get vegan;

  /// No description provided for @keto.
  ///
  /// In en, this message translates to:
  /// **'Keto'**
  String get keto;

  /// No description provided for @glutenFree.
  ///
  /// In en, this message translates to:
  /// **'Gluten Free'**
  String get glutenFree;

  /// No description provided for @carbs.
  ///
  /// In en, this message translates to:
  /// **'C'**
  String get carbs;

  /// No description provided for @fat.
  ///
  /// In en, this message translates to:
  /// **'F'**
  String get fat;

  /// No description provided for @minutes.
  ///
  /// In en, this message translates to:
  /// **'m'**
  String get minutes;

  /// No description provided for @grilledSalmonBowl.
  ///
  /// In en, this message translates to:
  /// **'Grilled Lemon Herb Salmon Bowl'**
  String get grilledSalmonBowl;

  /// No description provided for @grilledSalmonDesc.
  ///
  /// In en, this message translates to:
  /// **'Rich in Omega-3s and lean protein.'**
  String get grilledSalmonDesc;

  /// No description provided for @chickpeaSalad.
  ///
  /// In en, this message translates to:
  /// **'Mediterranean Chickpea Salad'**
  String get chickpeaSalad;

  /// No description provided for @chickpeaSaladDesc.
  ///
  /// In en, this message translates to:
  /// **'Quick, fiber-rich lunch option.'**
  String get chickpeaSaladDesc;

  /// No description provided for @chickenBreast.
  ///
  /// In en, this message translates to:
  /// **'Chicken Breast'**
  String get chickenBreast;

  /// No description provided for @sweetPotato.
  ///
  /// In en, this message translates to:
  /// **'Sweet Potato'**
  String get sweetPotato;

  /// No description provided for @broccoli.
  ///
  /// In en, this message translates to:
  /// **'Broccoli'**
  String get broccoli;

  /// No description provided for @quinoa.
  ///
  /// In en, this message translates to:
  /// **'Quinoa'**
  String get quinoa;

  /// No description provided for @comingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming Soon'**
  String get comingSoon;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @lightMode.
  ///
  /// In en, this message translates to:
  /// **'Light Mode'**
  String get lightMode;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;
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
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
