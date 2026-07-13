import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sawit/features/kontrol_operasional/data/datasources/kontrol_operasional_data_source.dart';
import 'package:sawit/features/kontrol_operasional/data/models/form_submit_h0_param.dart';
import 'package:sawit/features/kontrol_operasional/data/models/master_data_model.dart';

part 'form_master_event.dart';
part 'form_master_state.dart';

class FormMasterBloc extends Bloc<FormMasterEvent, FormMasterState> {
  final KontrolOperasionalDataSource dataSource;
  FormMasterBloc({required this.dataSource}) : super(FormMasterInitial()) {
    on<FetchMasterData>((event, emit) async {
      emit(FormMasterLoading());
      try {
        final data = await dataSource.getMasterData();
        emit(FormMasterLoaded(data));
      } catch (e) {
        emit(FormMasterError(e.toString()));
      }
    });

    on<SubmitFormH0Event>((event, emit) async {
      if (state is FormMasterLoaded) {
        final currentState = state as FormMasterLoaded;
        emit(currentState.copyWith(
            isSubmitting: true,
            submitErrorMessage: null,
            isSubmitSuccess: false));

        try {
          await dataSource.submitFormH0(event.param);

          emit(currentState.copyWith(
              isSubmitting: false, isSubmitSuccess: true));
        } catch (e) {
          emit(currentState.copyWith(
              isSubmitting: false, submitErrorMessage: e.toString()));
        }
      }
    });
  }
}
