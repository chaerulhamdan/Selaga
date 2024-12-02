import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:selaga_ver1/repositories/api_repository.dart';
import 'package:selaga_ver1/repositories/models/booking_model.dart';
import 'package:selaga_ver1/repositories/models/endpoints.dart';
import 'package:selaga_ver1/repositories/providers.dart';

class DetailRiwayatPage extends StatelessWidget {
  const DetailRiwayatPage({super.key});

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
              var img =
                  booking.timetable.lapanganBooking.venueBooking.image ?? '';
              var imgList = img.split(',');
              return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(children: [
                    Expanded(
                      child: Column(
                        children: [
                          ListTile(
                            title: const Text('Nama Pemesan'),
                            titleTextStyle: const TextStyle(
                                color: Colors.black, fontSize: 14),
                            subtitle: Text(booking.order.name),
                            subtitleTextStyle: const TextStyle(
                              color: Colors.black,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          ListTile(
                            title: const Text('Venue'),
                            titleTextStyle: const TextStyle(
                                color: Colors.black, fontSize: 14),
                            subtitle: Text(booking.timetable.lapanganBooking
                                    .venueBooking.nameVenue ??
                                'noname'),
                            subtitleTextStyle: const TextStyle(
                              color: Color.fromRGBO(76, 76, 220, 1),
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          ListTile(
                            title: const Text('Lapangan'),
                            titleTextStyle: const TextStyle(
                                color: Colors.black, fontSize: 14),
                            subtitle: Text(booking.timetable.nameLapangan),
                            subtitleTextStyle: const TextStyle(
                              color: Colors.black,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          ListTile(
                            leading: const Icon(Icons.location_on,
                                color: Color.fromRGBO(76, 76, 220, 1)),
                            title: Text(booking.timetable.lapanganBooking
                                .venueBooking.lokasiVenue!),
                          ),
                          ListTile(
                              leading: const Icon(Icons.calendar_month,
                                  color: Color.fromRGBO(76, 76, 220, 1)),
                              title: Text(DateFormat('dd MMMM yyyy').format(
                                  DateTime(
                                      DateTime.now().year,
                                      DateTime.now().month,
                                      DateTime.now().day +
                                          Provider.of<SelectedDate>(context,
                                                  listen: false)
                                              .selectedIndex))),
                              subtitle: Text(
                                  '${booking.hours}.00 - ${1 + int.parse(booking.hours)}.00')),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              // color: Colors.grey,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: imgList.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: SizedBox(
                                      width: 250,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.network(
                                          '${Endpoints().image}${imgList[index]}',
                                          // height: 100,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    booking.ratingStatus == "PENDING"
                        ? RatingWidget(
                            booking: booking,
                            token: myToken.token,
                          )
                        : const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Center(
                                child: Text(
                                    "Terimakasih sudah memberikan Rating untuk venue ini.")),
                          )
                  ]));
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

class RatingWidget extends StatefulWidget {
  const RatingWidget({
    super.key,
    required this.booking,
    required this.token,
  });
  final BookingModel booking;
  final String token;
  @override
  State<RatingWidget> createState() => _RatingWidgetState();
}

class _RatingWidgetState extends State<RatingWidget> {
  List<double> rating = [];
  var rated = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (rated == false) {
      return Container(
          height: 175,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: const Color.fromARGB(19, 76, 76, 220),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 16, right: 8, top: 8),
                child: Text(
                  'Berikan penilaian untuk venue ini',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
              SizedBox(
                height: 86,
                child: ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(8),
                  scrollDirection: Axis.horizontal,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            if (rating.contains(index.toDouble() + 1.0)) {
                              rating.clear();
                            } else {
                              rating.clear();
                              rating.add(index.toDouble() + 1.0);
                            }
                          });
                        },
                        child: Container(
                          width: 56,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: rating.contains(index.toDouble() + 1.0)
                                ? const Color.fromRGBO(76, 76, 220, 1)
                                : const Color.fromARGB(61, 76, 76, 220),
                          ),
                          child: Center(
                            child: Text(
                              '${index + 1}',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
                child: SizedBox(
                  height: 50,
                  // width: MediaQuery.of(context).size.width - 100,
                  child: InkWell(
                    onTap: () async {
                      if (rating.isEmpty) {
                        // SnackBar snackBar = SnackBar(
                        //   content: const Text(
                        //       'Anda belum memberi angka penilaian',
                        //       style: TextStyle(fontSize: 16)),
                        //   // backgroundColor: Colors.indigo,
                        //   duration: const Duration(milliseconds: 1300),
                        //   dismissDirection: DismissDirection.up,
                        //   behavior: SnackBarBehavior.floating,
                        //   margin: EdgeInsets.only(
                        //       bottom: MediaQuery.of(context).size.height - 150,
                        //       left: 10,
                        //       right: 10),
                        // );
                        // ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Anda belum memberi angka penilaian'),
                            duration: Duration(milliseconds: 1200),
                          ),
                        );
                        return;
                      } else {
                        rating.add(double.parse(widget.booking.timetable
                            .lapanganBooking.venueBooking.rating!));

                        double sum =
                            rating.reduce((value, element) => value + element);

                        double average = sum / rating.length;

                        var data = await ApiRepository()
                            .updateVenueRating(
                                widget.token,
                                widget.booking.timetable.lapanganBooking
                                    .venueBooking,
                                average.toString())
                            .whenComplete(() => ApiRepository()
                                .updateBookingRating(
                                    token: widget.token,
                                    id: widget.booking.id));

                        if (data.result != null) {
                          setState(() {
                            rated = true;
                          });
                          if (!context.mounted) {
                            return;
                          }
                          // // context.goNamed('user_detail_pemesanan');
                          // SnackBar snackBar = SnackBar(
                          //   content: const Text(
                          //       'Terima kasih atas penilaian anda',
                          //       style: TextStyle(fontSize: 16)),
                          //   // backgroundColor: Colors.indigo,
                          //   duration: const Duration(milliseconds: 1300),
                          //   dismissDirection: DismissDirection.up,
                          //   behavior: SnackBarBehavior.floating,
                          //   margin: EdgeInsets.only(
                          //       bottom:
                          //           MediaQuery.of(context).size.height - 150,
                          //       left: 10,
                          //       right: 10),
                          // );
                          // ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          // ScaffoldMessenger.of(context).showSnackBar(
                          //   const SnackBar(
                          //     content: Text('Terima kasih atas penilaian anda'),
                          //     duration: Duration(milliseconds: 1200),
                          //   ),
                          // );
                        } else {
                          if (!context.mounted) {
                            return;
                          }
                          // SnackBar snackBar = SnackBar(
                          //   content: Text('${data.error}',
                          //       style: const TextStyle(fontSize: 16)),
                          //   // backgroundColor: Colors.indigo,
                          //   duration: const Duration(milliseconds: 1300),
                          //   dismissDirection: DismissDirection.up,
                          //   behavior: SnackBarBehavior.floating,
                          //   margin: EdgeInsets.only(
                          //       bottom:
                          //           MediaQuery.of(context).size.height - 150,
                          //       left: 10,
                          //       right: 10),
                          // );

                          // ScaffoldMessenger.of(context).showSnackBar(snackBar);

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${data.error}'),
                              duration: const Duration(milliseconds: 1200),
                            ),
                          );
                        }
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color.fromRGBO(76, 76, 220, 1)),
                      child: const Center(
                        child: Text(
                          'Beri Penilaian',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ));
    } else {
      return const Padding(
        padding: EdgeInsets.all(8.0),
        child: Center(
            child:
                Text("Terimakasih sudah memberikan Rating untuk venue ini.")),
      );
    }
  }
}
