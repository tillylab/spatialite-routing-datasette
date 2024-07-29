/* 
This query shows all points that can be reached from node 5000 by foot 
at a distance of 1000 meters.

It shows a combined geometry:
- start marker + target hull (if show_targets is empty)
- start marker + target markers (otherwise)

*/

WITH 
-- extract  startnode from the roads geometry
start_node AS (
  SELECT
    Transform(ST_StartPoint(geom), 4326) AS geometry
  FROM
    roads
  WHERE
    node_from = 10000
  LIMIT
    1
), 
-- get the concave hull of all possible targets below a certain distance
target_hull AS (
  SELECT
    ST_ConcaveHull(ST_Collect(Transform(Geometry, 4326))) AS geometry
  FROM
    byfoot
  WHERE
    NodeFrom = 10000
    AND Cost <= 1000
)
-- combinde the start node and the target-hull or the points of the target hull respectively
SELECT
  ST_Collect(
    (SELECT geometry FROM start_node),
    CASE
      WHEN :show_targets != "" THEN 
        DissolvePoints((SELECT geometry FROM target_hull))
      ELSE 
        (SELECT geometry FROM target_hull)
    END
  ) AS geometry
FROM
  target_hull