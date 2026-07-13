part of 'form_master_bloc.dart';

abstract class FormMasterEvent {}

class FetchMasterData extends FormMasterEvent {}

class SubmitFormH0Event extends FormMasterEvent {
  final SubmitFormH0Param param;
  SubmitFormH0Event(this.param);
}