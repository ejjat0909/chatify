enum AppVersionStatus { initial, loading, success, failure }

class AppVersionState {
  const AppVersionState({
    required this.version,
    required this.status,
    this.errorMessage,
  });

  final String version;
  final AppVersionStatus status;
  final String? errorMessage;

  factory AppVersionState.initial() {
    return const AppVersionState(version: '', status: AppVersionStatus.initial);
  }

  factory AppVersionState.loading() {
    return const AppVersionState(version: '', status: AppVersionStatus.loading);
  }

  factory AppVersionState.success(String version) {
    return AppVersionState(version: version, status: AppVersionStatus.success);
  }

  factory AppVersionState.failure(String message) {
    return AppVersionState(
      version: '',
      status: AppVersionStatus.failure,
      errorMessage: message,
    );
  }
}
