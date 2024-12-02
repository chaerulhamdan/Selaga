import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:selaga_ver1/repositories/api_repository.dart';
import 'package:selaga_ver1/repositories/models/booking_model.dart';
import 'package:selaga_ver1/repositories/models/endpoints.dart';
import 'package:selaga_ver1/repositories/providers.dart';

class MitraDetailConfirmation extends StatefulWidget {
  const MitraDetailConfirmation({super.key});

  @override
  State<MitraDetailConfirmation> createState() =>
      _MitraDetailConfirmationState();
}

class _MitraDetailConfirmationState extends State<MitraDetailConfirmation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Pemesanan'),
        centerTitle: true,
      ),
      body: SafeArea(
          child: Consumer2<Token, BookingId>(
        builder: (context, myToken, myBooking, child) => FutureBuilder(
          future: ApiRepository().getBookingDetail(myToken.token, myBooking.id),
          builder: (context, snapshot) {
            if (snapshot.hasData &&
                snapshot.connectionState == ConnectionState.done) {
              BookingModel booking = snapshot.data!.result!;
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            title: const Text('Nama Pemesan'),
                            titleTextStyle: const TextStyle(
                                color: Colors.black, fontSize: 14),
                            subtitle: Text(booking.order.name),
                            subtitleTextStyle: const TextStyle(
                              color: Colors.black,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Divider(
                            indent: 8,
                            endIndent: 8,
                          ),
                          ListTile(
                            title: const Text('Tanggal yang dipesan'),
                            titleTextStyle: const TextStyle(
                                color: Colors.black, fontSize: 14),
                            subtitle: Text(DateFormat('EEEE, dd MMMM yyyy')
                                .format(booking.date)),
                            subtitleTextStyle: const TextStyle(
                              color: Colors.black,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Divider(
                            indent: 8,
                            endIndent: 8,
                          ),
                          ListTile(
                            title: const Text('Jadwal yang dipesan'),
                            titleTextStyle: const TextStyle(
                                color: Colors.black, fontSize: 14),
                            subtitle: Text(
                                '${booking.hours}.00 - ${1 + int.parse(booking.hours)}.00'),
                            subtitleTextStyle: const TextStyle(
                              color: Colors.black,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Divider(
                            indent: 8,
                            endIndent: 8,
                          ),
                          ListTile(
                            title: const Text('Venue'),
                            titleTextStyle: const TextStyle(
                                color: Colors.black, fontSize: 14),
                            subtitle: Text(booking.timetable.nameVenue),
                            subtitleTextStyle: const TextStyle(
                              color: Colors.black,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Divider(
                            indent: 8,
                            endIndent: 8,
                          ),
                          ListTile(
                            title: const Text('Lapangan yang dipesan'),
                            titleTextStyle: const TextStyle(
                                color: Colors.black, fontSize: 14),
                            subtitle: Text(booking.timetable.nameLapangan),
                            subtitleTextStyle: const TextStyle(
                              color: Colors.black,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Divider(
                            indent: 8,
                            endIndent: 8,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Bukti Pembayaran'),
                                Text(
                                  booking.payment,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (ctx) {
                                      final width =
                                          MediaQuery.of(context).size.width;
                                      final height =
                                          MediaQuery.of(context).size.height;
                                      return AlertDialog(
                                        content: Stack(
                                          children: [
                                            SizedBox(
                                              width: width * 0.9,
                                              height: height * 0.9,
                                              child: Image.network(
                                                '${Endpoints().payment}${booking.image}',
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () =>
                                                  Navigator.pop(context),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(3.0),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      color: Colors.black
                                                          .withOpacity(0.5),
                                                      shape: BoxShape.circle),
                                                  child: Icon(
                                                    Icons.close,
                                                    color: Colors.white
                                                        .withOpacity(0.9),
                                                    size: 30,
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                        insetPadding: EdgeInsets.zero,
                                        contentPadding: EdgeInsets.zero,
                                        // clipBehavior:
                                        //     Clip.antiAliasWithSaveLayer,
                                      );
                                    },
                                  );
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    '${Endpoints().payment}${booking.image}',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                    booking.confirmation == 'PENDING'
                        ? Row(
                            children: [
                              Expanded(
                                child: SizedBox(
                                    height: 60,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.grey,
                                          shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(12),
                                            bottomLeft: Radius.circular(12),
                                          ))),
                                      onPressed: () async {
                                        List<String> tempAvailableHour = booking
                                            .timetable.availableHour
                                            .split(',')
                                            .toList();
                                        List<String> tempUnAvailableHour =
                                            booking.timetable.unavailableHour
                                                .split(',')
                                                .toList();

                                        tempAvailableHour.add(booking.hours);

                                        tempUnAvailableHour
                                            .remove(booking.hours);

                                        if (tempUnAvailableHour.isEmpty) {
                                          tempUnAvailableHour.add('0');
                                        }

                                        final availableHour =
                                            tempAvailableHour.join(',');
                                        final unAvailableHour =
                                            tempUnAvailableHour.join(',');

                                        var data = await ApiRepository()
                                            .updateBooking(
                                                token: myToken.token,
                                                id: myBooking.id,
                                                confirmation: 'CANCEL')
                                            .whenComplete(() => ApiRepository()
                                                .postEditJadwal(
                                                    token: myToken.token,
                                                    id:
                                                        '${booking.timetable.id}',
                                                    nameVenue: booking
                                                        .timetable.nameVenue,
                                                    nameLapangan: booking
                                                        .timetable.nameLapangan,
                                                    date:
                                                        booking.timetable.days,
                                                    availableHour:
                                                        availableHour,
                                                    unavailableHour:
                                                        unAvailableHour,
                                                    lapanganId:
                                                        '${booking.timetable.lapanganId}'));

                                        if (!context.mounted) {
                                          return;
                                        }

                                        if (data.result != null) {
                                          setState(() {});
                                          SnackBar snackBar = SnackBar(
                                            content: const Text(
                                                'Pesanan ditolak',
                                                style: TextStyle(fontSize: 16)),
                                            // backgroundColor: Colors.indigo,
                                            duration: const Duration(
                                                milliseconds: 1300),
                                            dismissDirection:
                                                DismissDirection.up,
                                            behavior: SnackBarBehavior.floating,
                                            margin: EdgeInsets.only(
                                                bottom: MediaQuery.of(context)
                                                        .size
                                                        .height -
                                                    150,
                                                left: 10,
                                                right: 10),
                                          );

                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(snackBar);
                                        } else {
                                          SnackBar snackBar = SnackBar(
                                            content: Text('${data.error}',
                                                style: const TextStyle(
                                                    fontSize: 16)),
                                            // backgroundColor: Colors.indigo,
                                            duration: const Duration(
                                                milliseconds: 1300),
                                            dismissDirection:
                                                DismissDirection.up,
                                            behavior: SnackBarBehavior.floating,
                                            margin: EdgeInsets.only(
                                                bottom: MediaQuery.of(context)
                                                        .size
                                                        .height -
                                                    150,
                                                left: 10,
                                                right: 10),
                                          );

                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(snackBar);
                                        }
                                      },
                                      child: const Text(
                                        'Tolak',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    )),
                              ),
                              Expanded(
                                child: SizedBox(
                                    height: 60,
                                    child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                const Color.fromRGBO(
                                                    76, 76, 220, 1),
                                            shape: const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(12),
                                              bottomRight: Radius.circular(12),
                                            ))),
                                        onPressed: () async {
                                          var data = await ApiRepository()
                                              .updateBooking(
                                                  token: myToken.token,
                                                  id: myBooking.id,
                                                  confirmation: 'DONE');
                                          if (!context.mounted) {
                                            return;
                                          }
                                          if (data.result != null) {
                                            setState(() {});
                                            SnackBar snackBar = SnackBar(
                                              content: const Text(
                                                  'Pesanan diterima',
                                                  style:
                                                      TextStyle(fontSize: 16)),
                                              duration: const Duration(
                                                  milliseconds: 1300),
                                              dismissDirection:
                                                  DismissDirection.up,
                                              behavior:
                                                  SnackBarBehavior.floating,
                                              margin: EdgeInsets.only(
                                                  bottom: MediaQuery.of(context)
                                                          .size
                                                          .height -
                                                      150,
                                                  left: 10,
                                                  right: 10),
                                            );
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(snackBar);
                                          } else {
                                            SnackBar snackBar = SnackBar(
                                              content: Text('${data.error}',
                                                  style: const TextStyle(
                                                      fontSize: 16)),
                                              // backgroundColor: Colors.indigo,
                                              duration: const Duration(
                                                  milliseconds: 1300),
                                              dismissDirection:
                                                  DismissDirection.up,
                                              behavior:
                                                  SnackBarBehavior.floating,
                                              margin: EdgeInsets.only(
                                                  bottom: MediaQuery.of(context)
                                                          .size
                                                          .height -
                                                      150,
                                                  left: 10,
                                                  right: 10),
                                            );

                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(snackBar);
                                          }
                                        },
                                        child: const Text(
                                          'Terima',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ))),
                              ),
                            ],
                          )
                        : Container(),
                  ],
                ),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
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
