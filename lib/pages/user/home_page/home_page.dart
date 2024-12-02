import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:selaga_ver1/pages/user/home_page/components/by_populer.dart';
import 'package:selaga_ver1/pages/user/home_page/components/list_by_rating.dart';
import 'package:selaga_ver1/repositories/api_repository.dart';
import 'package:provider/provider.dart';
import 'package:selaga_ver1/repositories/models/booking_model.dart';
import 'package:selaga_ver1/repositories/models/venue_model.dart';
import 'package:selaga_ver1/repositories/providers.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final SearchController controller = SearchController();
  late Iterable<Widget> _lastOptions = <Widget>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              List<VenueModel> venue = snapshot.data?[0].result ?? [];

              List<BookingModel> bookings = snapshot.data?[1].result ?? [];

              if (venue.isNotEmpty) {
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(
                            left: 16, right: 16, bottom: 8, top: 8),
                        child: Text('Lokasi'),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              color: Color.fromRGBO(76, 76, 220, 1),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              'Bandung, Indonesia',
                              style: TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 80,
                        child: SearchBarTheme(
                          data: const SearchBarThemeData(
                              surfaceTintColor:
                                  MaterialStatePropertyAll(Colors.grey)),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: SearchAnchor.bar(
                                searchController: controller,
                                suggestionsBuilder: (BuildContext context,
                                    SearchController controller) {
                                  final List<VenueModel> options = venue
                                      .where((venue) => venue.nameVenue!
                                          .toLowerCase()
                                          .contains(controller.text
                                              .trim()
                                              .toLowerCase()))
                                      .toList();

                                  if (controller.text.trim() == '') {
                                    return [];
                                  }

                                  if (controller.text.trim() !=
                                      controller.text) {
                                    return _lastOptions;
                                  }

                                  _lastOptions = List<ListTile>.generate(
                                      options.length, (int index) {
                                    final String item =
                                        options[index].nameVenue ?? 'no name';
                                    return ListTile(
                                      title: Text(item),
                                      onTap: () {
                                        context
                                            .read<UserId>()
                                            .getUserId(venue[index].id ?? 0);
                                        context.pushNamed('user_detail_venue');
                                      },
                                    );
                                  });

                                  return _lastOptions;
                                }),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Berdasarkan Rating',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                context.goNamed('user_venue_byrating');
                              },
                              child: const Text(
                                'Lihat semua',
                                style: TextStyle(
                                  color: Color.fromRGBO(76, 76, 220, 1),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      VenueByRating(
                        venue: venue,
                        bookings: bookings,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Tempat populer',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                context.goNamed('user_venue_bypopuler');
                              },
                              child: const Text(
                                'Lihat semua',
                                style: TextStyle(
                                  color: Color.fromRGBO(76, 76, 220, 1),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      VenueByPopuler(venue: venue, booking: bookings)
                    ],
                  ),
                );
              } else {
                return const Center(
                  child: Text('Belum ada venue yang tersedia'),
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
