part of 'kontroloperasional_bloc.dart';

abstract class KontrolOperasionalState {}

class KontrolOperasionalInitial extends KontrolOperasionalState {}

class KontrolOperasionalLoading extends KontrolOperasionalState {}

class KontrolOperasionalLoaded extends KontrolOperasionalState {
  // State ini akan membawa array JSON dari backend ke UI
  final List<dynamic> data;
  
  KontrolOperasionalLoaded(this.data);
}

class KontrolOperasionalError extends KontrolOperasionalState {
  final String message;
  
  KontrolOperasionalError(this.message);
}
