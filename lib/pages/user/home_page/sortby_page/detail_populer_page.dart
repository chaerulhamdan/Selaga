import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:selaga_ver1/pages/components/format.dart';
import 'package:selaga_ver1/repositories/api_repository.dart';
import 'package:selaga_ver1/repositories/models/booking_model.dart';
import 'package:selaga_ver1/repositories/models/endpoints.dart';
import 'package:selaga_ver1/repositories/models/venue_model.dart';
import 'package:selaga_ver1/repositories/providers.dart';

class ListPopulerVanuePage extends StatelessWidget {
  const ListPopulerVanuePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tempat Populer'),
        centerTitle: true,
      ),
      body: SafeArea(
          child: Consumer<Token>(
        builder: (context, mytoken, child) => FutureBuilder(
          future: Future.wait([
            ApiRepository().getAllVenue(mytoken.token),
            ApiRepository().getBooking(mytoken.token),
          ]),
          builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
            if (snapshot.hasData &&
                snapshot.connectionState == ConnectionState.done) {
              List<VenueModel> venues = snapshot.data?[0].result ?? [];
              List<BookingModel> bookings = snapshot.data?[1].result ?? [];

              Map<int, int> orderCounts = {};

              // for (BookingModel e in bookings) {
              //   orderCounts[e.timetable.lapanganBooking.venueId] =
              //       (orderCounts[e.timetable.lapanganBooking.venueId] ?? 0) + 1;
              // }

              for (BookingModel e in bookings) {
                orderCounts[int.parse(e.timetable.lapanganBooking.venueId)] =
                    (orderCounts[int.parse(
                                e.timetable.lapanganBooking.venueId)] ??
                            0) +
                        1;
              }

              venues.sort((a, b) =>
                  (orderCounts[b.id] ?? 0).compareTo(orderCounts[a.id] ?? 0));

              return Padding(
                padding: const EdgeInsets.all(8),
                child: ListView.builder(
                  itemCount: venues.length,
                  itemBuilder: (context, index) {
                    VenueModel venue = venues[index];
                    int totalOrders = orderCounts[venue.id] ?? 0;
                    return InkWell(
                      onTap: () {
                        context.read<UserId>().getUserId(venue.id ?? 0);
                        context.goNamed('user_detail_venue');
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 175,
                          padding: const EdgeInsets.only(left: 16, right: 16),
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
                          child: Center(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: venue.image != null
                                        ? Image.network(
                                            '${Endpoints().image}${venue.image!.split(',')[0]}',
                                            height: 140,
                                            width: 140,
                                            fit: BoxFit.cover,
                                          )
                                        : Container(
                                            width: 140,
                                            height: 140,
                                            decoration: const BoxDecoration(
                                                color: Colors.grey),
                                            child:
                                                const Icon(Icons.error_outline),
                                          )),
                                const SizedBox(
                                  width: 10,
                                ),
                                Flexible(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        venue.nameVenue ?? '',
                                        style: const TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        // maxLines: 1,
                                      ),
                                      const SizedBox(height: 5.0),
                                      Text(
                                        venue.lokasiVenue ?? '',
                                        style: const TextStyle(
                                          fontSize: 14.0,
                                        ),
                                        // maxLines: 1,
                                      ),
                                      const SizedBox(height: 5.0),
                                      Row(
                                        children: [
                                          Text(
                                            CurrencyFormat.convertToIdr(
                                                double.parse(venue.price!)),
                                            style: const TextStyle(
                                                fontSize: 14.0,
                                                color: Color.fromRGBO(
                                                    76, 76, 220, 1),
                                                fontWeight: FontWeight.bold),
                                            // maxLines: 1,
                                          ),
                                          const Text(' /jam')
                                        ],
                                      ),
                                      const SizedBox(height: 5.0),
                                      Text(
                                        '($totalOrders) kali dipesan',
                                        style: const TextStyle(
                                          fontSize: 14.0,
                                        ),
                                        // maxLines: 1,
                                      ),
                                      const SizedBox(height: 5.0),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.star,
                                            color: Colors.yellow,
                                            size: 20,
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Text(double.parse(venue.rating!)
                                              .toStringAsFixed(2))
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
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
      )),
    );
  }
}
