import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:selaga_ver1/pages/user/booking_page/component/dropdown_lapangan.dart';
// import 'package:selaga_ver1/pages/user/booking_page/component/my_calendar.dart';
import 'package:selaga_ver1/pages/user/booking_page/component/venue_lapangan.dart';
import 'package:selaga_ver1/repositories/api_repository.dart';
import 'package:selaga_ver1/repositories/models/lapangan_model.dart';
import 'package:selaga_ver1/repositories/models/user_profile_model.dart';
import 'package:selaga_ver1/repositories/models/venue_model.dart';
import 'package:selaga_ver1/repositories/providers.dart';

class BookingPage extends StatelessWidget {
  final VenueModel venue;
  const BookingPage({super.key, required this.venue});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Pilih Lapangan'),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Consumer<Token>(
            builder: (context, myToken, child) {
              return FutureBuilder(
                future: Future.wait([
                  ApiRepository().getMyLapangan(myToken.token, venue.id!),
                  ApiRepository().getJadwalLapangan(myToken.token),
                  ApiRepository().getMyProfile(myToken.token),
                ]),
                builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
                  if (snapshot.hasData &&
                      snapshot.connectionState == ConnectionState.done) {
                    List<Lapangan> myLapangan = snapshot.data?[0].result ?? [];
                    List<JadwalLapanganModel> jadwal =
                        snapshot.data?[1].result ?? [];
                    UserProfileModel profile = snapshot.data?[2].result;
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      context
                          .read<OrderName>()
                          .update(profile.name ?? 'no name');
                    });
                    if (myLapangan.isEmpty) {
                      return const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline_outlined,
                              color: Colors.red,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              'Tidak ada lapangan yang tersedia',
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return VenueLapangan(
                          myLapangan: myLapangan, venue: venue, jadwal: jadwal);
                    }
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
              );
            },
          ),
        ));
  }
}
