import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:selaga_ver1/repositories/api_repository.dart';
import 'package:selaga_ver1/repositories/models/lapangan_model.dart';
import 'package:selaga_ver1/repositories/models/venue_model.dart';
import 'package:selaga_ver1/repositories/providers.dart';

class ConfirmPayment extends StatefulWidget {
  const ConfirmPayment(
      {super.key,
      required this.myJadwal,
      required this.lapangan,
      required this.venue});
  final List<JadwalLapanganModel> myJadwal;
  final Lapangan lapangan;
  final VenueModel venue;
  @override
  State<ConfirmPayment> createState() => _ConfirmPaymentState();
}

class _ConfirmPaymentState extends State<ConfirmPayment> {
  var _isSending = false;
  final ImagePicker imagePicker = ImagePicker();
  XFile? _image;

  void _selectImages() async {
    final XFile? selectedImages = await imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 50, // <- Reduce Image quality
        maxHeight: 500, // <- reduce the image size
        maxWidth: 500);

    setState(() {
      if (selectedImages != null) {
        _image = XFile(selectedImages.path);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pembayaran'),
        centerTitle: true,
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Masukan bukti pembayaraan disini',
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  InkWell(
                    onTap: () {
                      _selectImages();
                    },
                    child: Container(
                        height: 150,
                        width: 150,
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
                  const Text(
                    '*Foto harus kurang dari 2MB',
                    style:
                        TextStyle(color: Color.fromRGBO(76, 76, 220, 1)),
                  ),
                ],
              ),
            ),
            SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 60,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: _image != null
                            ? const Color.fromRGBO(76, 76, 220, 1)
                            : Colors.grey,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12))),
                    onPressed: _isSending
                        ? null
                        : () async {
                            if (_image == null) {
                              return;
                            } else {
                              setState(() {
                                _isSending = true;
                              });

                              final myImg = File(_image!.path);
                              final myToken =
                                  Provider.of<Token>(context, listen: false)
                                      .token;
                              final hour = Provider.of<SelectedHour>(context,
                                      listen: false)
                                  .selectedHour
                                  .join();
                              final name =
                                  Provider.of<OrderName>(context, listen: false)
                                      .getOrdername;
                              final jadwal = widget.myJadwal.firstWhere((e) =>
                                  e.days ==
                                  DateTime(
                                      DateTime.now().year,
                                      DateTime.now().month,
                                      DateTime.now().day +
                                          Provider.of<SelectedDate>(context,
                                                  listen: false)
                                              .selectedIndex));
                              final payment = Provider.of<PaymentMethod>(
                                      context,
                                      listen: false)
                                  .getPayment;

                              var data = await ApiRepository().postBooking(
                                  token: myToken,
                                  jadwal: jadwal,
                                  img: myImg,
                                  name: name,
                                  hour: hour,
                                  payment: payment);

                              if (data.result != null) {
                                if (!context.mounted) {
                                  return;
                                }

                                context
                                    .goNamed('user_booking_lapangan_success');
                                setState(() {
                                  _isSending = false;
                                });
                              } else {
                                setState(() {
                                  _isSending = false;
                                });
                                if (!context.mounted) {
                                  return;
                                }
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('${data.error}'),
                                    duration:
                                        const Duration(milliseconds: 1200),
                                  ),
                                );
                              }
                            }
                          },
                    child: _isSending
                        ? const SizedBox(
                            height: 25,
                            width: 25,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'Lanjutkan',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ))),
          ],
        ),
      )),
    );
  }
}
