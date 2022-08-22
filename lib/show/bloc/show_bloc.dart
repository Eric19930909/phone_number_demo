import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phone_number_repository/phone_number_repository.dart';

part 'show_event.dart';

part 'show_state.dart';

class ShowBloc extends Bloc<ShowEvent, ShowState> {
  ShowBloc({
    required PhoneNumberRepository repository,
  })  : _repository = repository,
        super(const ShowState()) {
    on<ShowDataEvent>(_onDataRequested);
  }

  final PhoneNumberRepository _repository;

  Future<void> _onDataRequested(
    ShowDataEvent event,
    Emitter<ShowState> emit,
  ) async {
    emit(state.copyWith(status: ShowStatus.loading));

    await emit.forEach<List<PhoneNumber>>(
      _repository.getAllPhoneNumber(),
      onData: (value) => state.copyWith(
        status: ShowStatus.success,
        numberList: value,
      ),
      onError: (_, __) => state.copyWith(status: ShowStatus.failure),
    );
  }
}
