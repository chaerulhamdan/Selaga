import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:selaga_ver1/repositories/api_repository.dart';
import 'package:selaga_ver1/repositories/models/user_profile_model.dart';
import 'package:selaga_ver1/repositories/providers.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Profile'),
      ),
      body: Consumer<Token>(
        builder: (context, myToken, child) => FutureBuilder(
          future: ApiRepository().getMyProfile(myToken.token),
          builder: (context, snapshot) {
            if (snapshot.hasData &&
                snapshot.connectionState == ConnectionState.done) {
              UserProfileModel? profile = snapshot.data?.result;
              return Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Center(
                          child: CircleAvatar(
                            // backgroundColor: Colors.grey,
                            radius: 50,
                          ),
                        ),
                        const SizedBox(height: 30.0),
                        ListTile(
                          title: const Text('Nama'),
                          subtitle: Text(profile?.name ?? 'no data'),
                        ),
                        const Divider(
                          indent: 15,
                          endIndent: 15,
                        ),
                        ListTile(
                          title: const Text('Telepon'),
                          subtitle: Text(profile?.phone ?? 'no data'),
                        ),
                        const Divider(
                          indent: 15,
                          endIndent: 15,
                        ),
                        ListTile(
                          title: const Text('Email'),
                          subtitle: Text(profile?.email ?? 'no data'),
                        ),
                        const Divider(
                          indent: 15,
                          endIndent: 15,
                        ),
                        ListTile(
                          onTap: () async {
                            var data =
                                await ApiRepository().userLogout(myToken.token);

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
                                  duration: const Duration(milliseconds: 1100),
                                ),
                              );
                            }
                          },
                          title: const Text('Keluar'),
                          trailing: const Icon(Icons.logout),
                        ),
                        const Divider(
                          indent: 15,
                          endIndent: 15,
                        ),
                        const SizedBox(height: 15.0),
                      ],
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
      ),
    );
  }
}
