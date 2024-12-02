import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:selaga_ver1/repositories/api_repository.dart';
import 'package:selaga_ver1/repositories/models/arguments.dart';
import 'package:selaga_ver1/repositories/models/venue_model.dart';
import 'package:selaga_ver1/repositories/providers.dart';

class HaveLapangan extends StatelessWidget {
  final List<Lapangan> myLapangan;
  final VenueModel venue;
  const HaveLapangan(
      {super.key, required this.myLapangan, required this.venue});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: myLapangan.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(left: 8, right: 8, top: 16),
                child: InkWell(
                  onTap: () {
                    Provider.of<SelectedDate>(context, listen: false)
                        .getSelectedIndex(0);
                    ArgumentsMitra args = ArgumentsMitra(
                        venueId: venue.id,
                        venue: venue,
                        lapangan: myLapangan[index],
                        selectedDateIndex: 0,
                        listLapangan: myLapangan,
                        listJadwal: []);
                    args.toJson();
                    context.goNamed('mitra_lapangan_detail', extra: args);
                  },
                  child: Container(
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
                            Row(
                              children: [
                                IconButton(
                                    onPressed: () {
                                      ArgumentsMitra args = ArgumentsMitra(
                                          venueId: venue.id,
                                          venue: venue,
                                          lapangan: myLapangan[index],
                                          selectedDateIndex: 0,
                                          listLapangan: myLapangan,
                                          listJadwal: []);
                                      args.toJson();
                                      context.goNamed('mitra_edit_lapangan',
                                          extra: args);
                                    },
                                    icon: const Icon(
                                      Icons.edit_calendar,
                                      color: Color.fromRGBO(76, 76, 220, 1),
                                    )),
                                IconButton(
                                    onPressed: () {
                                      ArgumentsMitra args = ArgumentsMitra(
                                          venueId: venue.id,
                                          venue: venue,
                                          lapangan: myLapangan.first,
                                          selectedDateIndex: 0,
                                          listLapangan: myLapangan,
                                          listJadwal: []);
                                      showAlertDialogUnavailabe(context,
                                          myLapangan[index].id ?? 0, args);
                                    },
                                    icon: const Icon(
                                      Icons.delete_forever_outlined,
                                      color: Colors.red,
                                    ))
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: InkWell(
            onTap: () {
              ArgumentsMitra args = ArgumentsMitra(
                  venueId: venue.id,
                  venue: venue,
                  lapangan: myLapangan.first,
                  selectedDateIndex: 0,
                  listLapangan: myLapangan,
                  listJadwal: []);
              args.toJson();
              context.goNamed('mitra_tambah_lapangan', extra: args);
            },
            child: Container(
              padding: const EdgeInsets.all(20),
              // margin: const EdgeInsets.symmetric(horizontal: 25),
              decoration: BoxDecoration(
                color: const Color.fromRGBO(76, 76, 220, 1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Text(
                  'Tambah Lapangan',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  showAlertDialogUnavailabe(BuildContext context, int id, ArgumentsMitra args) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: const Text("Batal"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: const Text("Ya"),
      onPressed: () async {
        final token = Provider.of<Token>(context, listen: false).token;
        var data = await ApiRepository().deleteLapangan(token, id);

        if (data.result != null && data.error == null) {
          args.toJson();
          if (!context.mounted) {
            return;
          }
          Navigator.of(context).pop();
          SchedulerBinding.instance.addPostFrameCallback((_) {
            context.goNamed("mitra_lapangan_page", extra: args);
          });
        }
      },
    );

    AlertDialog alert = AlertDialog(
      title: const Text("Peringatan !"),
      content: const Text("Apakah anda ingin menghapus lapangan ini?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
