part of 'kontroloperasional_bloc.dart';

abstract class KontrolOperasionalEvent {}

class FetchListKontrol extends KontrolOperasionalEvent {
  final int page;

  FetchListKontrol({this.page = 1});
}
