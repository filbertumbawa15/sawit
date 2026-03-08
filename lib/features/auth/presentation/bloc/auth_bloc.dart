import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sawit/features/auth/data/datasources/auth_data_source.dart';
import 'package:sawit/features/auth/data/models/auth_response_model.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthDataSource dataSource;

  AuthBloc({required this.dataSource}) : super(AuthInitial()) {
    on<LoginRequested>((event, emit) async {
      emit(AuthLoading());

      try {
        final result = await dataSource.login(event.email, event.password, event.deviceName);
        emit(AuthSuccess(result));
      } catch (e) {
        emit(AuthError(e.toString().replaceAll('Exception: ', '')));
      }
    });
  }
}
