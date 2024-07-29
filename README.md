# SpatiaLite Routing Datasette

This is an experiment to explores SpatiaLite's routing capabilities using Datasette.

<img src="../assets/spatialite-routing-2.png" width="400" alt="screenshot">

It is based on the introduction to virtual routing in SpatiaLite which can be found [here](https://www.gaia-gis.it/fossil/libspatialite/wiki?name=VirtualRouting).

We'll recreate the example in Datasette step by step:

## 1. Download the Database

This is a SpatiaLite database containing a full road network from the Tuscany region in Italy.  

It featues:
- roads represented as 3D LineString, speed in km/h, cost (time to travel in seconds)
- house numbers representeed as 3D Points
- names etc.

Download the database [here](https://www.gaia-gis.it/gaia-sins/routing-sample-5.0.0.7z).

In my case the download was very slow and aborted several times. I finally used `wget` which automatically resumes aborted downloads.

Once downloaded, extract the database using 7zip:

```sh
7zz x routing-sample-5.0.0.7z 
```

## 2. Extensions

The `spatialite` extension is required for geographic queries. See [datasette documentation](https://docs.datasette.io/en/stable/spatialite.html) on how to install it.


## 3. Create Routing Tables

Make sure you have `spatialite` installed and open the database:

```sh
spatialite routing-sample-5.0.0.sqlite
```

Create a "routing table" for pedestrians:

```sql
SELECT CreateRouting('byfoot_data', 'byfoot', 'roads_vw', 'node_from', 'node_to', 'geom', NULL, 'toponym', 1, 1);
```

(This actually creates two tables: `byfoot` and `byfoot_data`).

Now let's create another routing table for cars:

```sql
SELECT CreateRouting('bycar_data', 'bycar', 'roads_vw', 'node_from', 'node_to', 'geom', 'cost', 'toponym', 1, 1, 'oneway_fromto', 'oneway_tofrom', 0);
```

Finally, lets duplicate the last table (so we can lookup two routes without crashing spatialite)

```sql
SELECT CreateRouting('bycar2_data', 'bycar2', 'roads_vw', 'node_from', 'node_to', 'geom', 'cost', 'toponym', 1, 1, 'oneway_fromto', 'oneway_tofrom', 0);
```

## 4. Plugins
The following plugins are used in this experiment:

- **datasette-darkmode** (optional)  
  *to show the datasette in darkmode (including the sql editor)*
- [datasette-geojson-map](https://datasette.io/plugins/datasette-geojson-map)  
  *render a map for any query with a geometry column*
- [datasette-geojson](https://datasette.io/plugins/datasette-geojson)  
  *to add GeoJSON as an output option for datasette queries*
- [datasette-leaflet](https://datasette.io/plugins/datasette-leaflet)  
  *to add the Leaflet JavaScript library.   
  (required by datasette-leaflet-geojson)*
- [sqlite-colorbrewer](https://datasette.io/plugins/sqlite-colorbrewer)  
  *to use ColorBrewer scales in SQLite queries*
- [datasette-query-files](https://datasette.io/plugins/datasette-query-files)  
  *to read Datasette canned queries from plain SQL files*

They can be installed using `datasette install`.

## 5. Start Datasette
The `start.sh` script loads extensions and plugins.

## 6. Canned Queries

A couple of [canned queries](https://docs.datasette.io/en/latest/sql_queries.html#canned-queries) have been added to the configuration:

### 6.1 Shortest Path

*Use the virtual routing table to find the fastest route by car.*

<img src="../assets/spatialite-routing-1.png" width="400" alt="screenshot">

Link: http://localhost:8001/routing-sample/01-shortest-path-car

### 6.2 Multiple Shortest Paths

*Use the virtual routing table to find multiple shortest paths*

<img src="../assets/spatialite-routing-2.png" width="400" alt="screenshot">

Link: http://localhost:8001/routing-sample/02-shortest-path-all

#### The query combines:

- the fastest road by car (fat blue line)
- the fastest road back (fat red line)
- the shortest road on foot (thin black line)

#### Note:

- We use `Transform(Geometry, 4326)` since the original coordinates are not in lat lon format.
- we use aditional styling suchs as `stroke-width` and `opacity` so lines that overlay each other are still recognizable
- we use `AsGeoJSON(...)` to get the geometries in GeoJSON format (optional).
- We use `UNION ALL` to combine the results of the three queries. 
- there is currently a bug in SpatiaLite which prevents us from using the same routing table twice in a single database query (that's why we are using `bycar` and `bycar2` here)

### 6.3. Multi-Destination I
*Show a source, several targets and and the routes towards those targets on the map.*

<img src="../assets/spatialite-routing-3.png" width="400" alt="screenshot">

Link: http://localhost:8001/routing-sample/03-multi-destination

#### Note:

- We are using spatialite's `ST_Collect` function to combine several geometries into one.
- This way we lose the ability to style the markers and routes using the simplestyle spec provided by datasette-geojson-map

### 6.4. Multi-Destination II

*Alternatively we can create three tables, one for each graphical attribute we are interested in. (route, start label, end label)*

<img src="../assets/spatialite-routing-4.png" width="400" alt="screenshot">

Link: 
http://localhost:8001/routing-sample/04-multi-destination-2

### 6.5 Isochrone Maps

*Isochrones mark the distance on a map that can be reached within the same time.*

<img src="../assets/spatialite-routing-5.png" width="400" alt="screenshot">


See wikipedia article on [isochrone maps](https://en.wikipedia.org/wiki/Isochrone_map)

#### Links

Here are four variations:

- http://localhost:8001/routing-sample/05-isochrone-lines-single
- http://localhost:8001/routing-sample/06-isochrone-lines-multi
- http://localhost:8001/routing-sample/07-isochrone-lines-custom?distance=1000
- http://localhost:8001/routing-sample/08-isochrone-lines-or-targets?show_targets=1


### 6.6 Isochrone Trails

<img src="../assets/spatialite-routing-6.png" width="400" alt="screenshot">

*Isochrone trails convey more information and are visually more appealing.*

#### Links

Here are two variations:

- http://localhost:8001/routing-sample/09-isochrone-trails-black?node_id=1000&distance=3000
- http://localhost:8001/routing-sample/10-isochrone-trails-colored?node_id=1000&distance=3000
