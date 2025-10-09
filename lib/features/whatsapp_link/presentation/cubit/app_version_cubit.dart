import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'app_version_state.dart';

class AppVersionCubit extends Cubit<AppVersionState> {
  AppVersionCubit() : super(AppVersionState.initial());

  Future<void> loadVersion() async {
    emit(AppVersionState.loading());
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      final formatted = '${packageInfo.version} (${packageInfo.buildNumber})';
      emit(AppVersionState.success(formatted));
    } catch (error) {
      emit(AppVersionState.failure(error.toString()));
    }
  }
}