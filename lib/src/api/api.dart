import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:tomsoft_app/src/data/data.dart';

@Injectable()
class Api {
  final Dio _dio = Dio();
  final String _baseUrl = 'http://apidemo.luceed.hr/datasnap/rest';
  static const credentials = 'luceed_mb:7e5y2Uza';
  final auth = 'Basic ${base64Encode(utf8.encode(credentials))}';

  Future<List<Skladista>> getSkladista() async {
    try {
      final response = await _dio.get(
        '$_baseUrl/skladista/lista',
        options: Options(
          headers: {
            'Authorization': auth,
          },
        ),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = response.data;

        List<dynamic> vrstePlacanjaList = data['result'][0]['skladista'];
        List<Skladista> items = List<Skladista>.from(
          vrstePlacanjaList
              .map((dynamic vrstaPlacanja) => Skladista.fromMap(vrstaPlacanja)),
        );
        return items;
      } else {
        return [];
      }
    } catch (error) {
      return [];
    }
  }

  Future<List<Artikl>> getArtikls({String? searchText}) async {
    try {
      final response = await _dio.get(
        '$_baseUrl/artikli/naziv/$searchText',
        options: Options(
          headers: {
            'Authorization': auth,
          },
        ),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = response.data;

        List<dynamic> artikliList = data['result'][0]['artikli'];
        List<Artikl> items = List<Artikl>.from(
          artikliList.map((dynamic artikl) => Artikl.fromMap(artikl)),
        );
        return items;
      } else {
        return [];
      }
    } catch (error) {
      return [];
    }
  }

  Future<List<ObracunPlacanja>> getObracunPlacanja(
      {required String paymentId,
      required String startDate,
      String? endDate}) async {
    try {
      final response = await _dio.get(
        '$_baseUrl/mpobracun/placanja/$paymentId/$startDate',
        options: Options(
          headers: {
            'Authorization': auth,
          },
        ),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = response.data;

        List<dynamic> obracunList = data['result'][0]['obracun_placanja'];
        List<ObracunPlacanja> items = List<ObracunPlacanja>.from(
          obracunList.map((dynamic artikl) => ObracunPlacanja.fromMap(artikl)),
        );
        return items;
      } else {
        return [];
      }
    } catch (error) {
      return [];
    }
  }

  Future<List<ObracunProizvoda>> getObracunProizvoda(
      {required String paymentId,
      required String startDate,
      String? endDate}) async {
    try {
      final response = await _dio.get(
        '$_baseUrl/mpobracun/artikli/$paymentId/$startDate',
        options: Options(
          headers: {
            'Authorization': auth,
          },
        ),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = response.data;

        List<dynamic> obracunList = data['result'][0]['obracun_artikli'];
        List<ObracunProizvoda> items = List<ObracunProizvoda>.from(
          obracunList.map((dynamic artikl) => ObracunProizvoda.fromMap(artikl)),
        );
        return items;
      } else {
        return [];
      }
    } catch (error) {
      return [];
    }
  }
}
