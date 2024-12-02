import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:selaga_ver1/pages/components/my_checkbox.dart';
import 'package:selaga_ver1/pages/mitra/daftar_venue/component/multiple_image.dart';
import 'package:selaga_ver1/pages/mitra/daftar_venue/component/my_upload_button.dart';
import 'package:selaga_ver1/repositories/api_repository.dart';
import 'package:selaga_ver1/repositories/models/venue_model.dart';
import 'package:selaga_ver1/repositories/providers.dart';

class DaftarVenuePage extends StatefulWidget {
  const DaftarVenuePage({super.key});

  @override
  State<DaftarVenuePage> createState() => _DaftarVenuePageState();
}

class _DaftarVenuePageState extends State<DaftarVenuePage> {
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  final _alamatController = TextEditingController();
  final _priceController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final ImagePicker imagePicker = ImagePicker();

  List<XFile>? _imageFileList = [];
  XFile? _image;
  List<File> _uploadImg = [];

  var _isSending = false;

  var _boxChecked = false;
  var _boxChecked2 = false;
  var _boxChecked3 = false;
  var _boxChecked4 = false;
  List<String> _fasilitas = [];

  void _uploadVenue() async {
    if (_fasilitas.isEmpty) {
      if (!context.mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Masukan Fasilitas yang tersedia'),
          duration: Duration(milliseconds: 1200),
        ),
      );
    }
    if (_image == null) {
      if (!context.mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Masukan Foto Lapangan Utama'),
          duration: Duration(milliseconds: 1200),
        ),
      );
    }
    if (_imageFileList!.isEmpty) {
      if (!context.mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Masukan Foto lainnya'),
          duration: Duration(milliseconds: 1200),
        ),
      );
    }

    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSending = true;
      });

      _uploadImg.add(File(_image!.path));
      for (XFile image in _imageFileList!) {
        _uploadImg.add(File(image.path));
      }

      final mytoken = Provider.of<Token>(context, listen: false).token;

      final RegisterVenue venue = RegisterVenue(
          nameVenue: _nameController.text.trim(),
          lokasiVenue: _alamatController.text.trim(),
          descVenue: _descController.text.trim(),
          price: _priceController.text.trim(),
          fasilitas: _fasilitas,
          img: _uploadImg);

      var data = await ApiRepository().daftarVenue(mytoken, venue);
      if (data.result != null) {
        if (!mounted) {
          return;
        }
        context.goNamed('mitra_daftar_venue_success');
      } else {
        setState(() {
          _isSending = false;
        });
        if (!mounted) {
          return;
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${data.error}'),
            duration: const Duration(milliseconds: 1100),
          ),
        );
      }
    }
  }

  void _selectImages() async {
    final XFile? selectedImages = await imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 50,
        maxHeight: 500,
        maxWidth: 500);

    setState(() {
      if (selectedImages != null) {
        _image = XFile(selectedImages.path);
      }
    });
  }

  void _selectMultiImages() async {
    final List<XFile> selectedImages = await imagePicker.pickMultiImage(
        imageQuality: 50, maxHeight: 500, maxWidth: 500);
    if (selectedImages.isNotEmpty) {
      _imageFileList!.addAll(selectedImages);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Venue'),
        centerTitle: true,
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Nama Venue',
                  ),
                  controller: _nameController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Mohon isi kolom Nama Venue";
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Deskripsi Venue',
                  ),
                  controller: _descController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Mohon isi kolom Deskripsi Venue";
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Alamat Venue',
                  ),
                  controller: _alamatController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Mohon isi kolom Alamat Venue";
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Harga',
                  ),
                  keyboardType: TextInputType.number,
                  controller: _priceController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Mohon isi kolom Harga";
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                const SizedBox(
                  height: 15,
                ),
                const Text('Fasilitas:', style: TextStyle(fontSize: 16)),
                Column(
                  children: [
                    Row(
                      children: [
                        MyCheckBox(
                          hintText: 'Free Wifi',
                          velue: _boxChecked,
                          onChanged: (value) {
                            setState(() {
                              _boxChecked = value!;
                              if (_boxChecked == true) {
                                _fasilitas.add('Free Wifi');
                              } else {
                                _fasilitas.remove('Free Wifi');
                              }
                            });
                          },
                        ),
                        MyCheckBox(
                          hintText: 'Warung/Cafe',
                          velue: _boxChecked2,
                          onChanged: (value) {
                            setState(() {
                              _boxChecked2 = value!;
                              if (_boxChecked2 == true) {
                                _fasilitas.add('Warung/Cafe');
                              } else {
                                _fasilitas.remove('Warung/Cafe');
                              }
                            });
                          },
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        MyCheckBox(
                          hintText: 'Parkir Motor',
                          velue: _boxChecked3,
                          onChanged: (value) {
                            setState(() {
                              _boxChecked3 = value!;
                              if (_boxChecked3 == true) {
                                _fasilitas.add('Parkir Motor');
                              } else {
                                _fasilitas.remove('Parkir Motor');
                              }
                            });
                          },
                        ),
                        MyCheckBox(
                          hintText: 'Parkir Mobil',
                          velue: _boxChecked4,
                          onChanged: (value) {
                            setState(() {
                              _boxChecked4 = value!;
                              if (_boxChecked4 == true) {
                                _fasilitas.add('Parkir Mobil');
                              } else {
                                _fasilitas.remove('Parkir Mobil');
                              }
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text('Foto lapangan (utama)',
                    style: TextStyle(fontSize: 16)),
                const SizedBox(
                  height: 10,
                ),
                InkWell(
                  onTap: () {
                    _selectImages();
                  },
                  child: Container(
                      height: 170,
                      width: 170,
                      decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10)),
                      child: _image != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.file(
                                File(_image!.path),
                                fit: BoxFit.cover,
                              ),
                            )
                          : const Center(
                              child: Icon(
                                Icons.file_upload_outlined,
                                size: 30,
                              ),
                            )),
                ),
                const SizedBox(
                  height: 15,
                ),
                const Text('Foto lainnya', style: TextStyle(fontSize: 16)),
                const SizedBox(
                  height: 10,
                ),
                SelectMultipleImages(
                  imageFileList: _imageFileList,
                  onTap: _selectMultiImages,
                ),
                const SizedBox(
                  height: 20,
                ),
                MyUploadVenueButton(
                  isSending: _isSending,
                  onTap: _uploadVenue,
                  hint: 'Daftar',
                ),
              ],
            ),
          ),
        ),
      )),
    );
  }
}
