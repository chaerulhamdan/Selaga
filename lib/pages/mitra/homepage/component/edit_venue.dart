import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:selaga_ver1/pages/components/my_checkbox.dart';
import 'package:selaga_ver1/pages/mitra/daftar_venue/component/my_upload_button.dart';
import 'package:selaga_ver1/repositories/api_repository.dart';
import 'package:selaga_ver1/repositories/models/endpoints.dart';
import 'package:selaga_ver1/repositories/models/venue_model.dart';
import 'package:selaga_ver1/repositories/providers.dart';

class EditVenueHandler extends StatelessWidget {
  const EditVenueHandler({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Edit Venue'),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Consumer2<Token, UserId>(
              builder: (context, myToken, venueId, child) => FutureBuilder(
                  future:
                      ApiRepository().getVenueDetail(myToken.token, venueId.id),
                  builder: (context, snapshot) {
                    if (snapshot.hasData &&
                        snapshot.connectionState == ConnectionState.done) {
                      return EditVenuePage(
                        venue: snapshot.data!.result!,
                      );
                    } else if (snapshot.hasError) {
                      return Column(
                        children: [
                          const Icon(
                            Icons.error_outline,
                            color: Colors.red,
                            size: 60,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 16),
                            child: Text('Error: ${snapshot.error}'),
                          ),
                        ],
                      );
                    } else {
                      return const Center(
                        child: SizedBox(
                          width: 60,
                          height: 60,
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                  })),
        ));
  }
}

class EditVenuePage extends StatefulWidget {
  const EditVenuePage({super.key, required this.venue});
  final VenueModel venue;
  @override
  State<EditVenuePage> createState() => _EditVenuePageState();
}

class _EditVenuePageState extends State<EditVenuePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final ImagePicker imagePicker = ImagePicker();

  @override
  void initState() {
    _nameController.text = widget.venue.nameVenue!;
    _descController.text = widget.venue.descVenue!;
    _alamatController.text = widget.venue.lokasiVenue!;
    _priceController.text = widget.venue.price!;

    List<String> temp = widget.venue.fasilitasVenue!.split(',');
    for (var e in temp) {
      _handleFasilitas(e);
    }

    _img = widget.venue.image!.split(',').first;

    super.initState();
  }

  void _handleFasilitas(String fasilitas) {
    switch (fasilitas) {
      case 'Free Wifi':
        _fasilitas.add(fasilitas);
        _boxChecked = true;
        break;
      case 'Warung/Cafe':
        _fasilitas.add(fasilitas);
        _boxChecked2 = true;
        break;
      case 'Parkir Motor':
        _fasilitas.add(fasilitas);
        _boxChecked3 = true;
        break;
      case 'Parkir Mobil':
        _fasilitas.add(fasilitas);
        _boxChecked4 = true;
        break;
      default:
        return;
    }
  }

  String _img = '';

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

    if (_formKey.currentState!.validate()) {
      showAlertDialogUnavailabe(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Foto lapangan (utama)',
                  style: TextStyle(fontSize: 16)),
              const SizedBox(
                height: 10,
              ),
              Container(
                  height: 170,
                  width: 170,
                  decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      '${Endpoints().image}$_img',
                      fit: BoxFit.fill,
                    ),
                  )),
              const SizedBox(
                height: 10,
              ),
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
              const SizedBox(
                height: 20,
              ),
              MyUploadVenueButton(
                isSending: _isSending,
                onTap: _uploadVenue,
                hint: 'Edit Venue',
              ),
            ],
          ),
        ),
      ),
    );
  }

  showAlertDialogUnavailabe(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: const Text("Batal"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: const Text("Ya"),
      onPressed: () async {
        final mytoken = Provider.of<Token>(context, listen: false).token;

        final tempFasilitas = _fasilitas.join(',');

        final VenueModel venue = VenueModel(
          id: widget.venue.id,
          nameVenue: _nameController.text.trim(),
          lokasiVenue: _alamatController.text.trim(),
          descVenue: _descController.text.trim(),
          price: _priceController.text.trim(),
          fasilitasVenue: tempFasilitas,
        );

        var data = await ApiRepository().editVenue(mytoken, venue);
        if (!context.mounted) {
          return;
        }
        if (data.result != null) {
          context.goNamed('mitra_edit_venue_success');
        } else {
          setState(() {
            _isSending = false;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${data.error}'),
              duration: const Duration(milliseconds: 1100),
            ),
          );
        }
      },
    );

    AlertDialog alert = AlertDialog(
      title: const Text("Peringatan !"),
      content: const Text("Apakah anda ingin merubah detail venue ini?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
