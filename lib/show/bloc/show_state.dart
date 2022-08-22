part of 'show_bloc.dart';

enum ShowStatus { initial, loading, success, failure }

class ShowState extends Equatable {
  const ShowState({
    this.status = ShowStatus.initial,
    this.numberList = const [],
  });

  final ShowStatus status;
  final List<PhoneNumber> numberList;

  ShowState copyWith({ShowStatus? status, List<PhoneNumber>? numberList}) {
    return ShowState(
      status: status ?? this.status,
      numberList: numberList ?? this.numberList,
    );
  }

  @override
  List<Object?> get props => [status, numberList];
}
