/// Application-wide constants.
abstract final class AppConstants {
  // ── Design Dimensions ──────────────────────────────────────────────
  static const double designWidth = 390;
  static const double designHeight = 844;

  // ── Durations ──────────────────────────────────────────────────────
  static const Duration splashDuration = Duration(seconds: 3);
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration floatAnimationDuration = Duration(seconds: 6);

  // ── Placeholder Image URLs (from Stitch design) ────────────────────
  static const String splashBackgroundUrl =
      'https://lh3.googleusercontent.com/aida-public/AB6AXuClO55kvSk3wDFLgzXn9MwaVdde795sxNFy5LdY3bmgMr85Lmb0AzzV9dUaPl_5cl8_RjDE67tvPS4z6QJfnoNstnJLfBpgD2BV-kackIX77Ry0u9KYqbXHB9FeoTpZUTOnZTojZ1yTUSh-jylM-bbTLDPzBShUwD2TREJKYww74Sw0UqIjJ2tKEVTjzNUAhwPr7kPZ_RcckwF32-xhaFCI4SYfCggR0Z7HG_AlXTyFjvG9OYm6SKphPAe328PUKcECGyDzpJ11314';

  static const String logoUrl =
      'https://lh3.googleusercontent.com/aida-public/AB6AXuAsrPfl6ENg40WfF4gm51lJpwBI3NmmZkREed9nJF6F8uMIgkYpWupUAOJZ2NdZJ1CCba9ACVDB5Gb6ub4Jcqow4UZ0WvdBUDANb89KfYFlNhH0a8JZxY43S1b-NMkP-idc4pycNdkAb_pX2ShCO5vweiQKra9prd9nb55XA8wZ4-OFukv_932MdKsIijV53H8uCJ-qpy9yKpWl3t2ILD55xlxZ-L2ND9LmZUx9dolIwgbNtrXhDt9A4E3GI6WvxPGEo6prgwM3XDI';

  static const String userAvatarUrl =
      'https://lh3.googleusercontent.com/aida-public/AB6AXuDiWYXxJT9d0hJgztzM9EVvZn9WisVyS8QnG84kddH21NTy_0dpc3usl1aGpK5rySH0uZRmhX3Poy2YRb2S_lrApmm9OprUsRvb1HfeGmetAzVXw5xgp9q8xckU-xaChvC0AzsBToKb3KRMNyP8egpfHQZe0fWES-97lDFSD6F49IF-u9LX5YiCkC0LFoKPD9lgjLQtLzVCDyJ0T-UmINDTEkYFtot1QFdYLflxNS-ceGotAdGLeW9mJCNpwfkmwCVMcR8Ulyw3dEE';

  static const String salmonBowlUrl =
      'https://lh3.googleusercontent.com/aida-public/AB6AXuBGOIDkqAV3nZoOmZ9adecyBPHX4dY3I8qHVcq5WRy-pqOtveA-rKbTCU_WWQF7MN-ZG-iRw3ra9lRroJ8H5gkz0EDH5uVyXbBxvDv413dpG5skkiVsomck7COKcsNNwzX-AOdl8kYnPE_ivnTeSiCQnVmK3l_PeReP2SZTlw3ePPo2jHG8xTZ86KKbjevbIMFlwl3lzYekh-75rmsWX0xfEyc4D92Vx4dONvYUvul5auPTgMC9_a4YYHBVWV06yNlFwd6RZjmjm7k';

  static const String chickpeaSaladUrl =
      'https://lh3.googleusercontent.com/aida-public/AB6AXuAAOuSby65RFvp74FMV0Hl8NTvtF_xzbMbeWbg5FKxnMKTD96L3xC6ug0Me_jUbZyVqZ_WmCFFs8cVTVz80WNsJ_tN40-AqFxRx1O5srguKpCz1J5-XP9BdtPrzk_veqpQISz4opUSW4GqBrUipjgI5yfykEC3gOECi0lSVhwjtIW3pbbsGCQtEELsEAmI-bmx0QFzwWZX0yGLO_OdnjK6c3Bioy-Ebuy9moGGv2k05y9r8XWEPVJxRSCNKII_c9mr6tbhLFP2YiVo';

  // ── SharedPreferences Keys ─────────────────────────────────────────
  static const String themeKey = 'theme_mode';
  static const String localeKey = 'locale';
}
