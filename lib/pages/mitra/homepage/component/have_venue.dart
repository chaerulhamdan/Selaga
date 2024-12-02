import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:selaga_ver1/repositories/api_repository.dart';
import 'package:selaga_ver1/repositories/models/arguments.dart';
import 'package:selaga_ver1/repositories/models/endpoints.dart';
import 'package:selaga_ver1/repositories/models/venue_model.dart';
import 'package:selaga_ver1/repositories/providers.dart';

class HaveVenue extends StatelessWidget {
  const HaveVenue({
    super.key,
    required this.myVenue,
  });

  final List<VenueModel> myVenue;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: myVenue.length,
            itemBuilder: (context, index) {
              var img = myVenue[index].image;
              var imgList = img?.split(',');

              return Padding(
                padding: const EdgeInsets.only(left: 8, right: 8, top: 16),
                child: InkWell(
                  onTap: () {
                    Provider.of<SelectedDate>(context, listen: false)
                        .getSelectedIndex(0);

                    ArgumentsMitra args = ArgumentsMitra(
                        venueId: myVenue[index].id,
                        venue: myVenue[index],
                        lapangan: myVenue[index].lapangans,
                        selectedDateIndex: 0,
                        listLapangan: myVenue[index].lapangans,
                        listJadwal: []);
                    args.toJson();
                    context.goNamed('mitra_detail_venue', extra: args);
                  },
                  child: Container(
                    // height: 120,
                    padding: const EdgeInsets.all(8),
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
                    child: Row(
                      children: [
                        ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: myVenue[index].image!.isNotEmpty
                                ? Image.network(
                                    '${Endpoints().image}${imgList?.first}',
                                    height: 115,
                                    width: 115,
                                    fit: BoxFit.cover,
                                  )
                                : Container(
                                    width: 115,
                                    height: 115,
                                    decoration:
                                        const BoxDecoration(color: Colors.grey),
                                    child: const Icon(Icons.error_outline),
                                  )),
                        const SizedBox(
                          width: 12,
                        ),
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                myVenue[index].nameVenue ?? '',
                                style: const TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                                softWrap: true,
                                // maxLines: 1,
                              ),
                              const SizedBox(height: 5.0),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.star,
                                    color: Color.fromARGB(255, 255, 230, 3),
                                    size: 20,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Flexible(
                                    child: Text(
                                      double.parse(myVenue[index].rating!)
                                          .toStringAsFixed(2),
                                      style: const TextStyle(
                                        fontSize: 14.0,
                                      ),
                                      // maxLines: 1,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  IconButton(
                                      onPressed: () {},
                                      icon: const Icon(
                                        Icons.edit_note_rounded,
                                        color: Color.fromRGBO(76, 76, 220, 1),
                                      )),
                                  IconButton(
                                      onPressed: () {
                                        showAlertDialogUnavailabe(
                                            context, myVenue[index].id ?? 0);
                                      },
                                      icon: const Icon(
                                        Icons.delete_forever_outlined,
                                        color: Colors.red,
                                      ))
                                ],
                              )
                            ],
                          ),
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
          child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 60,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(76, 76, 220, 1),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12))),
                  onPressed: () {
                    context.goNamed('mitra_daftar_venue');
                  },
                  child: const Text(
                    'Tambah Venue',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ))),
        ),
      ],
    );
  }

  showAlertDialogUnavailabe(BuildContext context, int id) {
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
        var data = await ApiRepository().deleteVenue(token, id);

        if (data.result != null && data.error == null) {
          if (!context.mounted) {
            return;
          }
          Navigator.of(context).pop();
        }
      },
    );

    AlertDialog alert = AlertDialog(
      title: const Text("Peringatan !"),
      content: const Text("Apakah anda ingin menghapus venue ini?"),
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
