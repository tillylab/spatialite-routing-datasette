#!/bin/zsh
export DATASETTE_LOAD_PLUGINS="datasette-darkmode,datasette-leaflet,datasette-geojson,datasette-geojson-map,datasette-query-files"
datasette ${0:a:h} $@ --load-extension spatialite 