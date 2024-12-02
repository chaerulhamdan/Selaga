import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:selaga_ver1/pages/components/format.dart';
import 'package:selaga_ver1/repositories/api_repository.dart';
import 'package:selaga_ver1/repositories/models/booking_model.dart';
import 'package:selaga_ver1/repositories/models/user_profile_model.dart';
import 'package:selaga_ver1/repositories/providers.dart';

class MitraProfilePage extends StatelessWidget {
  const MitraProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Profile'),
        ),
        body: Consumer<Token>(
          builder: (context, myToken, child) => FutureBuilder(
            future: Future.wait([
              ApiRepository().getMyMitraProfile(myToken.token),
              ApiRepository().getBooking(myToken.token)
            ]),
            builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
              if (snapshot.hasData &&
                  snapshot.connectionState == ConnectionState.done) {
                UserProfileMitraModel? profile = snapshot.data?[0].result;
                List<BookingModel> booking = snapshot.data?[1].result ?? [];

                List<BookingModel> myBooking = booking
                    .where((e) =>
                        int.parse(e.timetable.lapanganBooking.venueBooking
                                .mitraId) ==
                            profile?.id &&
                        e.confirmation == 'DONE')
                    .toList();

                List<String> salary = [];

                if (myBooking.isNotEmpty) {
                  for (var e in myBooking) {
                    salary.add(e.timetable.lapanganBooking.venueBooking.price!);
                  }
                }

                int countSalary = 0;

                if (salary.isNotEmpty) {
                  countSalary =
                      salary.map((e) => int.parse(e)).reduce((a, b) => a + b);
                }

                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Center(
                        child: CircleAvatar(
                          radius: 50,
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      Text(
                        profile?.name ?? 'no name',
                        style: const TextStyle(
                            color: Color.fromRGBO(76, 76, 220, 1)),
                      ),
                      const SizedBox(height: 30.0),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Container(
                          height: 100,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: const Color.fromRGBO(76, 76, 220, 1)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.money_rounded,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    CurrencyFormat.convertToIdr(countSalary),
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                ],
                              ),
                              const Text(
                                'Penghasilan Anda',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      const ListTile(
                        title: Text('Pengaturan'),
                        trailing: Icon(Icons.keyboard_arrow_right),
                      ),
                      const Divider(
                        indent: 15,
                        endIndent: 15,
                      ),
                      const ListTile(
                        title: Text('Lapor'),
                        trailing: Icon(Icons.keyboard_arrow_right),
                      ),
                      const Divider(
                        indent: 15,
                        endIndent: 15,
                      ),
                      ListTile(
                        title: const Text('Keluar'),
                        trailing: const Icon(Icons.logout),
                        onTap: () async {
                          var data =
                              await ApiRepository().mitraLogout(myToken.token);

                          if (data.result != null) {
                            if (!context.mounted) {
                              return;
                            }
                            context.goNamed('landing_page');
                          } else {
                            if (!context.mounted) {
                              return;
                            }
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('${data.error}'),
                                duration: const Duration(milliseconds: 1200),
                              ),
                            );
                          }
                        },
                      ),
                      const Divider(
                        indent: 15,
                        endIndent: 15,
                      ),
                    ],
                  ),
                );
              } else if (snapshot.hasError) {
                return Column(
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
        ));
  }
}
