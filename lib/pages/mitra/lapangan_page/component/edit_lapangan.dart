import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:selaga_ver1/pages/components/format.dart';
import 'package:selaga_ver1/repositories/api_repository.dart';
import 'package:selaga_ver1/repositories/models/arguments.dart';
import 'package:selaga_ver1/repositories/models/venue_model.dart';
import 'package:selaga_ver1/repositories/providers.dart';

class EditMyLapanganPage extends StatefulWidget {
  const EditMyLapanganPage(
      {super.key, required this.venue, required this.myLapangan});
  final VenueModel venue;
  final Lapangan myLapangan;

  @override
  State<EditMyLapanganPage> createState() => _EditMyLapanganPageState();
}

class _EditMyLapanganPageState extends State<EditMyLapanganPage> {
  var _isSending = false;
  final List<int> _hour = [
    7,
    8,
    9,
    10,
    11,
    12,
    13,
    14,
    15,
    16,
    17,
    18,
    19,
    20,
    21,
    22
  ];
  List<int> _hourSelected = [];

  @override
  void initState() {
    List<String> temp = widget.myLapangan.hour!.split(',').toList();
    for (var e in temp) {
      _hourSelected.add(int.parse(e));
    }
    super.initState();
  }

  void _uploadLapangan() async {
    if (_hourSelected.isEmpty) {
      if (!context.mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Anda belum menambahkan jam oprasional'),
          duration: Duration(milliseconds: 1200),
        ),
      );
      return;
    }
    setState(() {
      _isSending = true;
    });

    final mytoken = Provider.of<Token>(context, listen: false).token;

    var tempHour = [];
    for (var e in _hourSelected) {
      tempHour.add(e.toString());
    }
    final String myHour = tempHour.join(',');

    var data = await ApiRepository()
        .updateLapangan(mytoken, myHour, widget.myLapangan);

    if (data.result != null) {
      if (!mounted) {
        return;
      }

      ArgumentsMitra args = ArgumentsMitra(
          venueId: widget.venue.id,
          venue: widget.venue,
          lapangan: widget.myLapangan,
          selectedDateIndex: 0,
          listLapangan: [widget.myLapangan],
          listJadwal: []);
      args.toJson();
      context.goNamed('mitra_edit_lapangan_success', extra: args);
    } else {
      setState(() {
        _isSending = false;
      });
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${data.error}'),
          duration: const Duration(milliseconds: 1100),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Lapangan'),
        centerTitle: true,
      ),
      body: SafeArea(
          child: SafeArea(
              child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${widget.myLapangan.nameLapangan}',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text('Harga',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[500])),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                        CurrencyFormat.convertToIdrNoSymbol(
                            int.parse(widget.venue.price!)),
                        style: const TextStyle(fontSize: 16)),
                    const Text('Rupiah',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(76, 76, 220, 1)))
                  ],
                ),
                const Divider(
                    // indent: 10,
                    // endIndent: 10,
                    ),
                const SizedBox(
                  height: 20,
                ),
                Text('Jam Oprasional',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[500])),
                // const Divider(
                //     // indent: 10,
                //     // endIndent: 10,
                //     ),
                const SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      if (_hourSelected.isNotEmpty) {
                        if (_hourSelected.length < 16) {
                          List<int> tempHour = [];
                          for (var e in _hour) {
                            tempHour.add(e);
                          }
                          _hourSelected = tempHour.toSet().toList();
                        } else {
                          _hourSelected.clear();
                        }
                      } else {
                        for (var e in _hour) {
                          _hourSelected.add(e);
                        }
                      }
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Container(
                      height: 41,
                      width: 85,
                      decoration: BoxDecoration(
                          color: _hourSelected.length == 16
                              ? const Color.fromRGBO(76, 76, 220, 1)
                              : const Color.fromARGB(34, 158, 158, 158),
                          borderRadius: BorderRadius.circular(8)),
                      child: Center(
                          child: Text(
                        'Semua',
                        style: _hourSelected.length == 16
                            ? const TextStyle(fontSize: 16, color: Colors.white)
                            : const TextStyle(fontSize: 16),
                      )),
                    ),
                  ),
                ),
                SizedBox(
                    height: 210,
                    child: GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount:
                                    4, // number of items in each row
                                mainAxisSpacing: 8.0, // spacing between rows
                                crossAxisSpacing:
                                    8.0, // spacing between columns
                                childAspectRatio: (1 / .5)),
                        padding: const EdgeInsets.all(
                            8.0), // padding around the grid
                        itemCount: _hour.length, // total number of items
                        itemBuilder: (context, index) {
                          // bool tapped = index == _selectedGridIndex;
                          return InkWell(
                              onTap: () {
                                setState(() {
                                  if (_hourSelected.contains(_hour[index])) {
                                    _hourSelected.remove(_hour[index]);
                                    // ScaffoldMessenger.of(context)
                                    //     .showSnackBar(
                                    //   const SnackBar(
                                    //     content: Text('Jam sudah dipilih'),
                                    //     duration:
                                    //         Duration(milliseconds: 1200),
                                    //   ),
                                    // );
                                  } else {
                                    _hourSelected.add(_hour[index]);
                                  }
                                });
                              },
                              child: Container(
                                  decoration: BoxDecoration(
                                      color: _hourSelected
                                              .contains(_hour[index])
                                          ? const Color.fromRGBO(76, 76, 220, 1)
                                          : const Color.fromARGB(34, 158, 158,
                                              158), // color of grid items
                                      borderRadius: BorderRadius.circular(8)),
                                  child: Center(
                                      child: _hourSelected
                                              .contains(_hour[index])
                                          ? Text(
                                              '${_hour[index]}.00',
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18),
                                            )
                                          : Text(
                                              '${_hour[index]}.00',
                                              style:
                                                  const TextStyle(fontSize: 18),
                                            ))));
                        })),
              ],
            ),
            InkWell(
              onTap: _isSending ? null : _uploadLapangan,
              // onTap: _uploadLapangan,
              child: Container(
                padding: const EdgeInsets.all(20),
                // margin: const EdgeInsets.symmetric(horizontal: 25),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(76, 76, 220, 1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: _isSending
                      ? const SizedBox(
                          height: 25,
                          width: 25,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Edit Lapangan',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ))),
    );
  }
}
