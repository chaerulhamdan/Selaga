import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:selaga_ver1/pages/user/jadwal_page/components/my_calendar_booked.dart';
import 'package:selaga_ver1/repositories/api_repository.dart';
import 'package:selaga_ver1/repositories/models/booking_model.dart';
import 'package:selaga_ver1/repositories/models/endpoints.dart';
import 'package:selaga_ver1/repositories/models/user_profile_model.dart';
import 'package:selaga_ver1/repositories/providers.dart';

class MyJadwalBookedPage extends StatefulWidget {
  const MyJadwalBookedPage({super.key});

  @override
  State<MyJadwalBookedPage> createState() => _MyJadwalBookedPageState();
}

class _MyJadwalBookedPageState extends State<MyJadwalBookedPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jadwal Saya'),
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
                    ApiRepository().getBooking(mytoken.token),
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
                      late UserProfileModel profile;

                      if (snapshot.data?[0].result != null) {
                        profile = snapshot.data?[0].result;
                      }
                      List<BookingModel> booking =
                          snapshot.data?[1].result ?? [];
                      List<BookingModel> myBooking = booking
                          .where((e) => profile.id == e.order.id)
                          .toList();

                      List<BookingModel> myJadwalBooking = myBooking
                          .where((e) =>
                              e.date.isAtSameMomentAs(date) &&
                              e.confirmation == 'DONE')
                          .toList();

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
                                    var img = myBooking[index]
                                            .timetable
                                            .lapanganBooking
                                            .venueBooking
                                            .image ??
                                        '';
                                    var imgList = img.split(',');
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: InkWell(
                                        onTap: () {
                                          Provider.of<BookingId>(context,
                                                  listen: false)
                                              .updateBookingId(
                                                  myJadwalBooking[index].id);
                                          context
                                              .goNamed('user_detail_pemesanan');
                                        },
                                        child: Container(
                                          height: 150,
                                          padding: const EdgeInsets.all(4),
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
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: SizedBox(
                                                  height: 120,
                                                  width: 120,
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                    child: Image.network(
                                                      '${Endpoints().image}${imgList.first}',
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Flexible(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      myJadwalBooking[index]
                                                              .timetable
                                                              .lapanganBooking
                                                              .venueBooking
                                                              .nameVenue ??
                                                          'noname',
                                                      style: const TextStyle(
                                                        fontSize: 16.0,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    Flexible(
                                                      child: Row(
                                                        children: [
                                                          const Icon(
                                                              Icons.location_on,
                                                              color: Color
                                                                  .fromRGBO(
                                                                      76,
                                                                      76,
                                                                      220,
                                                                      1)),
                                                          const SizedBox(
                                                            width: 5,
                                                          ),
                                                          Text(myJadwalBooking[
                                                                      index]
                                                                  .timetable
                                                                  .lapanganBooking
                                                                  .venueBooking
                                                                  .lokasiVenue ??
                                                              ''),
                                                        ],
                                                      ),
                                                    ),
                                                    Row(
                                                      children: [
                                                        const Icon(
                                                            Icons
                                                                .calendar_month,
                                                            color:
                                                                Color.fromRGBO(
                                                                    76,
                                                                    76,
                                                                    220,
                                                                    1)),
                                                        const SizedBox(
                                                          width: 5,
                                                        ),
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(DateFormat(
                                                                    'dd MMMM yyyy')
                                                                .format(
                                                                    myJadwalBooking[
                                                                            index]
                                                                        .date)),
                                                            Text(
                                                                '${myJadwalBooking[index].hours}.00 - ${1 + int.parse(myJadwalBooking[index].hours)}.00'),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ))
                              : const Expanded(
                                  child: Center(
                                    child:
                                        Text('Tidak ada jadwal untuk hari ini'),
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
