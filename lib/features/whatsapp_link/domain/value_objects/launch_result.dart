sealed class LaunchResult {
  const LaunchResult();

  const factory LaunchResult.success() = LaunchSuccess;
  const factory LaunchResult.failed(String message) = LaunchFailed;

  T when<T>({
    required T Function() success,
    required T Function(String message) failed,
  }) {
    final result = this;
    if (result is LaunchSuccess) {
      return success();
    }
    return failed((result as LaunchFailed).message);
  }
}

class LaunchSuccess extends LaunchResult {
  const LaunchSuccess();
}

class LaunchFailed extends LaunchResult {
  const LaunchFailed(this.message);

  final String message;
}