part of 'home_bloc.dart';

enum HomeStatus {
  initial,
  loading,
  success,
  failure,
  emptyFailure,
  showDialog,
  showDialogFailure,
}

class HomeState extends Equatable {
  const HomeState({
    this.status = HomeStatus.initial,
    this.initialPrefix,
    this.countryCodeMap,
  });

  final HomeStatus status;
  final String? initialPrefix;
  final CountryCodeMap? countryCodeMap;

  HomeState copyWith({
    HomeStatus? status,
    String? initialPrefix,
    CountryCodeMap? countryCodeMap,
  }) {
    return HomeState(
      status: status ?? this.status,
      initialPrefix: initialPrefix ?? this.initialPrefix,
      countryCodeMap: countryCodeMap ?? this.countryCodeMap,
    );
  }

  @override
  List<Object?> get props => [status, initialPrefix, countryCodeMap];
}
