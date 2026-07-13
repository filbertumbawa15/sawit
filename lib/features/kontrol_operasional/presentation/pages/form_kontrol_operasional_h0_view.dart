import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sawit/features/kontrol_operasional/data/models/form_submit_h0_param.dart';
import 'package:sawit/features/kontrol_operasional/presentation/bloc/form_master/form_master_bloc.dart';

// PENTING: Sesuaikan path import ini dengan lokasi folder 'widgets' di project kamu
import '../widgets/custom_dropdown.dart';
import '../widgets/custom_checkbox_item.dart';

class FormPageH0 extends StatefulWidget {
  const FormPageH0({super.key});

  @override
  State<FormPageH0> createState() => _FormPageH0State();
}

class _FormPageH0State extends State<FormPageH0> {
  int? _selectedPerusahaanId;
  int? _selectedSeranganId;
  int? _selectedAfdelingId;
  int? _selectedBlokId;
  int? _selectedBSId;
  int? _selectedTSId;

  final TextEditingController _notesController = TextEditingController();

  final List<File> _selectedImages = [];
  final ImagePicker _picker = ImagePicker();

  final Map<int, bool> _checkedItems = {};

  @override
  void initState() {
    super.initState();
    context.read<FormMasterBloc>().add(FetchMasterData());
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      // Buka kamera/galeri dengan kompresi kualitas 70% agar file tidak terlalu besar
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 70,
        maxWidth: 1600,
        maxHeight: 1600,
      );

      if (pickedFile != null) {
        setState(() {
          _selectedImages.add(File(pickedFile.path));
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengambil gambar: $e')),
      );
    }
  }

