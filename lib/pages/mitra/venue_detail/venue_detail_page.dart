import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:selaga_ver1/pages/mitra/venue_detail/component/detail.dart';
import 'package:selaga_ver1/repositories/api_repository.dart';
import 'package:selaga_ver1/repositories/providers.dart';

class MitraDetailPage extends StatefulWidget {
  final int venueId;
  const MitraDetailPage({
    super.key,
    required this.venueId,
  });

  @override
  State<MitraDetailPage> createState() => _MitraDetailPageState();
}

class _MitraDetailPageState extends State<MitraDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Venue Detail'),
      ),
      body: SafeArea(
        child: Consumer<Token>(
          builder: (context, myToken, child) => FutureBuilder(
            future:
                ApiRepository().getVenueDetail(myToken.token, widget.venueId),
            builder: (context, snapshot) {
              if (snapshot.hasData &&
                  snapshot.connectionState == ConnectionState.done) {
                return DetailWidget(
                  venue: snapshot.data!.result!,
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
        ),
      ),
    );
  }
}
