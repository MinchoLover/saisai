class NaverMapConfig {
  const NaverMapConfig._();

  static const clientId = String.fromEnvironment('NAVER_MAP_CLIENT_ID');
  static bool get isConfigured => clientId.trim().isNotEmpty;
}
