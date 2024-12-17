import 'package:flutter/material.dart';
import 'package:tes_mcf/src/config/dio_config.dart';
import 'package:tes_mcf/src/sample_feature/models/tafsir_response_model.dart';

class TafsirView extends StatefulWidget {
  final int? suratNumber;
  const TafsirView({
    super.key,
    this.suratNumber,
  });

  static const routeName = '/tafsir';

  @override
  State<TafsirView> createState() => _TafsirViewState();
}

class _TafsirViewState extends State<TafsirView> {
  Key _refreshKey = UniqueKey();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      key: _refreshKey,
      future: dio
          .get('/api/v2/tafsir/${widget.suratNumber}')
          .then((value) => TafsirResponseModel.fromJson(value.data)),
      builder: (context, snapshot) {
        return Scaffold(
          appBar: AppBar(
            title: () {
              if (snapshot.connectionState != ConnectionState.done) {
                return Text('Loading...');
              }
              final name = snapshot.data?.data?.namaLatin ?? '';
              return Text('Tafsir $name');
            }(),
          ),
          body: Builder(
            builder: (context) {
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
                      child: Text('Retry'),
                    ),
                  ],
                );
              }

              final model = snapshot.data;
              final data = model?.data;

              return ListView(
                children: [
                  ListTile(
                    title: Text('Name'),
                    subtitle: Text(data?.nama ?? ''),
                  ),
                  ListTile(
                    title: Text('Name (Latin)'),
                    subtitle: Text(data?.namaLatin ?? ''),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: data?.tafsir?.length ?? 0,
                    itemBuilder: (context, index) {
                      final item = data?.tafsir?[index];
                      return ListTile(
                        title: Text(
                          item?.teks ?? '',
                        ),
                      );
                    },
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
