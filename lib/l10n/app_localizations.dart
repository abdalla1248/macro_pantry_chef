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
  /// **'Protein'**
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

  /// No description provided for @proteinShort.
  ///
  /// In en, this message translates to:
  /// **'Pro'**
  String get proteinShort;

  /// No description provided for @carbsShort.
  ///
  /// In en, this message translates to:
  /// **'Carb'**
  String get carbsShort;

  /// No description provided for @fatShort.
  ///
  /// In en, this message translates to:
  /// **'Fat'**
  String get fatShort;

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

  /// No description provided for @noIngredientsFound.
  ///
  /// In en, this message translates to:
  /// **'No ingredients found.'**
  String get noIngredientsFound;

  /// No description provided for @recipeNotFound.
  ///
  /// In en, this message translates to:
  /// **'Recipe not found'**
  String get recipeNotFound;

  /// No description provided for @matches.
  ///
  /// In en, this message translates to:
  /// **'matches'**
  String get matches;

  /// No description provided for @availableRecipes.
  ///
  /// In en, this message translates to:
  /// **'Available Recipes'**
  String get availableRecipes;

  /// No description provided for @caloriesLabel.
  ///
  /// In en, this message translates to:
  /// **'Calories'**
  String get caloriesLabel;

  /// No description provided for @proteinLabel.
  ///
  /// In en, this message translates to:
  /// **'Protein'**
  String get proteinLabel;

  /// No description provided for @carbsLabel.
  ///
  /// In en, this message translates to:
  /// **'Carbs'**
  String get carbsLabel;

  /// No description provided for @fatLabel.
  ///
  /// In en, this message translates to:
  /// **'Fat'**
  String get fatLabel;

  /// No description provided for @mins.
  ///
  /// In en, this message translates to:
  /// **'mins'**
  String get mins;

  /// No description provided for @servings.
  ///
  /// In en, this message translates to:
  /// **'Servings'**
  String get servings;

  /// No description provided for @runningLow.
  ///
  /// In en, this message translates to:
  /// **'Running low'**
  String get runningLow;

  /// No description provided for @missing.
  ///
  /// In en, this message translates to:
  /// **'missing'**
  String get missing;

  /// No description provided for @minShort.
  ///
  /// In en, this message translates to:
  /// **'min'**
  String get minShort;

  /// No description provided for @premiumMember.
  ///
  /// In en, this message translates to:
  /// **'Premium Member'**
  String get premiumMember;

  /// No description provided for @dailyCalories.
  ///
  /// In en, this message translates to:
  /// **'Daily Calories'**
  String get dailyCalories;

  /// No description provided for @dailyGoals.
  ///
  /// In en, this message translates to:
  /// **'Daily Goals'**
  String get dailyGoals;

  /// No description provided for @hydration.
  ///
  /// In en, this message translates to:
  /// **'Hydration'**
  String get hydration;

  /// No description provided for @meals.
  ///
  /// In en, this message translates to:
  /// **'Meals'**
  String get meals;

  /// No description provided for @weightGoal.
  ///
  /// In en, this message translates to:
  /// **'Weight Goal'**
  String get weightGoal;

  /// No description provided for @dietaryPreferences.
  ///
  /// In en, this message translates to:
  /// **'Dietary Preferences'**
  String get dietaryPreferences;

  /// No description provided for @allergiesRestrictions.
  ///
  /// In en, this message translates to:
  /// **'Allergies & Restrictions'**
  String get allergiesRestrictions;

  /// No description provided for @addPreference.
  ///
  /// In en, this message translates to:
  /// **'Add Preference'**
  String get addPreference;

  /// No description provided for @addRestriction.
  ///
  /// In en, this message translates to:
  /// **'Add Restriction'**
  String get addRestriction;

  /// No description provided for @themeSettings.
  ///
  /// In en, this message translates to:
  /// **'Theme Settings'**
  String get themeSettings;

  /// No description provided for @languageSettings.
  ///
  /// In en, this message translates to:
  /// **'Language Settings'**
  String get languageSettings;

  /// No description provided for @logOut.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get logOut;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @selectThemeMode.
  ///
  /// In en, this message translates to:
  /// **'Select Theme Mode'**
  String get selectThemeMode;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @planner.
  ///
  /// In en, this message translates to:
  /// **'Planner'**
  String get planner;

  /// No description provided for @plannerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Design your fuel for the day.'**
  String get plannerSubtitle;

  /// No description provided for @daily.
  ///
  /// In en, this message translates to:
  /// **'Daily'**
  String get daily;

  /// No description provided for @weekly.
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get weekly;

  /// No description provided for @mealsPlanned.
  ///
  /// In en, this message translates to:
  /// **'Meals Planned'**
  String get mealsPlanned;

  /// No description provided for @shoppingList.
  ///
  /// In en, this message translates to:
  /// **'Shopping List'**
  String get shoppingList;

  /// No description provided for @addRecipeSlot.
  ///
  /// In en, this message translates to:
  /// **'Add {slot} Recipe'**
  String addRecipeSlot(String slot);

  /// No description provided for @favorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favorites;

  /// No description provided for @favoritesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your saved recipe treasures.'**
  String get favoritesSubtitle;

  /// No description provided for @noSavedRecipes.
  ///
  /// In en, this message translates to:
  /// **'No saved recipes yet.'**
  String get noSavedRecipes;

  /// No description provided for @saveRecipeInstructions.
  ///
  /// In en, this message translates to:
  /// **'Tap the heart icon on any recipe details page.'**
  String get saveRecipeInstructions;

  /// No description provided for @missingIngredientsAggregated.
  ///
  /// In en, this message translates to:
  /// **'Missing ingredients automatically compiled against your current pantry stock.'**
  String get missingIngredientsAggregated;

  /// No description provided for @allIngredientsInStock.
  ///
  /// In en, this message translates to:
  /// **'All set! You have everything in stock.'**
  String get allIngredientsInStock;
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
