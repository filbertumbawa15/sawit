part of 'form_master_bloc.dart';

abstract class FormMasterState {}

class FormMasterInitial extends FormMasterState {}

class FormMasterLoading extends FormMasterState {}

class FormMasterLoaded extends FormMasterState {
  final MasterDataResponse data;

  final bool isSubmitting;
  final bool isSubmitSuccess;
  final String? submitErrorMessage;

  FormMasterLoaded(
    this.data, {
    this.isSubmitting = false,
    this.isSubmitSuccess = false,
    this.submitErrorMessage,
  });

  FormMasterLoaded copyWith({
    MasterDataResponse? data,
    bool? isSubmitting,
    bool? isSubmitSuccess,
    String? submitErrorMessage,
  }) {
    return FormMasterLoaded(
      data ?? this.data,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSubmitSuccess: isSubmitSuccess ?? this.isSubmitSuccess,
      submitErrorMessage: submitErrorMessage,
    );
  }
}

class FormMasterError extends FormMasterState {
  final String message;
  FormMasterError(this.message);
}
