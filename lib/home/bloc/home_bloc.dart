import 'dart:convert';

import 'package:app/home/models/country_code_map.dart';
import 'package:app/network/dia_manager.dart';
import 'package:bloc/bloc.dart';
import 'package:common_utils/common_utils.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:phone_number_repository/phone_number_repository.dart';

part 'home_event.dart';

part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc({
    required PhoneNumberRepository repository,
    required String? initialPrefix,
  })  : _repository = repository,
        super(
          HomeState(
            initialPrefix: initialPrefix,
          ),
        ) {
    on<FetchDataEvent>(_onFetchData);
    on<SetPrefixEvent>(_onSetPrefix);
    on<ConfirmNumberEvent>(_onConfirmNumber);
  }

  final PhoneNumberRepository _repository;

  Future<void> _onFetchData(
    FetchDataEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(status: HomeStatus.loading));
    // 发出请求
    final response = await DioManager().get<String>(
      'http://country.io/phone.json',
      options: Options(responseType: ResponseType.plain),
    );
    final str = response.data.toString();
    final CountryCodeMap map = jsonDecode(str);
    if (map.isNotEmpty) {
      emit(state.copyWith(status: HomeStatus.showDialog, countryCodeMap: map));
    } else {
      emit(state.copyWith(status: HomeStatus.showDialogFailure));
    }
  }

  void _onSetPrefix(SetPrefixEvent event, Emitter<HomeState> emit) {
    emit(
      state.copyWith(
        status: HomeStatus.initial,
        initialPrefix: event.prefix,
      ),
    );
  }

  Future<void> _onConfirmNumber(
    ConfirmNumberEvent event,
    Emitter<HomeState> emit,
  ) async {
    LogUtil.e('${event.prefix} ${event.confirmNumber}');
    emit(state.copyWith(status: HomeStatus.loading));
    if (event.confirmNumber.isEmpty) {
      emit(state.copyWith(status: HomeStatus.emptyFailure));
      return;
    }
    final phoneNumber =
        PhoneNumber(prefix: event.prefix, number: event.confirmNumber);
    try {
      await _repository.save(phoneNumber);
      emit(state.copyWith(status: HomeStatus.success));
    } catch (e) {
      emit(state.copyWith(status: HomeStatus.failure));
    }
  }
}
