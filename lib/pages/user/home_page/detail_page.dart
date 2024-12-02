import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:selaga_ver1/pages/components/format.dart';
import 'package:selaga_ver1/repositories/api_repository.dart';
import 'package:selaga_ver1/repositories/models/arguments.dart';
import 'package:selaga_ver1/repositories/models/endpoints.dart';
import 'package:selaga_ver1/repositories/models/venue_model.dart';
import 'package:selaga_ver1/repositories/providers.dart';

class FieldDetailPage extends StatefulWidget {
  const FieldDetailPage({
    super.key,
  });

  @override
  State<FieldDetailPage> createState() => _FieldDetailPageState();
}

class _FieldDetailPageState extends State<FieldDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Detail'),
      ),
      body: SafeArea(
        child: Consumer2<Token, UserId>(
          builder: (context, myToken, myId, child) => FutureBuilder(
            future: ApiRepository().getVenueDetail(myToken.token, myId.id),
            builder: (context, snapshot) {
              if (snapshot.hasData &&
                  snapshot.connectionState == ConnectionState.done) {
                if (snapshot.data?.result == null) {
                  return const Center(
                      child: Text('Please Check Your Internet Connection'));
                } else {
                  return DetailWidget(
                    venue: snapshot.data!.result!,
                  );
                }
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
        ),
      ),
    );
  }
}

class DetailWidget extends StatelessWidget {
  final VenueModel venue;
  const DetailWidget({
    super.key,
    required this.venue,
  });

  @override
  Widget build(BuildContext context) {
    var img = venue.image;
    var imgList = img?.split(',');

    var fasilitas = venue.fasilitasVenue;
    var fasilitasList = fasilitas?.split(',');

    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 250,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                '${Endpoints().image}${imgList!.first}',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Row(
            children: [
              Container(
                height: 35,
                width: 65,
                decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 223, 222, 222),
                    borderRadius: BorderRadius.circular(8)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.star,
                      color: Color.fromARGB(255, 255, 230, 3),
                      size: 20,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(double.parse(venue.rating!).toStringAsFixed(2))
                  ],
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Flexible(
                child: SizedBox(
                  height: 35,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: fasilitasList?.length,
                    itemBuilder: (context, index) {
                      return Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 223, 222, 222),
                                borderRadius: BorderRadius.circular(8)),
                            child: Center(
                                child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(fasilitasList![index]),
                            )),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                        ],
                      );
                    },
                  ),
                ),
              )
            ],
          ),
          Text(
            venue.nameVenue ?? '',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Row(
            children: [
              Text(
                CurrencyFormat.convertToIdr(double.parse(venue.price!)),
                style: const TextStyle(color: Color.fromRGBO(76, 76, 220, 1)),
              ),
              const Text(' /jam',
                  style: TextStyle(
                    color: Colors.grey,
                  ))
            ],
          ),
          Row(
            children: [
              const Icon(
                Icons.phone,
                color: Color.fromRGBO(76, 76, 220, 1),
                // size: 20,
              ),
              const SizedBox(
                width: 10,
              ),
              Text(venue.owner?.phone ?? '',
                  style: const TextStyle(
                    fontSize: 15,
                  )),
            ],
          ),
          Row(
            children: [
              const Icon(
                Icons.location_on,
                color: Color.fromRGBO(76, 76, 220, 1),
              ),
              const SizedBox(
                width: 10,
              ),
              Text(venue.lokasiVenue ?? '',
                  style: const TextStyle(
                    fontSize: 15,
                  )),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          const Text('Deskripsi',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(
            height: 5,
          ),
          Flexible(
            child: Text('${venue.descVenue}',
                style: const TextStyle(
                  fontSize: 15,
                )),
          ),
          const SizedBox(
            height: 5,
          ),
          const Text('Foto lainnya',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          SizedBox(
            height: 150,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: imgList.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Container(
                    width: 150,
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(10)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                          '${Endpoints().image}${imgList[index]}',
                          fit: BoxFit.cover),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 60,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(76, 76, 220, 1),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12))),
                  onPressed: () {
                    ArgumentsUser args = ArgumentsUser(
                        venue: venue, lapangan: null, listJadwal: []);
                    args.toJson();
                    context.goNamed('user_venue_lapangan', extra: args);
                  },
                  child: const Text(
                    'Pesan Sekarang',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  )))
        ],
      ),
    );
  }
}
