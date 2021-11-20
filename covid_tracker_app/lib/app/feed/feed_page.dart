import 'package:covid_tracker_app/common_widgets/custom_list_card.dart';
import 'package:covid_tracker_app/services/covid_api.dart';
import 'package:flutter/material.dart';

class FeedPage extends StatefulWidget {
  FeedPage({Key? key}) : super(key: key);

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  var covidData;
  List<CustomListCard> covidAPIList = [];

  Future<void> _getCovidCases() async {
    try {
      covidData = await CovidAPI().getStateWiseData();
    } catch (e) {
      return Future.error(e);
    } finally {
      if (this.mounted) {
        setState(() {});
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _getCovidCases();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Feed"),
        centerTitle: true,
        elevation: 1.0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: RefreshIndicator(
          onRefresh: () => _refreshPage(),
          child: ListView(
            children: [
              Text("Covid Stats", style: TextStyle(fontSize: 18.0)),
              covidData != null
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CustomListCard(
                            data: covidData.totalCases, title: "Total Cases"),
                        CustomListCard(
                            data: covidData.recoveryCases,
                            title: "Recovery Cases"),
                        CustomListCard(
                            data: covidData.deathCases, title: "Death Cases"),
                        CustomListCard(
                            data: covidData.currentlyInfected,
                            title: "Currently Infected"),
                        CustomListCard(
                            data: covidData.generalDeathRate,
                            title: "General Death Rate"),
                      ],
                    )
                  : LinearProgressIndicator(),
              SizedBox(height: 16.0),
              Text("Latest Covid 19 News", style: TextStyle(fontSize: 18.0)),
              SizedBox(height: 8.0),
              Image.asset("assets/news1.jpg"),
              ListTile(
                title: Text(
                    "Covaxin gets emergency use approval for kids aged 2-18 years"),
                subtitle: Text(
                    "The Subject Expert Committee on Covid-19 has granted emergency use approval to Bharat Biotech's Covaxin for children in the 2-18 years age group."),
              ),
              SizedBox(height: 8.0),
              Image.asset("assets/news2.jpg"),
              ListTile(
                title: Text("J-K logs 80 COVID-19 cases"),
                subtitle: Text(
                    "Jammu and Kashmir on Tuesday recorded 80 new coronavirus cases that pushed its infection tally to 3,30,666, while no fresh deaths were reported, officials said."),
              ),
              SizedBox(height: 8.0),
              Image.asset("assets/news3.jpg"),
              ListTile(
                // leading: Image.asset("assets/latest/news1.jpg"),
                title: Text(
                    "Non-vaccinated people less likely to contract Covid-19 if family members have been administered jabs"),
                subtitle: Text(
                    "The study findings showed that people with no immunity against Covid-19 had a 45% to 97% lower risk of infection and hospitalisation due to the disease as the number of family members who are immune, either via vaccination or previous contraction, increases."),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _refreshPage() async {
    if (this.mounted) {
      setState(() {});
    }
  }
}
