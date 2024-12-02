import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:selaga_ver1/pages/components/my_button.dart';
import 'package:selaga_ver1/repositories/models/arguments.dart';
import 'package:selaga_ver1/repositories/models/venue_model.dart';

class SuccessEditLapanganPage extends StatelessWidget {
  final VenueModel venue;
  const SuccessEditLapanganPage({super.key, required this.venue});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      border: Border.all(width: 1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      size: 120,
                      color: Color.fromRGBO(76, 76, 220, 1),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    'Jadwal Lapangan Berhasil di ubah!',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  )
                ],
              )),
          MyButton(
              onTap: () {
                ArgumentsMitra args = ArgumentsMitra(
                    venueId: venue.id,
                    venue: venue,
                    lapangan: Lapangan(
                      venueId: venue.id,
                      nameLapangan: 'no name',
                      // createdAt: DateTime.now(),
                      days: DateTime.now(),
                      hour: '0',
                      id: 0,
                      // updatedAt: DateTime.now(),
                      // deletedAt: null
                    ),
                    selectedDateIndex: 0,
                    listLapangan: [],
                    listJadwal: []);
                args.toJson();
                context.goNamed('mitra_lapangan_page', extra: args);
              },
              buttonText: 'Kembali ke Lapangan')
        ],
      ),
    )));
  }
}
