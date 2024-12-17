import 'package:flutter/material.dart';
import 'package:tes_mcf/src/config/dio_config.dart';
import 'package:tes_mcf/src/sample_feature/models/surat_response_model.dart';

import '../settings/settings_view.dart';
import 'surat_details_view.dart';

class SuratListView extends StatefulWidget {
  const SuratListView({
    super.key,
  });

  static const routeName = '/';

  @override
  State<SuratListView> createState() => _SuratListViewState();
}

class _SuratListViewState extends State<SuratListView> {
  Key _refreshKey = UniqueKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Surat List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Navigate to the settings page. If the user leaves and returns
              // to the app after it has been killed while running in the
              // background, the navigation stack is restored.
              Navigator.restorablePushNamed(context, SettingsView.routeName);
            },
          ),
        ],
      ),
      body: FutureBuilder(
        key: _refreshKey,
        future: dio.get('/api/v2/surat'),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Error: ${snapshot.error}'),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _refreshKey = UniqueKey();
                    });
                  },
                  child: Text('Refresh'),
                ),
              ],
            );
          }

          final model = SuratResponseModel.fromJson(snapshot.data?.data);
          final items = model.data ?? [];

          return ListView.builder(
            restorationId: 'SuratListView',
            itemCount: items.length,
            itemBuilder: (BuildContext context, int index) {
              final item = items[index];

              return ListTile(
                title: Text('${item.nama}'),
                subtitle: Text('${item.namaLatin}'),
                leading: Text('${item.nomor}'),
                onTap: () {
                  Navigator.restorablePushNamed(
                    context,
                    SuratDetailsVIew.routeName,
                    arguments: item.nomor,
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
