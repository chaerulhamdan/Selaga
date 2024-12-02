import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:selaga_ver1/repositories/api_repository.dart';
import 'package:selaga_ver1/repositories/models/booking_model.dart';
import 'package:selaga_ver1/repositories/models/lapangan_model.dart';
import 'package:selaga_ver1/repositories/models/user_profile_model.dart';
import 'package:selaga_ver1/repositories/models/venue_model.dart';
import 'package:selaga_ver1/repositories/providers.dart';

class ConfirmationPage extends StatefulWidget {
  const ConfirmationPage({super.key});

  @override
  State<ConfirmationPage> createState() => _ConfirmationPageState();
}

class _ConfirmationPageState extends State<ConfirmationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Konfirmasi Pesanan'),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                setState(() {});
              },
              icon: const Icon(Icons.refresh))
        ],
      ),
      body: SafeArea(
          child: Consumer<Token>(
        builder: (context, myToken, child) => FutureBuilder(
          future: Future.wait([
            ApiRepository().getMyProfile(myToken.token),
            ApiRepository().getAllVenue(myToken.token),
            ApiRepository().getJadwalLapangan(myToken.token),
            ApiRepository().getBooking(myToken.token)
          ]),
          builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
            if (snapshot.hasData &&
                snapshot.connectionState == ConnectionState.done) {
              UserProfileModel myId = snapshot.data?[0].result ?? [];
              List<VenueModel> venue = snapshot.data?[1].result ?? [];
              List<VenueModel> myVenue =
                  venue.where((e) => int.parse(e.mitraId) == myId.id).toList();

              List<JadwalLapanganModel> jadwal = snapshot.data?[2].result ?? [];
              List<JadwalLapanganModel> myJadwal = jadwal
                  .where((e) => myVenue.any((v) =>
                      e.lapangan != null &&
                      v.id == int.parse(e.lapangan?.venueId)))
                  .toList();

              List<BookingModel> booking = snapshot.data?[3].result ?? [];
              List<BookingModel> myBooking = booking
                  .where((e) => myJadwal.any((j) => j.id == e.timetable.id))
                  .toList();

              if (myBooking.isNotEmpty) {
                return Padding(
                  padding: const EdgeInsets.all(8),
                  child: ListView.builder(
                    itemCount: myBooking.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: () {
                            Provider.of<BookingId>(context, listen: false)
                                .updateBookingId(myBooking[index].id);
                            context.goNamed('mitra_detail_konfirmasi');
                          },
                          child: Container(
                            // height: 125,
                            height: 180,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 7,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ListTile(
                                        title: const Text('Nama Pemesan'),
                                        titleTextStyle: const TextStyle(
                                            color: Colors.black, fontSize: 14),
                                        subtitle:
                                            Text(myBooking[index].order.name),
                                        subtitleTextStyle: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      ListTile(
                                          leading: const Icon(
                                            Icons.calendar_month,
                                            color:
                                                Color.fromRGBO(76, 76, 220, 1),
                                          ),
                                          title: Text(DateFormat('dd MMMM yyyy')
                                              .format(myBooking[index].date)),
                                          subtitle: Text(
                                              '${myBooking[index].hours}.00 - ${1 + int.parse(myBooking[index].hours)}.00')),
                                    ],
                                  ),
                                ),
                                myBooking[index].confirmation == 'PENDING'
                                    ? const Icon(
                                        Icons.arrow_forward_ios_rounded)
                                    : myBooking[index].confirmation == 'CANCEL'
                                        ? const Text(
                                            'Ditolak',
                                            softWrap: true,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                color: Colors.red,
                                                fontWeight: FontWeight.bold),
                                          )
                                        : const Text(
                                            'Diterima',
                                            softWrap: true,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                color: Color.fromRGBO(
                                                    76, 76, 220, 1),
                                                fontWeight: FontWeight.bold),
                                          )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              } else {
                return const Center(
                  child: Text('Belum ada pesanan'),
                );
              }
            } else if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
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
                ),
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
