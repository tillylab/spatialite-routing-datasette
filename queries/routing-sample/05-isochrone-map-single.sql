SELECT
    ST_ConcaveHull (ST_Collect (Transform (Geometry, 4326))) AS geometry
FROM
    byfoot
WHERE
    NodeFrom = 181999
    AND Cost <= 2000