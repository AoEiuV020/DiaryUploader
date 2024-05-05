/// Checks if you are awesome. Spoiler: you are.
abstract class GoogleCalenderUploader {
  Future<void> setApiKey(String apiKey);
  Future<void> setOAuthToken(String accessToken);
  Future<void> setServiceAccount(String json);
  Future<void> insert(String calenderId, int start, int end, String content);
}
