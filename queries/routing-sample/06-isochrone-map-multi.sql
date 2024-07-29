SELECT
  ST_ConcaveHull (ST_Collect (Transform (Geometry, 4326))) AS geometry
FROM
  byfoot
WHERE
  NodeFrom = 181999
  AND Cost <= 1000
UNION ALL
SELECT
  ST_ConcaveHull (ST_Collect (Transform (Geometry, 4326))) AS geometry
FROM
  byfoot2
WHERE
  NodeFrom = 181999
  AND Cost <= 2000
UNION ALL
SELECT
  ST_ConcaveHull (ST_Collect (Transform (Geometry, 4326))) AS geometry
FROM
  byfoot3
WHERE
  NodeFrom = 181999
  AND Cost <= 3000