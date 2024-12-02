import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:selaga_ver1/pages/components/sportfieldcard.dart';
import 'package:selaga_ver1/repositories/models/booking_model.dart';
import 'package:selaga_ver1/repositories/models/endpoints.dart';
import 'package:selaga_ver1/repositories/models/venue_model.dart';
import 'package:selaga_ver1/repositories/providers.dart';

class VenueByRating extends StatelessWidget {
  const VenueByRating({
    super.key,
    required this.venue,
    required this.bookings,
  });

  final List<VenueModel> venue;
  final List<BookingModel> bookings;

  @override
  Widget build(BuildContext context) {
    List<VenueModel> venues = [];

    Map<int, int> orderCounts = {};

    // for (BookingModel e in bookings) {
    //   orderCounts[e.timetable.lapanganBooking.venueId] =
    //       (orderCounts[e.timetable.lapanganBooking.venueId] ?? 0) + 1;
    // }

    for (BookingModel e in bookings) {
      orderCounts[int.parse(e.timetable.lapanganBooking.venueId)] =
          (orderCounts[int.parse(e.timetable.lapanganBooking.venueId)] ?? 0) +
              1;
    }

    for (var e in venue) {
      venues.add(e);
    }

    venues.sort((a, b) => -a.rating!.compareTo(b.rating!));

    return SizedBox(
      height: 327,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        scrollDirection: Axis.horizontal,
        itemCount: venue.length,
        itemBuilder: (context, index) {
          var img = venues[index].image;
          var imgList = img?.split(',');
          int totalOrders = orderCounts[venues[index].id] ?? 0;
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: SportsFieldCard(
              fieldName: venues[index].nameVenue ?? '',
              fieldImage: imgList != null
                  ? '${Endpoints().image}${imgList.first}'
                  : null,
              fieldLocation: venues[index].lokasiVenue ?? '',
              fieldPrice: venues[index].price ?? '',
              onPressed: () {
                context.read<UserId>().getUserId(venues[index].id ?? 0);
                context.pushNamed('user_detail_venue');
              },
              fieldRating: venues[index].rating ?? '0',
              totalOrders: totalOrders,
            ),
          );
        },
      ),
    );
  }
}
