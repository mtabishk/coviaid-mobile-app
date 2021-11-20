import 'package:covid_tracker_app/models/covid_api_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class CovidAPI {
  final endpoint = "https://corona-virus-stats.herokuapp.com";

  Future<CovidAPIModel> getStateWiseData() async {
    var url = Uri.parse('$endpoint/api/v1/cases/general-stats');
    print(url);

    var response = await http.get(url).timeout(
          Duration(seconds: 4),
        );
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);

      return CovidAPIModel(
        totalCases: jsonResponse['data']['total_cases'],
        recoveryCases: jsonResponse['data']['recovery_cases'],
        deathCases: jsonResponse['data']['death_cases'],
        lastUpdate: jsonResponse['data']['last_update'],
        currentlyInfected: jsonResponse['data']['currently_infected'],
        generalDeathRate: jsonResponse['data']['general_death_rate'],
      );
    } else {
      print('Request failed with status: ${response.statusCode}.');
      throw response;
    }
  }
}
