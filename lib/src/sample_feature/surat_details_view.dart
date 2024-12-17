import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:tes_mcf/src/config/dio_config.dart';
import 'package:tes_mcf/src/sample_feature/models/detail_surat_response_model.dart';
import 'package:tes_mcf/src/sample_feature/tafsir_view.dart';

class SuratDetailsVIew extends StatefulWidget {
  final int? suratNumber;
  const SuratDetailsVIew({
    super.key,
    this.suratNumber,
  });

  static const routeName = '/surah';

  @override
  State<SuratDetailsVIew> createState() => _SuratDetailsVIewState();
}

class _SuratDetailsVIewState extends State<SuratDetailsVIew> {
  Key _refreshKey = UniqueKey();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      key: _refreshKey,
      future: dio
          .get('/api/v2/surat/${widget.suratNumber}')
          .then((value) => DetailSuratResponseModel.fromJson(value.data)),
      builder: (context, snapshot) {
        return Scaffold(
          appBar: AppBar(
            title: () {
              if (snapshot.connectionState != ConnectionState.done) {
                return Text('Loading...');
              }
              final name = snapshot.data?.data?.namaLatin ?? '';
              return Text('Surah $name');
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
                  OverflowBar(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            TafsirView.routeName,
                            arguments: data?.nomor,
                          );
                        },
                        child: Text('Lihat Tafsir'),
                      ),
                    ],
                  ),
                  ListTile(
                    title: Text('Name (Latin)'),
                    subtitle: Text(data?.namaLatin ?? ''),
                  ),
                  ListTile(
                    title: Text('Number of Ayahs'),
                    subtitle: Text(data?.jumlahAyat.toString() ?? ''),
                  ),
                  ListTile(
                    title: Text('Place of Revelation'),
                    subtitle: Text(data?.tempatTurun ?? ''),
                  ),
                  ListTile(
                    title: Text('Meaning'),
                    subtitle: Text(data?.arti ?? ''),
                  ),
                  ListTile(
                    title: Text('Description'),
                    subtitle: Text(data?.deskripsi ?? ''),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: data?.ayat?.length ?? 0,
                    itemBuilder: (context, index) {
                      final item = data?.ayat?[index];
                      return ListTileAyat(
                        ayat: item,
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

class ListTileAyat extends StatefulWidget {
  final Ayat? ayat;
  const ListTileAyat({
    super.key,
    this.ayat,
  });

  @override
  State<ListTileAyat> createState() => _ListTileAyatState();
}

class _ListTileAyatState extends State<ListTileAyat> {
  bool isPlaying = false;
  bool isloading = false;
  final player = AudioPlayer();

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    player.onPlayerStateChanged.listen((event) {
      if (event == PlayerState.completed || event == PlayerState.stopped) {
        if (mounted) {
          setState(() {
            isPlaying = false;
          });
        }
      }
      if (event == PlayerState.playing) {
        if (mounted) {
          setState(() {
            isPlaying = true;
          });
        }
      }
    });
    return ListTile(
      leading: IconButton(
        icon: Builder(builder: (context) {
          if (isloading) {
            return SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
              ),
            );
          }
          return Icon(isPlaying ? Icons.pause : Icons.play_arrow);
        }),
        onPressed: () async {
          if (isloading) {
            return;
          }
          setState(() {
            isloading = true;
          });
          if (isPlaying) {
            await player.pause();
          } else {
            if (widget.ayat?.audio?.s01 == null) {
              return;
            }
            await player.play(UrlSource(
              widget.ayat?.audio?.s01 ?? '',
            ));
          }
          setState(() {
            isloading = false;
          });
        },
      ),
      title: Text(
        widget.ayat?.teksArab ?? '',
        style: TextStyle(fontSize: 24),
        textAlign: TextAlign.right,
      ),
      subtitle: Column(
        spacing: 8,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.ayat?.teksLatin ?? ''),
          Text(widget.ayat?.teksIndonesia ?? ''),
        ],
      ),
    );
  }
}
