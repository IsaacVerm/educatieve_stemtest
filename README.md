# De stemtest

De stemtest gaat door een aantal stellingen voor te leggen na welke partijen het best bij je aansluiten.

De stemtest bestaat uit 3 stappen:

* de gebruiker antwoordt op stellingen met eens of oneens
* de gebruiker geeft aan hoe belangrijk een aantal thema's voor hem zijn
* een percentage wordt weergegeven dat de verwantschap met elke partij aangeeft

De relatie tussen de antwoorden op de stellingen en het eindresultaat wordt op 2 manieren beïnvloed:

* door het kiezen van thema's
* doordat niet alle stellingen hetzelfde gewicht hebben

# Doel

De bedoeling is om na te gaan of een verstoring inherent aanwezig is in de stemtest. Een verstoring kan zich op 2 manieren uiten. Ten eerste kan het zijn dat de stellingen de focus leggen op bepaalde domeinen ten koste van andere. Ten tweede is het ook mogelijk dat de gewichten van de stellingen bepaalde partijen beter uitkomen dan andere.

# Stappen

* data ophalen
	* verdeling partijen over stellingen
	* gewichten stellingen
	* thema geassocieerd aan elke stelling
* nagaan hoe een score berekend wordt
	* testen selenium
	* vergelijken met data
* verschilanalyse partijen

## Data ophalen

## Berekening score

### Gewichten stellingen

#### Code

Dit wordt [hier](/analysis/scripts/score_mechanism)  onderzocht.

De gewichten van elk thema worden op 0 gezet zodat de thema's geen invloed op het eindresultaat uitoefenen.

Als men het oneens is met een bepaalde partij wordt resultaat 0 gegeven, als men het wel eens is wordt resultaat 1 gegeven.

#### Naïve interpretatie

Er wordt nagegaan of het resultaat gelijk is aan het product van de uitslag op de stelling met het gewicht van een partij voor die stelling.

Dit blijkt zeer sterk bij de realiteit te liggen, maar toch niet volledig: 

![Verschil in verwachte en echte score](/analysis/output/score_mechanism/difference_by_test.png)

### Thema's
