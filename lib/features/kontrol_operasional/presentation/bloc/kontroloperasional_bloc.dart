import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sawit/features/kontrol_operasional/data/datasources/kontrol_operasional_data_source.dart';

part 'kontroloperasional_event.dart';
part 'kontroloperasional_state.dart';

class KontrolOperasionalBloc
    extends Bloc<KontrolOperasionalEvent, KontrolOperasionalState> {
  final KontrolOperasionalDataSource dataSource;

  KontrolOperasionalBloc({required this.dataSource})
      : super(KontrolOperasionalInitial()) {
    // Mendaftarkan event FetchListKontrol
    on<FetchListKontrol>((event, emit) async {
      emit(
          KontrolOperasionalLoading()); // Ubah state jadi loading (menampilkan spinner di UI)

      try {
        // Panggil fungsi API dari DataSource
        final data = await dataSource.fetchListKontrol(page: event.page);

        // Jika sukses, ubah state jadi Loaded dan bawa datanya
        emit(KontrolOperasionalLoaded(data));
      } catch (e) {
        // Jika gagal, potong teks 'Exception: ' agar pesan error lebih rapi di UI
        final errorMessage = e.toString().replaceAll('Exception: ', '');
        emit(KontrolOperasionalError(errorMessage));
      }
    });
  }
}
