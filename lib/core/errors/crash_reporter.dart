abstract class CrashReporter {
  Future<void> init({required Function() appRunner});
  Future<void> captureException(dynamic error, {dynamic stackTrace});
  Future<void> captureMessage(String message);
}
