import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:selaga_ver1/pages/mitra/lapangan_page/component/have_lapangan.dart';
import 'package:selaga_ver1/pages/mitra/lapangan_page/component/no_lapangan.dart';
import 'package:selaga_ver1/repositories/api_repository.dart';
import 'package:selaga_ver1/repositories/models/venue_model.dart';
import 'package:selaga_ver1/repositories/providers.dart';

class MyLapanganPage extends StatelessWidget {
  final VenueModel venue;
  const MyLapanganPage({super.key, required this.venue});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lapangan Anda'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Consumer<Token>(
          builder: (context, myToken, child) => FutureBuilder(
            future: ApiRepository().getMyLapangan(myToken.token, venue.id!),
            builder: (context, snapshot) {
              if (snapshot.hasData &&
                  snapshot.connectionState == ConnectionState.done) {
                List<Lapangan> myLapangan = snapshot.data?.result ?? [];
                return myLapangan.isNotEmpty
                    ? HaveLapangan(
                        myLapangan: myLapangan,
                        venue: venue,
                      )
                    : NoLapangan(myLapangan: myLapangan, venue: venue);
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
        ),
      ),
    );
  }
}
