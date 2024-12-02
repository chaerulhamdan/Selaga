import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:selaga_ver1/pages/components/format.dart';
import 'package:selaga_ver1/repositories/models/booking_model.dart';
import 'package:selaga_ver1/repositories/models/endpoints.dart';
import 'package:selaga_ver1/repositories/models/venue_model.dart';
import 'package:selaga_ver1/repositories/providers.dart';

class VenueByPopuler extends StatelessWidget {
  const VenueByPopuler({
    super.key,
    required this.venue,
    required this.booking,
  });

  final List<VenueModel> venue;
  final List<BookingModel> booking;

  @override
  Widget build(BuildContext context) {
    Map<int, int> orderCounts = {};

    // for (BookingModel e in booking) {
    //   orderCounts[e.timetable.lapanganBooking.venueId] =
    //       (orderCounts[e.timetable.lapanganBooking.venueId] ?? 0) + 1;
    // }

    for (BookingModel e in booking) {
      orderCounts[int.parse(e.timetable.lapanganBooking.venueId)] =
          (orderCounts[int.parse(e.timetable.lapanganBooking.venueId)] ?? 0) +
              1;
    }

    venue.sort(
        (a, b) => (orderCounts[b.id] ?? 0).compareTo(orderCounts[a.id] ?? 0));
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: InkWell(
        onTap: () {
          context.read<UserId>().getUserId(venue[0].id ?? 0);
          context.goNamed('user_detail_venue');
        },
        child: Container(
          padding: const EdgeInsets.all(8),
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
              children: [
                ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: venue[0].image != null
                        ? Image.network(
                            '${Endpoints().image}${venue[0].image!.split(',')[0]}',
                            height: 140,
                            width: 140,
                            fit: BoxFit.cover,
                          )
                        : Container(
                            width: 140,
                            height: 140,
                            decoration: const BoxDecoration(color: Colors.grey),
                            child: const Icon(Icons.error_outline),
                          )),
                const SizedBox(
                  width: 15,
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          venue[0].nameVenue ?? '',
                          style: const TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                          // maxLines: 1,
                        ),
                        const SizedBox(height: 5.0),
                        Text(
                          venue[0].lokasiVenue ?? '',
                          style: const TextStyle(
                            fontSize: 14.0,
                            // color: Colors.grey,
                          ),
                          // maxLines: 1,
                        ),
                        const SizedBox(height: 5.0),
                        Text(
                          '(${orderCounts[venue[0].id] ?? 0}) kali dipesan',
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
                                  double.parse(venue[0].price!)),
                              style: const TextStyle(
                                  fontSize: 14.0,
                                  color: Color.fromRGBO(76, 76, 220, 1),
                                  fontWeight: FontWeight.bold),
                              // maxLines: 1,
                            ),
                            const Text(' /jam')
                          ],
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
                            Text(double.parse(venue[0].rating!)
                                .toStringAsFixed(2))
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
