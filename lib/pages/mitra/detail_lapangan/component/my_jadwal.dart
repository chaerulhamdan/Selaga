import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:selaga_ver1/pages/components/format.dart';
import 'package:selaga_ver1/repositories/api_repository.dart';
import 'package:selaga_ver1/repositories/models/arguments.dart';
import 'package:selaga_ver1/repositories/models/lapangan_model.dart';
import 'package:selaga_ver1/repositories/models/venue_model.dart';
import 'package:selaga_ver1/repositories/providers.dart';

class MyJadwal extends StatefulWidget {
  const MyJadwal({
    super.key,
    required this.myJadwal,
    required this.lapangan,
    required this.venue,
    required this.selectedDateIndex,
  });

  final List<JadwalLapanganModel> myJadwal;
  final Lapangan lapangan;
  final VenueModel venue;
  final int selectedDateIndex;

  @override
  State<MyJadwal> createState() => _MyJadwalState();
}

class _MyJadwalState extends State<MyJadwal> {
  List<String> hour = [];
  List<String> availableHour = [];
  List<String> unAvailableHour = [];
  List<int> hourSorted = [];
  List<int> availableHourSorted = [];
  List<int> unAvailableHourSorted = [];

  @override
  void initState() {
    for (var e in widget.myJadwal) {
      if (e.days ==
          DateTime(DateTime.now().year, DateTime.now().month,
              DateTime.now().day + widget.selectedDateIndex)) {
        availableHour = e.availableHour!.split(',').toList();
        availableHour.remove('0');
      }
    }
    for (var e in availableHour) {
      hour.add(e);
      availableHourSorted.add(int.parse(e));
    }

    for (var e in widget.myJadwal) {
      if (e.days ==
          DateTime(DateTime.now().year, DateTime.now().month,
              DateTime.now().day + widget.selectedDateIndex)) {
        unAvailableHour = e.unavailableHour!.split(',').toList();
        unAvailableHour.remove('0');
      }
    }
    for (var e in unAvailableHour) {
      hour.add(e);
      unAvailableHourSorted.add(int.parse(e));
    }

    for (var e in hour) {
      hourSorted.add(int.parse(e));
    }
    hourSorted.sort();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 250,
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color.fromARGB(19, 76, 76, 220)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text(
                        '${DateFormat('MMMM').format(DateTime.now())} ${DateTime.now().year}',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 80,
                      width: 222,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 3,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 2.0),
                            child: InkWell(
                                onTap: () {
                                  setState(() {
                                    Provider.of<SelectedDate>(context,
                                            listen: false)
                                        .getSelectedIndex(index);

                                    hour.clear();
                                    hourSorted.clear();
                                    availableHourSorted.clear();
                                    unAvailableHourSorted.clear();

                                    for (var e in widget.myJadwal) {
                                      if (e.days ==
                                          DateTime(
                                              DateTime.now().year,
                                              DateTime.now().month,
                                              DateTime.now().day + index)) {
                                        availableHour = e.availableHour!
                                            .split(',')
                                            .toList();
                                      }
                                    }

                                    availableHour.remove('0');
                                    for (var e in availableHour) {
                                      hour.add(e);
                                      availableHourSorted.add(int.parse(e));
                                    }

                                    for (var e in widget.myJadwal) {
                                      if (e.days ==
                                          DateTime(
                                              DateTime.now().year,
                                              DateTime.now().month,
                                              DateTime.now().day + index)) {
                                        unAvailableHour = e.unavailableHour!
                                            .split(',')
                                            .toList();
                                      }
                                      unAvailableHour.remove('0');
                                    }
                                    for (var e in unAvailableHour) {
                                      hour.add(e);
                                      unAvailableHourSorted.add(int.parse(e));
                                    }

                                    for (var e in hour) {
                                      hourSorted.add(int.parse(e));
                                    }
                                    hourSorted.sort();
                                  });
                                },
                                child: Container(
                                    width: 70,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Provider.of<SelectedDate>(context,
                                                      listen: true)
                                                  .selectedIndex ==
                                              index
                                          ? const Color.fromRGBO(76, 76, 220, 1)
                                          : const Color.fromARGB(
                                              61, 76, 76, 220),
                                    ),
                                    child: index == 0
                                        ? Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                '${DateTime.now().day}',
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                  DateFormat('EEE')
                                                      .format(DateTime.now()),
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold))
                                            ],
                                          )
                                        : index == 1
                                            ? Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    DateFormat('d').format(
                                                      DateTime(
                                                          DateTime.now().year,
                                                          DateTime.now().month,
                                                          DateTime.now().day +
                                                              1),
                                                    ),
                                                    style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Text(
                                                      DateFormat('EEE').format(
                                                          DateTime(
                                                              DateTime.now()
                                                                  .year,
                                                              DateTime.now()
                                                                  .month,
                                                              DateTime.now()
                                                                      .day +
                                                                  1)),
                                                      style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold))
                                                ],
                                              )
                                            : Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    DateFormat('d').format(
                                                      DateTime(
                                                          DateTime.now().year,
                                                          DateTime.now().month,
                                                          DateTime.now().day +
                                                              2),
                                                    ),
                                                    style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Text(
                                                      DateFormat('EEE').format(
                                                          DateTime(
                                                              DateTime.now()
                                                                  .year,
                                                              DateTime.now()
                                                                  .month,
                                                              DateTime.now()
                                                                      .day +
                                                                  2)),
                                                      style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold))
                                                ],
                                              ))),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    const Text('Tanggal yang dipilih'),
                    Text(
                      DateFormat('dd MMMM yyyy').format(DateTime(
                          DateTime.now().year,
                          DateTime.now().month,
                          DateTime.now().day +
                              Provider.of<SelectedDate>(context, listen: false)
                                  .selectedIndex)),
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Jam',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      Text(
                        CurrencyFormat.convertToIdr(
                            double.parse(widget.venue.price ?? '0')),
                        style: const TextStyle(
                            color: Color.fromRGBO(76, 76, 220, 1),
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                      const Text(' /Jam'),
                    ],
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              widget.myJadwal.any((e) =>
                      e.days ==
                      DateTime(
                          DateTime.now().year,
                          DateTime.now().month,
                          DateTime.now().day +
                              Provider.of<SelectedDate>(context).selectedIndex))
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        children: [
                          Container(
                            height: 15,
                            width: 15,
                            color: Colors.red,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          const Text('Jadwal sudah dipesan')
                        ],
                      ),
                    )
                  : Container(),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
          Expanded(
            child: widget.myJadwal.any((e) =>
                    e.days ==
                    DateTime(
                        DateTime.now().year,
                        DateTime.now().month,
                        DateTime.now().day +
                            Provider.of<SelectedDate>(context).selectedIndex))
                ? SizedBox(
                    height: 170,
                    child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4, // number of items in each row
                              mainAxisSpacing: 8.0, // spacing between rows
                              crossAxisSpacing: 8.0, // spacing between columns
                              childAspectRatio: (1 / .5)),
                      padding:
                          const EdgeInsets.all(8.0), // padding around the grid
                      itemCount: hourSorted.length, // total number of items
                      itemBuilder: (context, index) {
                        // bool tapped = index == _selectedGridIndex;
                        return InkWell(
                            onTap: () {
                              // setState(() {
                              //   _selectedGridIndex = index;
                              // });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color:
                                      // tapped
                                      //     ? const Color.fromRGBO(76, 76, 220, 1)
                                      //     :
                                      unAvailableHourSorted
                                              .contains(hourSorted[index])
                                          ? Colors.red
                                          : const Color.fromARGB(34, 158, 158,
                                              158), // color of grid items
                                  borderRadius: BorderRadius.circular(8)),
                              child: Center(
                                child: Text('${hourSorted[index]}.00',
                                    style: unAvailableHourSorted
                                            .contains(hourSorted[index])
                                        ? const TextStyle(
                                            fontSize: 18.0, color: Colors.white)
                                        :
                                        // tapped
                                        //     ? const TextStyle(
                                        //         fontSize: 18.0,
                                        //         color: Colors.white)
                                        // :
                                        const TextStyle(fontSize: 18.0)),
                              ),
                            ));
                      },
                    ),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Center(child: Text('Jadwal Tidak Tersedia')),
                      TextButton(
                        onPressed: _uploadMyJadwal,
                        child: const Text(
                          'Tambah Jadwal',
                          style: TextStyle(
                            color: Color.fromRGBO(76, 76, 220, 1),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ],
                  ),
          ),
          widget.myJadwal.any((e) =>
                  e.days ==
                  DateTime(
                      DateTime.now().year,
                      DateTime.now().month,
                      DateTime.now().day +
                          Provider.of<SelectedDate>(context, listen: false)
                              .selectedIndex))
              ? InkWell(
                  onTap: () {
                    List<JadwalLapanganModel> selectedJadwal = [];

                    if (widget.myJadwal.any((e) =>
                        e.days ==
                        DateTime(
                            DateTime.now().year,
                            DateTime.now().month,
                            DateTime.now().day +
                                Provider.of<SelectedDate>(context,
                                        listen: false)
                                    .selectedIndex))) {
                      selectedJadwal = widget.myJadwal;
                    }

                    ArgumentsMitra args = ArgumentsMitra(
                        venueId: widget.venue.id,
                        venue: widget.venue,
                        lapangan: widget.lapangan,
                        selectedDateIndex:
                            Provider.of<SelectedDate>(context, listen: false)
                                .selectedIndex,
                        listLapangan: [widget.lapangan],
                        listJadwal: selectedJadwal);
                    args.toJson();

                    context.goNamed('mitra_edit_jadwal_lapangan', extra: args);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(76, 76, 220, 1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Text(
                        'Edit Jadwal',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                )
              : Container()
        ],
      ),
    );
  }

  void _uploadMyJadwal() async {
    if (!context.mounted) {
      return;
    }
    final mytoken = Provider.of<Token>(context, listen: false).token;
    final date = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day +
            Provider.of<SelectedDate>(context, listen: false).selectedIndex);

    var data = await ApiRepository().postTambahJadwal(
        token: mytoken,
        nameVenue: widget.venue.nameVenue ?? '',
        nameLapangan: widget.lapangan.nameLapangan ?? '',
        date: date,
        hour: widget.lapangan.hour ?? '',
        lapanganId: widget.lapangan.id ?? -1);

    if (data.result != null) {
      if (!mounted) {
        return;
      }
      ArgumentsMitra args = ArgumentsMitra(
          venueId: widget.venue.id,
          venue: widget.venue,
          lapangan: widget.lapangan,
          selectedDateIndex:
              Provider.of<SelectedDate>(context, listen: false).selectedIndex,
          listLapangan: [widget.lapangan],
          listJadwal: []);
      args.toJson();
      context.goNamed('mitra_lapangan_detail', extra: args);

      String myHour = data.result ?? '';
      setState(() {
        hour = myHour.split(',').toList();
      });
    } else {
      if (!mounted) {
        return;
      }
      SnackBar snackBar = SnackBar(
        content: Text('${data.error}', style: const TextStyle(fontSize: 16)),
        // backgroundColor: Colors.indigo,
        duration: const Duration(milliseconds: 1300),
        dismissDirection: DismissDirection.up,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).size.height - 150,
            left: 10,
            right: 10),
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }
  }
}
