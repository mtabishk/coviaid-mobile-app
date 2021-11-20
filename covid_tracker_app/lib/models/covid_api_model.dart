class CovidAPIModel {
  CovidAPIModel(
      {required this.totalCases,
      required this.recoveryCases,
      required this.deathCases,
      required this.lastUpdate,
      required this.currentlyInfected,
      required this.generalDeathRate});

  final totalCases;
  final recoveryCases;
  final deathCases;
  final lastUpdate;
  final currentlyInfected;
  final generalDeathRate;
}
