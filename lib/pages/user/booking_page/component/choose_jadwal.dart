import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:selaga_ver1/pages/components/format.dart';
import 'package:selaga_ver1/pages/user/booking_page/component/hour_section.dart';
import 'package:selaga_ver1/pages/user/booking_page/component/my_calendar.dart';
import 'package:selaga_ver1/repositories/models/arguments.dart';
import 'package:selaga_ver1/repositories/models/lapangan_model.dart';
import 'package:selaga_ver1/repositories/models/venue_model.dart';
import 'package:selaga_ver1/repositories/providers.dart';

class ChooseJadwalPage extends StatefulWidget {
  const ChooseJadwalPage(
      {super.key,
      required this.myJadwal,
      required this.lapangan,
      required this.venue});
  final List<JadwalLapanganModel> myJadwal;
  final Lapangan lapangan;
  final VenueModel venue;

  @override
  State<ChooseJadwalPage> createState() => _ChooseJadwalPageState();
}

class _ChooseJadwalPageState extends State<ChooseJadwalPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pilih Jadwal'),
        centerTitle: true,
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                children: [
                  BookingCalendar(
                    myJadwal: widget.myJadwal,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Harga',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Row(
                          children: [
                            Text(
                              CurrencyFormat.convertToIdr(
                                  double.parse(widget.venue.price!)),
                              style: const TextStyle(
                                  color: Color.fromRGBO(76, 76, 220, 1),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                            const Text(' /jam')
                          ],
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      children: [
                        Container(
                          height: 15,
                          width: 15,
                          color: Colors.red,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Text('Jadwal tidak tersedia')
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  HourSection(
                      myJadwal: widget.myJadwal,
                      lapangan: widget.lapangan,
                      venue: widget.venue)
                ],
              ),
            ),
            widget.myJadwal.any((e) =>
                    e.days ==
                    DateTime(
                        DateTime.now().year,
                        DateTime.now().month,
                        DateTime.now().day +
                            Provider.of<SelectedDate>(context, listen: true)
                                .selectedIndex))
                ? SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 60,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromRGBO(76, 76, 220, 1),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12))),
                        onPressed: () {
                          List<String> selectedHour =
                              Provider.of<SelectedHour>(context, listen: false)
                                  .selectedHour;

                          if (selectedHour.isEmpty) {
                            return;
                          } else {
                            final List<JadwalLapanganModel> selectedJadwal =
                                widget.myJadwal
                                    .where((e) =>
                                        e.days ==
                                        DateTime(
                                            DateTime.now().year,
                                            DateTime.now().month,
                                            DateTime.now().day +
                                                Provider.of<SelectedDate>(
                                                        context,
                                                        listen: false)
                                                    .selectedIndex))
                                    .toList();

                            ArgumentsUser args = ArgumentsUser(
                                venue: widget.venue,
                                lapangan: widget.lapangan,
                                listJadwal: selectedJadwal);

                            args.toJson();

                            context.goNamed('user_lapangan_confirmation',
                                extra: args);
                          }
                        },
                        child: const Text(
                          'Pesan Sekarang',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        )))
                : Container()
          ],
        ),
      )),
    );
  }
}
