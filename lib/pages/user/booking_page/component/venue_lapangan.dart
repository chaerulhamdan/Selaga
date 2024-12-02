import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:selaga_ver1/repositories/models/arguments.dart';
import 'package:selaga_ver1/repositories/models/lapangan_model.dart';
import 'package:selaga_ver1/repositories/models/venue_model.dart';
import 'package:selaga_ver1/repositories/providers.dart';

class VenueLapangan extends StatelessWidget {
  final List<Lapangan> myLapangan;
  final VenueModel venue;
  final List<JadwalLapanganModel> jadwal;
  const VenueLapangan(
      {super.key,
      required this.myLapangan,
      required this.venue,
      required this.jadwal});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: myLapangan.length,
            itemBuilder: (context, index) {
              List<JadwalLapanganModel> myJadwal = jadwal
                  .where((e) => int.parse(e.lapanganId) == myLapangan[index].id)
                  .toList();
              List<String> hourList = [];
              List<String> passedhourList = [];

              for (var e in myJadwal) {
                var tempList = [];
                if (e.days ==
                    DateTime(DateTime.now().year, DateTime.now().month,
                        DateTime.now().day)) {
                  tempList = (e.availableHour!.split(',').toList());
                  for (var element in tempList) {
                    hourList.add(element);
                  }
                  DateTime now = DateTime.now();
                  int currentHour = now.hour;

                  // Membuat list untuk menyimpan jam yang sudah dilewati
                  passedhourList = hourList.where((hour) {
                    int hourInt = int.parse(hour.split(':')[0]);
                    return hourInt <= currentHour;
                  }).toList();

                  List<String> commonElements = hourList
                      .where((element) => passedhourList.contains(element))
                      .toList();

                  // Menghapus elemen yang sama dari kedua daftar
                  hourList.removeWhere(
                      (element) => commonElements.contains(element));
                }

                if (e.days ==
                    DateTime(DateTime.now().year, DateTime.now().month,
                        DateTime.now().day + 1)) {
                  tempList = (e.availableHour!.split(',').toList());
                  for (var element in tempList) {
                    hourList.add(element);
                  }
                }

                if (e.days ==
                    DateTime(DateTime.now().year, DateTime.now().month,
                        DateTime.now().day + 2)) {
                  tempList = (e.availableHour!.split(',').toList());
                  for (var element in tempList) {
                    hourList.add(element);
                  }
                }
              }
              return Padding(
                padding: const EdgeInsets.only(left: 8, right: 8, top: 16),
                child: InkWell(
                  onTap: () {
                    if (hourList.isNotEmpty) {
                      Provider.of<SelectedDate>(context, listen: false)
                          .getSelectedIndex(0);
                      Provider.of<HourAvailable>(context, listen: false)
                          .clear();
                      Provider.of<HourUnAvailable>(context, listen: false)
                          .clear();
                      Provider.of<SelectedHour>(context, listen: false).clear();

                      ArgumentsUser args = ArgumentsUser(
                          venue: venue,
                          lapangan: myLapangan[index],
                          listJadwal: myJadwal);
                      args.toJson();

                      context.goNamed('user_lapangan_detail', extra: args);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Tidak ada jadwal yang tersedia'),
                          duration: Duration(milliseconds: 1100),
                        ),
                      );
                    }
                  },
                  child: Container(
                    // height: 125,
                    height: 85,
                    padding: const EdgeInsets.all(16),
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
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              myLapangan[index].nameLapangan ?? '',
                              style: const TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                              softWrap: true,
                              // maxLines: 1,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        hourList.isNotEmpty
                            ? Row(
                                children: [
                                  const Text('Tersedia '),
                                  Text(
                                    '${hourList.length} ',
                                    style: const TextStyle(
                                        color: Color.fromRGBO(76, 76, 220, 1),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  ),
                                  const Text('pilihan jadwal'),
                                ],
                              )
                            : const Text(
                                'Tidak ada jadwal yang tersedia',
                                style: TextStyle(color: Colors.red),
                              ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
