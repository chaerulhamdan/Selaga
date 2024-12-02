import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:selaga_ver1/repositories/models/lapangan_model.dart';
import 'package:selaga_ver1/repositories/models/venue_model.dart';
import 'package:selaga_ver1/repositories/providers.dart';

class HourSection extends StatefulWidget {
  const HourSection(
      {super.key,
      required this.myJadwal,
      required this.lapangan,
      required this.venue});

  final List<JadwalLapanganModel> myJadwal;
  final Lapangan lapangan;
  final VenueModel venue;

  @override
  State<HourSection> createState() => _HourSectionState();
}

class _HourSectionState extends State<HourSection> {
  List<String> _hour = [];
  List<String> _availableHour = [];
  List<String> _unAvailableHour = [];
  List<String> _selectedHour = [];
  List<String> _passedHour = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Menggunakan Provider di dalam didChangeDependencies
    _availableHour = Provider.of<HourAvailable>(context).hour;
    // _hour = Provider.of<HourAvailable>(context).hour;
    _unAvailableHour = Provider.of<HourUnAvailable>(context).hour;

    if (_hour.contains('0')) {
      _hour.remove('0');
    }
    if (_unAvailableHour.contains('0')) {
      _unAvailableHour.remove('0');
    }
    if (_availableHour.contains('0')) {
      _availableHour.remove('0');
    }
  }

  @override
  void initState() {
    _hour = widget.lapangan.hour!.split(',').toList();
    for (var e in widget.myJadwal) {
      if (e.days ==
          DateTime(
              DateTime.now().year, DateTime.now().month, DateTime.now().day)) {
        List<String> availableHour = e.availableHour!.split(',').toList();
        List<String> unAvailableHour = e.unavailableHour!.split(',').toList();

        WidgetsBinding.instance.addPostFrameCallback((timeStamp) =>
            Provider.of<HourAvailable>(context, listen: false)
                .add(availableHour));

        WidgetsBinding.instance.addPostFrameCallback((timeStamp) =>
            Provider.of<HourUnAvailable>(context, listen: false)
                .add(unAvailableHour));
      }
    }

    DateTime now = DateTime.now();
    int currentHour = now.hour;

    _passedHour = _hour.where((hour) {
      int hourInt = int.parse(hour.split(':')[0]);
      return hourInt <= currentHour;
    }).toList();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: widget.myJadwal.any((e) =>
                e.days ==
                DateTime(
                    DateTime.now().year,
                    DateTime.now().month,
                    DateTime.now().day +
                        Provider.of<SelectedDate>(context, listen: true)
                            .selectedIndex))
            ? SizedBox(
                height: 170,
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4, // number of items in each row
                      mainAxisSpacing: 8.0, // spacing between rows
                      crossAxisSpacing: 8.0, // spacing between columns
                      childAspectRatio: (1 / .5)),
                  padding: const EdgeInsets.all(8.0), // padding around the grid
                  itemCount: _hour.length, // total number of items
                  itemBuilder: (context, index) {
                    return _unAvailableHour.contains(_hour[index])
                        ? Container(
                            decoration: BoxDecoration(
                                color: Colors.red, // color of grid items
                                borderRadius: BorderRadius.circular(8)),
                            child: Center(
                                child: Text('${_hour[index]}.00',
                                    style: const TextStyle(
                                        fontSize: 18.0, color: Colors.white))),
                          )
                        : Provider.of<SelectedDate>(context, listen: true)
                                        .selectedIndex ==
                                    0 &&
                                _passedHour.contains(_hour[index])
                            ? Container(
                                decoration: BoxDecoration(
                                    color: Colors.red, // color of grid items
                                    borderRadius: BorderRadius.circular(8)),
                                child: Center(
                                    child: Text('${_hour[index]}.00',
                                        style: const TextStyle(
                                            fontSize: 18.0,
                                            color: Colors.white))),
                              )
                            : InkWell(
                                onTap: () {
                                  setState(() {
                                    Provider.of<SelectedHour>(context,
                                            listen: false)
                                        .clear();

                                    if (_selectedHour.contains(_hour[index])) {
                                      _selectedHour.remove(_hour[index]);
                                    } else {
                                      _selectedHour.clear();
                                      _selectedHour.add(_hour[index]);
                                    }
                                    Provider.of<SelectedHour>(context,
                                            listen: false)
                                        .add(_selectedHour);
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: _selectedHour
                                              .contains(_hour[index])
                                          ? const Color.fromRGBO(76, 76, 220, 1)
                                          : const Color.fromARGB(34, 158, 158,
                                              158), // color of grid items
                                      borderRadius: BorderRadius.circular(8)),
                                  child: Center(
                                    child: Text('${_hour[index]}.00',
                                        style: _selectedHour
                                                .contains(_hour[index])
                                            ? const TextStyle(
                                                fontSize: 18.0,
                                                color: Colors.white)
                                            : const TextStyle(fontSize: 18.0)),
                                  ),
                                ));
                  },
                ),
              )
            : const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                    Center(child: Text('Jadwal Tidak Tersedia')),
                  ]));
  }
}
