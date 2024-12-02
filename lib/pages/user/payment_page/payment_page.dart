import 'package:flutter/material.dart';
import 'package:selaga_ver1/pages/components/my_box_button.dart';
import 'package:selaga_ver1/pages/user/payment_page/components/bca_section.dart';
import 'package:selaga_ver1/pages/user/payment_page/components/jago_section.dart';
import 'package:selaga_ver1/pages/user/payment_page/components/ovo_section.dart';
import 'package:selaga_ver1/repositories/models/lapangan_model.dart';
import 'package:selaga_ver1/repositories/models/venue_model.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage(
      {super.key,
      required this.myJadwal,
      required this.lapangan,
      required this.venue});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
  final List<JadwalLapanganModel> myJadwal;
  final Lapangan lapangan;
  final VenueModel venue;
}

class _PaymentPageState extends State<PaymentPage> {
  bool box1 = true;
  bool box2 = false;
  bool box3 = false;
  int _currentIndexPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text('Pembayaran'),
            centerTitle: true,
            bottom: Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  MyBoxButton(
                      onTap: () {
                        setState(() {
                          box1 = true;
                          box2 = false;
                          box3 = false;
                          _currentIndexPage = 0;
                        });
                      },
                      buttonText: 'BCA',
                      tapped: box1),
                  MyBoxButton(
                      onTap: () {
                        setState(() {
                          box1 = false;
                          box2 = true;
                          box3 = false;
                          _currentIndexPage = 1;
                        });
                      },
                      buttonText: 'OVO',
                      tapped: box2),
                  MyBoxButton(
                      onTap: () {
                        setState(() {
                          box1 = false;
                          box2 = false;
                          box3 = true;
                          _currentIndexPage = 2;
                        });
                      },
                      buttonText: 'Jago',
                      tapped: box3),
                ],
              ),
            )),
        body: [
          BcaSection(
              myJadwal: widget.myJadwal,
              lapangan: widget.lapangan,
              venue: widget.venue),
          OvoSection(
              myJadwal: widget.myJadwal,
              lapangan: widget.lapangan,
              venue: widget.venue),
          JagoSection(
              myJadwal: widget.myJadwal,
              lapangan: widget.lapangan,
              venue: widget.venue),
        ][_currentIndexPage]);
  }
}
