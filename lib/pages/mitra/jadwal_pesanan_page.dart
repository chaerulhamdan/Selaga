import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:selaga_ver1/pages/user/jadwal_page/components/my_calendar_booked.dart';
import 'package:selaga_ver1/repositories/api_repository.dart';
import 'package:selaga_ver1/repositories/models/booking_model.dart';
import 'package:selaga_ver1/repositories/models/lapangan_model.dart';
import 'package:selaga_ver1/repositories/models/user_profile_model.dart';
import 'package:selaga_ver1/repositories/models/venue_model.dart';
import 'package:selaga_ver1/repositories/providers.dart';

class PesananPage extends StatefulWidget {
  const PesananPage({super.key});

  @override
  State<PesananPage> createState() => _PesananPageState();
}

class _PesananPageState extends State<PesananPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pesanan Anda'),
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
          child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const MyJadwalCalendar(),
            const SizedBox(
              height: 15,
            ),
            Expanded(
              child: Consumer<Token>(
                builder: (context, mytoken, child) => FutureBuilder(
                  future: Future.wait([
                    ApiRepository().getMyProfile(mytoken.token),
                    ApiRepository().getAllVenue(mytoken.token),
                    ApiRepository().getJadwalLapangan(mytoken.token),
                    ApiRepository().getBooking(mytoken.token)
                  ]),
                  builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
                    if (snapshot.hasData &&
                        snapshot.connectionState == ConnectionState.done) {
                      var date = DateTime(
                          DateTime.now().year,
                          DateTime.now().month,
                          DateTime.now().day +
                              Provider.of<SelectedDate>(context, listen: false)
                                  .selectedIndex);

                      UserProfileModel profile = snapshot.data?[0].result;
                      List<VenueModel> venue = snapshot.data?[1].result ?? [];

                      List<VenueModel> myVenue = [];
                      // if (venue.isNotEmpty) {
                      //   myVenue = venue
                      //       .where((e) => e.mitraId == profile.id)
                      //       .toList();
                      // }
                      if (venue.isNotEmpty) {
                        myVenue = venue
                            .where((e) => int.parse(e.mitraId) == profile.id)
                            .toList();
                      }

                      List<JadwalLapanganModel> jadwal =
                          snapshot.data?[2].result ?? [];
                      List<JadwalLapanganModel> myJadwal = [];

                      if (jadwal.isNotEmpty) {
                        myJadwal = jadwal
                            .where((e) =>
                                e.lapangan != null &&
                                myVenue.any((v) =>
                                    v.id == int.parse(e.lapangan?.venueId)))
                            .toList();
                      }

                      List<BookingModel> booking =
                          snapshot.data?[3].result ?? [];

                      List<BookingModel> myBooking = [];

                      if (booking.isNotEmpty) {
                        myBooking = booking
                            .where((e) =>
                                myJadwal.any((j) => j.id == e.timetable.id))
                            .toList();
                      }

                      List<BookingModel> myJadwalBooking = [];
                      if (myBooking.isNotEmpty) {
                        myJadwalBooking = myBooking
                            .where((e) => e.date.isAtSameMomentAs(date))
                            .toList();
                      }
                      context.watch<SelectedDate>().selectedIndex;
                      return Column(
                        children: [
                          myJadwalBooking.any((e) =>
                                  e.date ==
                                  DateTime(
                                      DateTime.now().year,
                                      DateTime.now().month,
                                      DateTime.now().day +
                                          Provider.of<SelectedDate>(context,
                                                  listen: true)
                                              .selectedIndex))
                              ? Expanded(
                                  child: ListView.builder(
                                    itemCount: myJadwalBooking.length,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: InkWell(
                                          onTap: () {
                                            Provider.of<BookingId>(context,
                                                    listen: false)
                                                .updateBookingId(
                                                    myJadwalBooking[index].id);
                                            context.goNamed(
                                                'mitra_detail_konfirmasi');
                                          },
                                          child: Container(
                                            height: 180,
                                            padding: const EdgeInsets.all(16),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                              color: Colors.white,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.5),
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
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      ListTile(
                                                        title: const Text(
                                                            'Nama Pemesan'),
                                                        titleTextStyle:
                                                            const TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 14),
                                                        subtitle: Text(
                                                            myJadwalBooking[
                                                                    index]
                                                                .order
                                                                .name),
                                                        subtitleTextStyle:
                                                            const TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 16.0,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      ListTile(
                                                          leading: const Icon(
                                                            Icons
                                                                .calendar_month,
                                                            color:
                                                                Color.fromRGBO(
                                                                    76,
                                                                    76,
                                                                    220,
                                                                    1),
                                                          ),
                                                          title: Text(DateFormat(
                                                                  'dd MMMM yyyy')
                                                              .format(
                                                                  myJadwalBooking[
                                                                          index]
                                                                      .date)),
                                                          subtitle: Text(
                                                              '${myJadwalBooking[index].hours}.00 - ${1 + int.parse(myBooking[index].hours)}.00')),
                                                    ],
                                                  ),
                                                ),
                                                myJadwalBooking[index]
                                                            .confirmation ==
                                                        'PENDING'
                                                    ? const Icon(Icons
                                                        .arrow_forward_ios_rounded)
                                                    : myJadwalBooking[index]
                                                                .confirmation ==
                                                            'CANCEL'
                                                        ? const Text(
                                                            'Ditolak',
                                                            softWrap: true,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                                color:
                                                                    Colors.red,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          )
                                                        : const Text(
                                                            'Diterima',
                                                            softWrap: true,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                                color: Color
                                                                    .fromRGBO(
                                                                        76,
                                                                        76,
                                                                        220,
                                                                        1),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          )
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                )
                              : const Expanded(
                                  child: Center(
                                    child: Text(
                                        'Tidak ada pesanan untuk hari ini'),
                                  ),
                                )
                        ],
                      );
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
              ),
            )
          ],
        ),
      )),
    );
  }
}
