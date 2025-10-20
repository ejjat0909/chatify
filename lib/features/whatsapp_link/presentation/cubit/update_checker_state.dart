abstract class UpdateCheckerState {}

class UpdateCheckerInitial extends UpdateCheckerState {}

class UpdateCheckerLoading extends UpdateCheckerState {}

class UpdateCheckerSuccess extends UpdateCheckerState {
  final String updateUrl;
  final String newVersion;

  UpdateCheckerSuccess(this.updateUrl, this.newVersion);
}

class UpdateCheckerNoUpdate extends UpdateCheckerState {}

class UpdateCheckerFailure extends UpdateCheckerState {
  final String error;

  UpdateCheckerFailure(this.error);
}
