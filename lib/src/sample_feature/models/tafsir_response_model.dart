class TafsirResponseModel {
  int? code;
  String? message;
  Data? data;

  TafsirResponseModel({this.code, this.message, this.data});

  TafsirResponseModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? nomor;
  String? nama;
  String? namaLatin;
  int? jumlahAyat;
  String? tempatTurun;
  String? arti;
  String? deskripsi;
  AudioFull? audioFull;
  List<Tafsir>? tafsir;
  SuratSelanjutnya? suratSelanjutnya;
  SuratSelanjutnya? suratSebelumnya;

  Data(
      {this.nomor,
      this.nama,
      this.namaLatin,
      this.jumlahAyat,
      this.tempatTurun,
      this.arti,
      this.deskripsi,
      this.audioFull,
      this.tafsir,
      this.suratSelanjutnya,
      this.suratSebelumnya});

  Data.fromJson(Map<String, dynamic> json) {
    nomor = json['nomor'];
    nama = json['nama'];
    namaLatin = json['namaLatin'];
    jumlahAyat = json['jumlahAyat'];
    tempatTurun = json['tempatTurun'];
    arti = json['arti'];
    deskripsi = json['deskripsi'];
    audioFull = json['audioFull'] != null
        ? AudioFull.fromJson(json['audioFull'])
        : null;
    if (json['tafsir'] != null) {
      tafsir = <Tafsir>[];
      json['tafsir'].forEach((v) {
        tafsir!.add(Tafsir.fromJson(v));
      });
    }
    suratSelanjutnya = () {
      try {
        return SuratSelanjutnya.fromJson(json['suratSelanjutnya']);
      } catch (e) {
        return null;
      }
    }();
    suratSebelumnya = () {
      try {
        return SuratSelanjutnya.fromJson(json['suratSebelumnya']);
      } catch (e) {
        return null;
      }
    }();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['nomor'] = nomor;
    data['nama'] = nama;
    data['namaLatin'] = namaLatin;
    data['jumlahAyat'] = jumlahAyat;
    data['tempatTurun'] = tempatTurun;
    data['arti'] = arti;
    data['deskripsi'] = deskripsi;
    if (audioFull != null) {
      data['audioFull'] = audioFull!.toJson();
    }
    if (tafsir != null) {
      data['tafsir'] = tafsir!.map((v) => v.toJson()).toList();
    }
    if (suratSelanjutnya != null) {
      data['suratSelanjutnya'] = suratSelanjutnya!.toJson();
    }
    if (suratSebelumnya != null) {
      data['suratSebelumnya'] = suratSebelumnya!.toJson();
    }
    return data;
  }
}

class AudioFull {
  String? s01;
  String? s02;
  String? s03;
  String? s04;
  String? s05;

  AudioFull({this.s01, this.s02, this.s03, this.s04, this.s05});

  AudioFull.fromJson(Map<String, dynamic> json) {
    s01 = json['01'];
    s02 = json['02'];
    s03 = json['03'];
    s04 = json['04'];
    s05 = json['05'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['01'] = s01;
    data['02'] = s02;
    data['03'] = s03;
    data['04'] = s04;
    data['05'] = s05;
    return data;
  }
}

class Tafsir {
  int? ayat;
  String? teks;

  Tafsir({this.ayat, this.teks});

  Tafsir.fromJson(Map<String, dynamic> json) {
    ayat = json['ayat'];
    teks = json['teks'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ayat'] = ayat;
    data['teks'] = teks;
    return data;
  }
}

class SuratSelanjutnya {
  int? nomor;
  String? nama;
  String? namaLatin;
  int? jumlahAyat;

  SuratSelanjutnya({this.nomor, this.nama, this.namaLatin, this.jumlahAyat});

  SuratSelanjutnya.fromJson(Map<String, dynamic> json) {
    nomor = json['nomor'];
    nama = json['nama'];
    namaLatin = json['namaLatin'];
    jumlahAyat = json['jumlahAyat'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['nomor'] = nomor;
    data['nama'] = nama;
    data['namaLatin'] = namaLatin;
    data['jumlahAyat'] = jumlahAyat;
    return data;
  }
}
