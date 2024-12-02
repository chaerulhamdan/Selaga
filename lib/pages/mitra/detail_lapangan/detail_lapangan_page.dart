import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:selaga_ver1/pages/mitra/detail_lapangan/component/my_jadwal.dart';
import 'package:selaga_ver1/repositories/api_repository.dart';
import 'package:selaga_ver1/repositories/models/lapangan_model.dart';
import 'package:selaga_ver1/repositories/models/venue_model.dart';
import 'package:selaga_ver1/repositories/providers.dart';

class DetailLapanganPage extends StatelessWidget {
  final Lapangan lapangan;
  final VenueModel venue;
  final int selectedDateIndex;
  const DetailLapanganPage(
      {super.key,
      required this.lapangan,
      required this.venue,
      required this.selectedDateIndex});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Jadwal ${lapangan.nameLapangan}'),
        centerTitle: true,
      ),
      body: SafeArea(
          child: Consumer<Token>(
        builder: (context, value, child) => FutureBuilder(
          future: ApiRepository().getJadwalLapangan(value.token),
          builder: (context, snapshot) {
            if (snapshot.hasData &&
                snapshot.connectionState == ConnectionState.done) {
              List<JadwalLapanganModel> jadwal = snapshot.data?.result ?? [];
              List<JadwalLapanganModel> myJadwal = jadwal
                  .where((e) => int.parse(e.lapanganId) == lapangan.id)
                  .toList();
              return MyJadwal(
                myJadwal: myJadwal,
                lapangan: lapangan,
                venue: venue,
                selectedDateIndex: selectedDateIndex,
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
          },
        ),
      )),
    );
  }
}
