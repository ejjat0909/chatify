import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'update_checker_state.dart';

class UpdateCheckerCubit extends Cubit<UpdateCheckerState> {
  UpdateCheckerCubit() : super(UpdateCheckerInitial());

  Future<void> checkForUpdate(String currentVersion) async {
    emit(UpdateCheckerLoading());
    try {
      final response = await Dio().get(
        'https://raw.githubusercontent.com/ejjat0909/chatify-download/main/version.json',
      );
      final data = response.data is String
          ? jsonDecode(response.data) as Map<String, dynamic>
          : response.data as Map<String, dynamic>;
      print("data ${response.data}");
      final latestVersion = data['version'] as String;
      final updateUrl = data['url'] as String;
      print("deviceVersion $currentVersion");
      print("latestVersion $latestVersion");
      if (latestVersion != currentVersion) {
        emit(UpdateCheckerSuccess(updateUrl, latestVersion));
      } else {
        emit(UpdateCheckerNoUpdate());
      }
    } catch (e) {
      print("FAIL TO GET UPDATE CHECKER ${e.toString()}");
      emit(UpdateCheckerFailure(e.toString()));
    }
  }
}
