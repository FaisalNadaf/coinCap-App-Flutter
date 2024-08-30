// ignore: file_names
import 'package:dio/dio.dart';
import '../models/app_config.dart';
import 'package:get_it/get_it.dart';

class HTTPService {
  final Dio dio = Dio();
  late final AppConfig _appConfig;
  late final String _baseUrl;

  HTTPService() {
    _appConfig = GetIt.instance.get<AppConfig>();
    _baseUrl = _appConfig.COIN_API_BASE_URL;
  }

  Future<Response?> get(String path) async {
    try {
      String _url = "$_baseUrl$path";
      Response _response = await dio.get(_url);
      if (_response.statusCode == 200) {
        return _response;
      } else {
        throw Exception('Failed to load data: ${_response.statusCode}');
      }
    } on DioException catch (dioError) {
      print("HTTPService: DioError encountered");
      print(dioError.message);
      return dioError.response; // Return response even if there's an error
    } catch (e) {
      print("HTTPService: An error occurred while performing the GET request");
      print(e);
      return null; // Explicitly returning null if there's an error
    }
  }
}