  // --- FUNGSI INTERAKSI ---
  void _showAddPhotoPopup() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Tambah Foto',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Color(0xFF2CB887)),
                title: const Text('Kamera'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.image, color: Color(0xFF2CB887)),
                title: const Text('Galeri'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2CB887),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Input Operasional (H+0)',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontFamily: 'Nunito',
            fontSize: 16.0,
          ),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(24),
          ),
        ),
      ),
      body: BlocConsumer<FormMasterBloc, FormMasterState>(
        listener: (context, state) {
          if (state is FormMasterLoaded) {
            // Jika _checkedItems masih kosong, inisialisasi dengan nilai false
            if (_checkedItems.isEmpty) {
              for (var item in state.data.checkParameters) {
                if (item.isActive) {
                  _checkedItems[item.id] = false;
                }
              }
            }

            if (state.isSubmitSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Data berhasil disimpan!'),
                    backgroundColor: Colors.green),
              );
              Navigator.pop(context); // Tutup halaman
            }

            if (state.submitErrorMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(state.submitErrorMessage!),
                    backgroundColor: Colors.red),
              );
            }
          }
        },
        builder: (context, state) {
          if (state is FormMasterLoading) {
            return const Center(
                child: CircularProgressIndicator(color: Color(0xFF2CB887)));
          } else if (state is FormMasterError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 48),
                  const SizedBox(height: 16),
                  Text(state.message,
                      style: const TextStyle(color: Colors.red)),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () =>
                        context.read<FormMasterBloc>().add(FetchMasterData()),
                    child: const Text('Coba Lagi'),
                  )
                ],
              ),
            );
          } else if (state is FormMasterLoaded) {
            final listAlatKerja = state.data.checkParameters
                .where((item) => item.category == 'Alat Kerja')
                .toList();

            final listApd = state.data.checkParameters
                .where((item) => item.category == 'APD')
                .toList();

            // 2. Ekstrak data Dropdown (Ambil string 'name' nya saja untuk dropdown UI)
            final afdelingNames = state.data.afdelings;
            final filteredBloks = state.data.bloks
                .where((blok) => blok.afdelingId == _selectedAfdelingId)
                .toList();
            final filteredBS = state.data.barisSampels
                .where((bs) => bs.blokId == _selectedBlokId)
                .toList();
            final filteredTS = state.data.titikSampels
                .where((ts) => ts.barisSampelId == _selectedBSId)
                .toList();

            return SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 20),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            spreadRadius: 2),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomDropdown(
                          label: 'Pilih Perusahaan',
                          selectedValue: _selectedPerusahaanId,
                          items: state.data.perusahaans
                              .map((item) => DropdownMenuItem<int>(
                                    value: item.id,
                                    child: Text(item.name,
                                        style: const TextStyle(
                                            color: Color(0xFF333333),
                                            fontSize: 13)),
                                  ))
                              .toList(),
                          onChanged: (val) {
                            setState(() {
                              _selectedPerusahaanId = val;
                            });
                          },
                        ),
                        const SizedBox(height: 16),
                        CustomDropdown(
                          label: 'Pilih Afdeling',
                          items: afdelingNames
                              .map((item) => DropdownMenuItem<int>(
                                    value: item.id,
                                    child: Text(item.name,
                                        style: const TextStyle(
                                            color: Color(0xFF333333),
                                            fontSize: 13)),
                                  ))
                              .toList(),
                          selectedValue: _selectedAfdelingId,
                          onChanged: (val) {
                            setState(() {
                              _selectedAfdelingId = val;
                              // Kunci: Reset semua dropdown anak-anaknya ke null!
                              _selectedBlokId = null;
                              _selectedBSId = null;
                              _selectedTSId = null;
                            });
                          },
                        ),
                        const SizedBox(height: 16),
                        CustomDropdown(
                          label: 'Pilih Blok',
                          items: filteredBloks
                              .map((item) => DropdownMenuItem<int>(
                                    value: item.id,
                                    child: Text(item.name,
                                        style: const TextStyle(
                                            color: Color(0xFF333333),
                                            fontSize: 13)),
                                  ))
                              .toList(),
                          selectedValue: _selectedBlokId,
                          onChanged: _selectedAfdelingId == null
                              ? null
                              : (val) {
                                  setState(() {
                                    _selectedBlokId = val;
                                    _selectedBSId = null;
                                    _selectedTSId = null;
                                  });
                                },
                        ),
                        const SizedBox(height: 16),
                        CustomDropdown(
                          label: 'Pilih Baris Sampel (BS)',
                          items: filteredBS
                              .map((item) => DropdownMenuItem<int>(
                                    value: item.id,
                                    child: Text(item.name,
                                        style: const TextStyle(
                                            color: Color(0xFF333333),
                                            fontSize: 13)),
                                  ))
                              .toList(),
                          selectedValue: _selectedBSId,
                          onChanged: _selectedBlokId == null
                              ? null
                              : (val) {
                                  setState(() {
                                    _selectedBSId = val;
                                    _selectedTSId = null;
                                  });
                                },
                        ),
                        const SizedBox(height: 16),
                        CustomDropdown(
                          label: 'Pilih Titik Sampel (TS)',
                          items: filteredTS
                              .map((item) => DropdownMenuItem<int>(
                                    value: item.id,
                                    child: Text(item.name,
                                        style: const TextStyle(
                                            color: Color(0xFF333333),
                                            fontSize: 13)),
                                  ))
                              .toList(),
                          selectedValue: _selectedTSId,
                          onChanged: _selectedBSId == null
                              ? null
                              : (val) {
                                  setState(() {
                                    _selectedTSId = val;
                                  });
                                },
                        ),
                        const SizedBox(height: 16),
                        CustomDropdown(
                          label: 'Pilih Jenis Serangan',
                          selectedValue: _selectedSeranganId,
                          items: state.data.serangans
                              .map((item) => DropdownMenuItem<int>(
                                    value: item.id,
                                    child: Text(item.name,
                                        style: const TextStyle(
                                            color: Color(0xFF333333),
                                            fontSize: 13)),
                                  ))
                              .toList(),
                          onChanged: (val) {
                            setState(() {
                              _selectedSeranganId = val;
                            });
                          },
                        ),
                        const SizedBox(height: 16),
                        const Padding(
                          padding: EdgeInsets.only(bottom: 8.0, left: 4.0),
                          child: Text('Catatan Tambahan (Opsional)',
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500)),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border:
                                Border.all(color: Colors.grey.withOpacity(0.3)),
                          ),
                          child: TextField(
                            controller: _notesController,
                            maxLines:
                                4, // Membuatnya menjadi kotak besar (area teks)
                            style: const TextStyle(
                                fontSize: 13, color: Color(0xFF333333)),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Ketik catatan inspeksi di sini...',
                              hintStyle:
                                  TextStyle(color: Colors.grey, fontSize: 12),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        const Padding(
                          padding: EdgeInsets.only(bottom: 8.0, left: 4.0),
                          child: Text('Upload Foto',
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500)),
                        ),
                        SizedBox(
                          height: 100,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Wrap(
                              spacing: 12,
                              children: [
                                GestureDetector(
                                  onTap: _showAddPhotoPopup,
                                  child: Container(
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                          color: Colors.grey.withOpacity(0.5),
                                          width: 1.5),
                                    ),
                                    child: const Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.add_a_photo_outlined,
                                            color: Colors.grey, size: 28),
                                        SizedBox(height: 8),
                                        Text('Tambah Foto',
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 11)),
                                      ],
                                    ),
                                  ),
                                ),
                                ..._selectedImages.asMap().entries.map((entry) {
                                  int index = entry.key;
                                  File imageFile = entry.value;

                                  return Stack(
                                    children: [
                                      Container(
                                        width: 100,
                                        height: 100,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          border: Border.all(
                                              color:
                                                  Colors.grey.withOpacity(0.2)),
                                        ),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          child: Image.file(
                                            imageFile,
                                            fit: BoxFit.cover,
                                            cacheWidth: 200,
                                            cacheHeight: 200,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: 4,
                                        right: 4,
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              _selectedImages.removeAt(index);
                                            });
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.all(4),
                                            decoration: const BoxDecoration(
                                              color: Colors.redAccent,
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(
                                              Icons.close,
                                              color: Colors.white,
                                              size: 14,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                }),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Cek Kelengkapan Alat Kerja :',
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  const SizedBox(height: 12),
                                  ...listAlatKerja.map((item) {
                                    final id = item.id;
                                    return CustomCheckboxItem(
                                      label: item.parameterName,
                                      isChecked: _checkedItems[id] ?? false,
                                      onChanged: (value) => setState(() =>
                                          _checkedItems[id] = value ?? false),
                                    );
                                  }),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Cek Kelengkapan APD :',
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  const SizedBox(height: 12),
                                  ...listApd.map((item) {
                                    final id = item.id;
                                    return CustomCheckboxItem(
                                      label: item.parameterName,
                                      isChecked: _checkedItems[id] ?? false,
                                      onChanged: (value) => setState(() =>
                                          _checkedItems[id] = value ?? false),
                                    );
                                  }),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 48),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: state.isSubmitting
                                ? null
                                : () {
                                    if (_selectedPerusahaanId == null ||
                                        _selectedAfdelingId == null ||
                                        _selectedBlokId == null ||
                                        _selectedBSId == null ||
                                        _selectedTSId == null) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content: Text(
                                                  'Harap lengkapi lokasi!'),
                                              backgroundColor: Colors.red));
                                      return;
                                    }

                                    Map<int, bool> apdMap = {};
                                    Map<int, bool> alatKerjaMap = {};

                                    for (var item
                                        in state.data.checkParameters) {
                                      if (item.category == 'APD') {
                                        apdMap[item.id] =
                                            _checkedItems[item.id] ?? false;
                                      }
                                      if (item.category == 'Alat Kerja') {
                                        alatKerjaMap[item.id] =
                                            _checkedItems[item.id] ?? false;
                                      }
                                    }

                                    final param = SubmitFormH0Param(
                                      perusahaanId: _selectedPerusahaanId!,
                                      afdelingId: _selectedAfdelingId!,
                                      blokId: _selectedBlokId!,
                                      bsId: _selectedBSId!,
                                      tsId: _selectedTSId!,
                                      seranganId: _selectedSeranganId,
                                      notes: _notesController.text,
                                      apdItems: apdMap,
                                      alatKerjaItems: alatKerjaMap,
                                      images: _selectedImages,
                                    );

                                    context
                                        .read<FormMasterBloc>()
                                        .add(SubmitFormH0Event(param));
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2CB887),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                            child: const Text('Simpan',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
