import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:selaga_ver1/repositories/api_repository.dart';
import 'package:selaga_ver1/repositories/models/arguments.dart';
import 'package:selaga_ver1/repositories/models/lapangan_model.dart';
import 'package:selaga_ver1/repositories/models/venue_model.dart';
import 'package:selaga_ver1/repositories/providers.dart';

class EditJadwalPage extends StatefulWidget {
  const EditJadwalPage(
      {super.key,
      required this.lapangan,
      required this.venue,
      required this.myJadwal,
      required this.selectedDateIndex});

  final int selectedDateIndex;
  final Lapangan lapangan;
  final VenueModel venue;
  final List<JadwalLapanganModel> myJadwal;

  @override
  State<EditJadwalPage> createState() => _EditJadwalPageState();
}

class _EditJadwalPageState extends State<EditJadwalPage> {
  late JadwalLapanganModel dataJadwal;
  List<int> _availableHour = [];
  List<int> _unAvailableHour = [];

  @override
  void initState() {
    dataJadwal = widget.myJadwal.firstWhere((e) =>
        e.days ==
        DateTime(DateTime.now().year, DateTime.now().month,
            DateTime.now().day + widget.selectedDateIndex));

    final List<String> tempavailableHour =
        dataJadwal.availableHour!.split(',').toList();

    final List<String> tempunAvailableHour =
        dataJadwal.unavailableHour!.split(',').toList();
    for (var e in tempavailableHour) {
      _availableHour.add(int.parse(e));
    }
    _availableHour.remove(0);
    for (var e in tempunAvailableHour) {
      _unAvailableHour.add(int.parse(e));
    }

    _unAvailableHour.remove(0);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Jadwal'),
        centerTitle: true,
      ),
      body: SafeArea(
          child: Consumer<Token>(
        builder: (context, myToken, child) => Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  children: [
                    const Text('Jadwal yang tersedia'),
                    SizedBox(
                        height: 210,
                        child: GridView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 4,
                                    mainAxisSpacing: 8.0,
                                    crossAxisSpacing: 8.0,
                                    childAspectRatio: (1 / .5)),
                            padding: const EdgeInsets.all(8.0),
                            itemCount: _availableHour.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                  onTap: () {
                                    showAlertDialogAvailabe(context, index);
                                  },
                                  child: Container(
                                      decoration: BoxDecoration(
                                          color: const Color.fromARGB(
                                              34, 158, 158, 158),
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      child: Center(
                                          child: Text(
                                        '${_availableHour[index]}.00',
                                        style: const TextStyle(fontSize: 18),
                                      ))));
                            })),
                    const Text('Jadwal yang sudah dipesan'),
                    SizedBox(
                        height: 210,
                        child: GridView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 4,
                                    mainAxisSpacing: 8.0,
                                    crossAxisSpacing: 8.0,
                                    childAspectRatio: (1 / .5)),
                            padding: const EdgeInsets.all(8.0),
                            itemCount: _unAvailableHour.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                  onTap: () {
                                    showAlertDialogUnavailabe(context, index);
                                  },
                                  child: Container(
                                      decoration: BoxDecoration(
                                          color: const Color.fromARGB(34, 158,
                                              158, 158), // color of grid items
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      child: Center(
                                          child: Text(
                                        '${_unAvailableHour[index]}.00',
                                        style: const TextStyle(fontSize: 18),
                                      ))));
                            })),
                  ],
                ),
              ),
              InkWell(
                onTap: () async {
                  List<String> tempavailableHour = ['0'];
                  List<String> tempunavailableHour = ['0'];

                  if (_availableHour.isNotEmpty) {
                    for (var e in _availableHour) {
                      tempavailableHour.add(e.toString());
                    }
                  }
                  if (_unAvailableHour.isNotEmpty) {
                    for (var e in _unAvailableHour) {
                      tempunavailableHour.add(e.toString());
                    }
                  }

                  final String availableHour = tempavailableHour.join(',');
                  final String unavailableHour = tempunavailableHour.join(',');

                  var data = await ApiRepository().postEditJadwal(
                      token: myToken.token,
                      nameLapangan: dataJadwal.nameLapangan ?? '',
                      nameVenue: dataJadwal.nameVenue ?? '',
                      date: dataJadwal.days ?? DateTime.now(),
                      id: '${dataJadwal.id ?? 0}',
                      availableHour: availableHour,
                      unavailableHour: unavailableHour,
                      lapanganId: dataJadwal.lapanganId ?? 0);

                  if (data.result != null) {
                    if (!context.mounted) {
                      return;
                    }

                    ArgumentsMitra args = ArgumentsMitra(
                        venueId: widget.venue.id,
                        venue: widget.venue,
                        lapangan: widget.lapangan,
                        selectedDateIndex:
                            Provider.of<SelectedDate>(context, listen: false)
                                .selectedIndex,
                        listLapangan: [widget.lapangan],
                        listJadwal: [dataJadwal]);
                    args.toJson();

                    context.goNamed('mitra_lapangan_detail', extra: args);
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(76, 76, 220, 1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: Text(
                      'Terapkan Jadwal',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      )),
    );
  }

  showAlertDialogUnavailabe(BuildContext context, int index) {
    Widget cancelButton = TextButton(
      child: const Text("Batal"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: const Text("Ya"),
      onPressed: () {
        Navigator.of(context).pop();
        setState(() {
          _availableHour.add(_unAvailableHour[index]);
          if (_unAvailableHour.isNotEmpty) {
            _unAvailableHour.remove(_unAvailableHour[index]);
          }

          _availableHour.sort();
        });
      },
    );

    AlertDialog alert = AlertDialog(
      title: const Text("Peringatan!"),
      content: const Text(
          "Apakah anda ingin merubah status jadwal pada jam tersebut?"),
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

  showAlertDialogAvailabe(BuildContext context, int index) {
    Widget cancelButton = TextButton(
      child: const Text("Batal"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: const Text("Ya"),
      onPressed: () {
        Navigator.of(context).pop();
        setState(() {
          _unAvailableHour.add(_availableHour[index]);
          if (_availableHour.isNotEmpty) {
            _availableHour.remove(_availableHour[index]);
          }

          _unAvailableHour.sort();
        });
      },
    );

    AlertDialog alert = AlertDialog(
      title: const Text("Peringatan!"),
      content: const Text(
          "Apakah anda ingin merubah status jadwal pada jam tersebut?"),
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
