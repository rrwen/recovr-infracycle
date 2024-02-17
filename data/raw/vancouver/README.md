# Vancouver Raw Data

Bikeways Excel (`bikeways.xlsx`) and GeoJSON (`bikeways.geojson`) data downloaded on February 17, 2024 from City of Vancouver Open Data Portal: https://opendata.vancouver.ca/explore/dataset/bikeways

* `bikeways.xlsx`: original bikeways data from city of Vancouver covering 3667 bikeways
* `bikeways.geojson`: geospatial format of the bikeways.xlsx data

Verified bikeways Excel (`A1_Vancouver Bikeways for Matching Revised.xlsx`) and CSV (`van_bike_July24Key.csv`) data prepared by Konrad Samsel <konrad.samsel@mail.utoronto.ca> using document `Vancouver Bikeway Data Management Protocols.docx` shared by Brice Batomen <brice.kuimi@utoronto.ca>, where original paths are shown below:

* `Vancouver Bikeway Data Management Protocols.docx`: Document for data entry procedures of verified bikeways data at Konrad/1_Vancouver Data/1_Bikeways/2_Vancouver Bikeways Data Entry/Vancouver Bikeway Data Management Protocols.docx
* `A1_Vancouver Bikeways for Matching Revised.xlsx`: Revised verified bikeways data entry file of 780 eligible road segments using Google StreetView and satellite imagery at Konrad/1_Vancouver Data/1_Bikeways/3_Vancouver Bikeway Data Analysis/A1_Vancouver Bikeways for Matching Revised.xlsx
* `van_bike_July24Key.csv`: Final verified bikeways data of 745 road segments after exclusion criteria at Konrad/1_Vancouver Data/1_Bikeways/3_Vancouver Bikeway Data Analysis/van_bike_July24Key.csv

## Data Relationships

```mermaid
graph TD

city["Open Data (n=3667)<br>bikeways.xlsx"]
entry["Eligible (n=780)<br>A1_Vancouver Bikeways for Matching Revised.xlsx"]
processed["Inclusions (n=745)<br>van_bike_July24Key.csv"]

city --> entry --> processed
```

## Contact

* Richard Wen <rrwen.dev@gmail.com>