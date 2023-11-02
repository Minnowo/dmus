
import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import '../../Util.dart';
import 'ReleaseResponseData.dart';



/// For fetching data from the MusicBrainz search api
final class MusicBrainzSearchAPI {

  MusicBrainzSearchAPI._();

  static const String _apiDomain = "musicbrainz.org";
  static const String _apiBase = "/ws/2";
  static const String _searchArtistBase = "$_apiBase/artist";
  static const String _searchReleaseBase = "$_apiBase/release";
  static const String _searchRecordingBase = "$_apiBase/recording";

  static const String _fmtJson = "json";
  static const int _limitMax = 100;
  static const int _limitMin = 1;

  static http.Client? _httpClient;


  static get httpClient {

    _httpClient ??= http.Client();

    return _httpClient;
  }

  static void destroyClient(){
    _httpClient?.close();
    _httpClient = null;
  }


  static Future<List<ReleaseSearchResult>> releaseSearchRaw(String searchTerm, int results) async {

    final Uri url = Uri.https(_apiDomain, _searchReleaseBase, {
      "query" : searchTerm,
      "fmt" : _fmtJson,
      "limit" : max(_limitMin, min(results, _limitMax)).toString(),
    });

    logging.info("Making get to $url");

    var response = await httpClient.get(url);

    var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;

    const releaseKey = "releases";
    
    if(decodedResponse.containsKey(releaseKey)) {

      List<dynamic> d = decodedResponse[releaseKey];
      
      var a = d.map((e) => ReleaseSearchResult.fromJson(e)).toList();
      
      return a;
    }

    return [];
  }


  static Future<List<ReleaseSearchResult>> recordingSearchRaw(String searchTerm, int results) async {

    final Uri url = Uri.https(_apiDomain, _searchReleaseBase, {
      "query" : searchTerm,
      "fmt" : _fmtJson,
      "limit" : max(_limitMin, min(results, _limitMax)).toString(),
    });

    logging.info("Making get to $url");

    var response = await httpClient.get(url);

    var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;

    // TODO: finish this
    const releaseKey = "releases";

    if(decodedResponse.containsKey(releaseKey)) {

      // List<dynamic> d = decodedResponse[releaseKey];
      //
      // var a = d.map((e) => ReleaseSearchResult.fromJson(e)).toList();
      //
      // return a;
    }

    return [];
  }
}
