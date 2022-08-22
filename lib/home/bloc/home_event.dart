part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class FetchDataEvent extends HomeEvent {
  const FetchDataEvent();
}

class SetPrefixEvent extends HomeEvent {
  const SetPrefixEvent(this.prefix);

  final String prefix;

  @override
  List<Object> get props => [prefix];
}

class ConfirmNumberEvent extends HomeEvent {
  const ConfirmNumberEvent(this.prefix, this.confirmNumber);

  final String prefix;
  final String confirmNumber;

  @override
  List<Object> get props => [prefix, confirmNumber];
}
