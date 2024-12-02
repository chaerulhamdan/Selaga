import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:selaga_ver1/pages/mitra/homepage/component/no_venue.dart';
import 'package:selaga_ver1/repositories/api_repository.dart';
import 'package:selaga_ver1/repositories/models/arguments.dart';
import 'package:selaga_ver1/repositories/models/booking_model.dart';
import 'package:selaga_ver1/repositories/models/endpoints.dart';
import 'package:selaga_ver1/repositories/models/user_profile_model.dart';
import 'package:selaga_ver1/repositories/models/venue_model.dart';
import 'package:selaga_ver1/repositories/providers.dart';

class MitraHomePage extends StatefulWidget {
  const MitraHomePage({super.key});

  @override
  State<MitraHomePage> createState() => _MitraHomePageState();
}

class _MitraHomePageState extends State<MitraHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Venue Anda'),
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
              ApiRepository().getBooking(myToken.token),
            ]),
            builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
              if (snapshot.hasData &&
                  snapshot.connectionState == ConnectionState.done) {
                UserProfileModel myId = snapshot.data![0].result!;
                List<VenueModel> venue = snapshot.data![1].result!;
                List<BookingModel> bookings = snapshot.data?[2].result ?? [];
                List<VenueModel> myVenue = venue
                    .where((e) => int.parse(e.mitraId) == myId.id)
                    .toList();

                // List<VenueModel> myVenue =
                //     venue.where((e) => e.mitraId == myId.id).toList();

                Map<int, int> orderCounts = {};

                // for (BookingModel e in bookings) {
                //   orderCounts[e.timetable.lapanganBooking.venueId] =
                //       (orderCounts[e.timetable.lapanganBooking.venueId] ?? 0) +
                //           1;
                // }

                for (BookingModel e in bookings) {
                  orderCounts[int.parse(e.timetable.lapanganBooking.venueId)] =
                      (orderCounts[int.parse(
                                  e.timetable.lapanganBooking.venueId)] ??
                              0) +
                          1;
                }
                return myVenue.isNotEmpty
                    ? Column(
                        children: [
                          Expanded(
                            child: ListView.builder(
                              padding: const EdgeInsets.all(8),
                              itemCount: myVenue.length,
                              itemBuilder: (context, index) {
                                var img = myVenue[index].image;
                                var imgList = img?.split(',');

                                return Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8, right: 8, top: 16),
                                  child: InkWell(
                                    onTap: () {
                                      Provider.of<SelectedDate>(context,
                                              listen: false)
                                          .getSelectedIndex(0);

                                      ArgumentsMitra args = ArgumentsMitra(
                                          venueId: myVenue[index].id,
                                          venue: myVenue[index],
                                          lapangan: myVenue[index].lapangans,
                                          selectedDateIndex: 0,
                                          listLapangan:
                                              myVenue[index].lapangans,
                                          listJadwal: []);
                                      args.toJson();
                                      context.goNamed('mitra_detail_venue',
                                          extra: args);
                                    },
                                    child: Container(
                                      // height: 120,
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
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
                                          ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              child: myVenue[index]
                                                      .image!
                                                      .isNotEmpty
                                                  ? Image.network(
                                                      '${Endpoints().image}${imgList?.first}',
                                                      height: 115,
                                                      width: 115,
                                                      fit: BoxFit.cover,
                                                    )
                                                  : Container(
                                                      width: 115,
                                                      height: 115,
                                                      decoration:
                                                          const BoxDecoration(
                                                              color:
                                                                  Colors.grey),
                                                      child: const Icon(
                                                          Icons.error_outline),
                                                    )),
                                          const SizedBox(
                                            width: 12,
                                          ),
                                          Flexible(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  myVenue[index].nameVenue ??
                                                      '',
                                                  style: const TextStyle(
                                                    fontSize: 16.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  softWrap: true,
                                                ),
                                                const SizedBox(height: 5.0),
                                                Row(
                                                  children: [
                                                    const Icon(
                                                      Icons.star,
                                                      color: Color.fromARGB(
                                                          255, 255, 230, 3),
                                                      size: 20,
                                                    ),
                                                    const SizedBox(
                                                      width: 5,
                                                    ),
                                                    Flexible(
                                                      child: Text(
                                                        '${double.parse(myVenue[index].rating!).toStringAsFixed(2)} (${orderCounts[myVenue[index].id] ?? 0})',
                                                        style: const TextStyle(
                                                          fontSize: 14.0,
                                                        ),
                                                        // maxLines: 1,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    IconButton(
                                                        onPressed: () {
                                                          Provider.of<UserId>(
                                                                  context,
                                                                  listen: false)
                                                              .getUserId(
                                                                  myVenue[index]
                                                                          .id ??
                                                                      0);
                                                          context.goNamed(
                                                              'mitra_edit_venue');
                                                        },
                                                        icon: const Icon(
                                                          Icons
                                                              .edit_note_rounded,
                                                          color: Color.fromRGBO(
                                                              76, 76, 220, 1),
                                                        )),
                                                    IconButton(
                                                        onPressed: () {
                                                          showAlertDialogUnavailabe(
                                                              context,
                                                              myVenue[index]
                                                                      .id ??
                                                                  0);
                                                        },
                                                        icon: const Icon(
                                                          Icons
                                                              .delete_forever_outlined,
                                                          color: Colors.red,
                                                        ))
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: SizedBox(
                                width: MediaQuery.of(context).size.width,
                                height: 60,
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color.fromRGBO(
                                            76, 76, 220, 1),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12))),
                                    onPressed: () {
                                      context.goNamed('mitra_daftar_venue');
                                    },
                                    child: const Text(
                                      'Tambah Venue',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ))),
                          ),
                        ],
                      )
                    : const NoVenue();
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
      ),
    );
  }

  showAlertDialogUnavailabe(BuildContext context, int id) {
    Widget cancelButton = TextButton(
      child: const Text("Batal"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: const Text("Ya"),
      onPressed: () async {
        final token = Provider.of<Token>(context, listen: false).token;
        var data = await ApiRepository().deleteVenue(token, id);

        if (data.result != null && data.error == null) {
          if (!context.mounted) {
            return;
          }
          Navigator.of(context).pop();
          setState(() {});
        }
      },
    );

    AlertDialog alert = AlertDialog(
      title: const Text("Peringatan !"),
      content: const Text("Apakah anda ingin menghapus venue ini?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
