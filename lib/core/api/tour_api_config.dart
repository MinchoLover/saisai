class TourApiConfig {
  const TourApiConfig._();

  static const serviceKey = String.fromEnvironment('TOUR_API_SERVICE_KEY');
  static const mobileApp = 'Saisai';

  static bool get isConfigured => serviceKey.trim().isNotEmpty;
}
